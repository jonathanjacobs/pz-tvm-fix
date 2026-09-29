-- Server-authoritative policy for TVM automatic visual synchronization.
require "TVMPerformance/TVMPerformance_Config"
local Version = require "TVMPerformance/TVMPerformance_Version"

if not isServer() then return end

local M = TVMPerformance
M.Server = M.Server or {}

local INSTALL_RETRY_INTERVAL_MS = 1000
local INSTALL_RETRY_MAX_ATTEMPTS = 300

local BUILD_STATE_MODULE = "TVMPerformance"
local BUILD_STATE_REQUEST = "RequestBuildState"
local BUILD_STATE_COMMAND = "BuildState"
local BUILD_STATE_PROTOCOL_VERSION = 1
local BUILD_STATE_SCAN_INTERVAL_MS = 5000

local function nowMs()
    return getTimestampMs and getTimestampMs() or 0
end

local function playerKey(player)
    if not player then return "" end
    if player.getOnlineID then return tostring(player:getOnlineID() or "") end
    return tostring(player)
end

local function movedEnough(previous, x, y, z, threshold)
    if not previous then return true end
    if tonumber(previous.z) ~= tonumber(z) then return true end
    return math.max(math.abs((tonumber(previous.x) or 0) - x), math.abs((tonumber(previous.y) or 0) - y)) >= threshold
end

local function isVisualRuntime(args)
    return type(args) == "table" and tostring(args.source or "") == "visuals_runtime"
end

local function isVisualSnapshot(args)
    return isVisualRuntime(args) and tostring(args.uiType or "visuals") == "visuals"
end

local diagnostics = M.Server.diagnostics or { active = false, mode = nil, lastReport = 0 }
M.Server.diagnostics = diagnostics
local markerLogBySource = M.Server.markerLogBySource or {}
M.Server.markerLogBySource = markerLogBySource

local function logMarkerRefreshAttempt(source, now)
    if not M.diagnosticsEnabled() or now <= 0 then return end
    local sourceName = tostring(source or "inventory_change")
    local previous = markerLogBySource[sourceName] or 0
    if (now - previous) < 1000 then return end
    markerLogBySource[sourceName] = now
    print(string.format(
        "[TVMPerformance][server] marker_refresh_attempt mode=%s source=%s",
        M.visualSyncMode(),
        sourceName
    ))
end

local function resetDiagnostics(now, mode)
    diagnostics.active = true
    diagnostics.mode = mode
    diagnostics.lastReport = now
    diagnostics.registryPassed = 0
    diagnostics.registryForwarded = 0
    diagnostics.registryBlocked = 0
    diagnostics.registryThrottled = 0
    diagnostics.snapshotsPassed = 0
    diagnostics.snapshotsBlocked = 0
    diagnostics.markerRefreshes = 0
end

local function recordDiagnostic(name, amount, now)
    if now <= 0 or not M.diagnosticsEnabled() then
        diagnostics.active = false
        diagnostics.mode = nil
        return
    end
    local mode = M.visualSyncMode()
    if not diagnostics.active or diagnostics.mode ~= mode then
        resetDiagnostics(now, mode)
    end
    diagnostics[name] = (diagnostics[name] or 0) + (amount or 1)
    if (now - diagnostics.lastReport) < M.diagnosticsIntervalMs() then return end
    print(string.format(
        "[TVMPerformance][server] mode=%s registry passed=%d forwarded=%d blocked=%d throttled=%d snapshots passed=%d blocked=%d marker_refreshes=%d",
        diagnostics.mode,
        diagnostics.registryPassed,
        diagnostics.registryForwarded,
        diagnostics.registryBlocked,
        diagnostics.registryThrottled,
        diagnostics.snapshotsPassed,
        diagnostics.snapshotsBlocked,
        diagnostics.markerRefreshes
    ))
    resetDiagnostics(now, mode)
end

local function eventMapRefresh(registry, source)
    if M.visualSyncMode() ~= "event" or not (registry and registry.pushMapMarkers) then return end
    local now = nowMs()
    local sourceName = tostring(source or "inventory_change")
    registry.pushMapMarkers(nil, "tvm_performance_" .. sourceName, false)
    logMarkerRefreshAttempt(sourceName, now)
    recordDiagnostic("markerRefreshes", 1, now)
end

local function installRegistryHook()
    local registry = TVM and TVM.ServerRegistry or nil
    if type(registry) ~= "table" then return false end
    if not registry.TVMPerformanceOriginalSyncAll and type(registry.syncAllMachinesFromWorld) == "function" then
        local originalSyncAll = registry.syncAllMachinesFromWorld
        registry.syncAllMachinesFromWorld = function(...)
            local changed = originalSyncAll(...)
            if (tonumber(changed) or 0) > 0 then
                eventMapRefresh(registry, "inventory_change")
            end
            return changed
        end
        registry.TVMPerformanceOriginalSyncAll = originalSyncAll
    end
    if not registry.TVMPerformanceOriginalBumpRevision and type(registry.bumpRevision) == "function" then
        local originalBumpRevision = registry.bumpRevision
        registry.bumpRevision = function(machine, ...)
            local result = originalBumpRevision(machine, ...)
            eventMapRefresh(registry, "revision_change")
            return result
        end
        registry.TVMPerformanceOriginalBumpRevision = originalBumpRevision
    end
    return registry.TVMPerformanceOriginalSyncAll ~= nil and registry.TVMPerformanceOriginalBumpRevision ~= nil
end

local function installCommandHooks()
    local commands = TVM and TVM.ServerCommands or nil
    if type(commands) ~= "table" then return false end
    local installed = false

    if not commands.TVMPerformanceOriginalVisualSlice and type(commands.handleRequestVisualRegistrySlice) == "function" then
        local originalSlice = commands.handleRequestVisualRegistrySlice
        local lastByPlayer = {}
        commands.handleRequestVisualRegistrySlice = function(player, args)
            local now = nowMs()
            if not isVisualRuntime(args) or now <= 0 then return originalSlice(player, args) end
            local mode = M.visualSyncMode()
            if mode == "pass" then
                recordDiagnostic("registryPassed", 1, now)
                return originalSlice(player, args)
            end
            if mode == "event" then
                recordDiagnostic("registryBlocked", 1, now)
                return
            end
            local x, y, z = tonumber(args.x), tonumber(args.y), tonumber(args.z) or 0
            local key = playerKey(player)
            if not (x and y) or key == "" then
                recordDiagnostic("registryPassed", 1, now)
                return originalSlice(player, args)
            end
            local previous = lastByPlayer[key]
            local due = not previous or (now - previous.ts) >= M.visualSliceIntervalMs()
            local moved = movedEnough(previous, x, y, z, M.visualMovementThresholdTiles())
            if not due and not moved then
                recordDiagnostic("registryThrottled", 1, now)
                return
            end
            lastByPlayer[key] = { ts = now, x = x, y = y, z = z }
            recordDiagnostic("registryForwarded", 1, now)
            return originalSlice(player, args)
        end
        commands.TVMPerformanceOriginalVisualSlice = originalSlice
        installed = true
    end

    if not commands.TVMPerformanceOriginalVisualBatch and type(commands.handleRequestSnapshotsBatch) == "function" then
        local originalBatch = commands.handleRequestSnapshotsBatch
        commands.handleRequestSnapshotsBatch = function(player, args)
            if isVisualRuntime(args) and M.visualSyncMode() == "event" then
                recordDiagnostic("snapshotsBlocked", #(args.machineIds or {}), nowMs())
                return
            end
            if isVisualRuntime(args) then recordDiagnostic("snapshotsPassed", #(args.machineIds or {}), nowMs()) end
            return originalBatch(player, args)
        end
        commands.TVMPerformanceOriginalVisualBatch = originalBatch
        installed = true
    end

    if not commands.TVMPerformanceOriginalVisualSnapshot and type(commands.handleRequestSnapshot) == "function" then
        local originalSnapshot = commands.handleRequestSnapshot
        commands.handleRequestSnapshot = function(player, args)
            if isVisualSnapshot(args) and M.visualSyncMode() == "event" then
                recordDiagnostic("snapshotsBlocked", 1, nowMs())
                return
            end
            if isVisualSnapshot(args) then recordDiagnostic("snapshotsPassed", 1, nowMs()) end
            return originalSnapshot(player, args)
        end
        commands.TVMPerformanceOriginalVisualSnapshot = originalSnapshot
        installed = true
    end

    return installed or commands.TVMPerformanceOriginalVisualSlice ~= nil
end

local function install()
    local registryInstalled = installRegistryHook()
    local commandsInstalled = installCommandHooks()
    local installed = registryInstalled and commandsInstalled
    if installed and not M.Server.installLogged then
        M.Server.installLogged = true
        print(string.format(
            "[TVMPerformance][server] installed mode=%s registry_hook=true command_hooks=true",
            M.visualSyncMode()
        ))
    end
    return installed, registryInstalled, commandsInstalled
end

M.Server.install = install

local retryState = M.Server.installRetry or {
    registered = false,
    attempts = 0,
    nextAttemptAt = 0,
    fallbackTicks = 0,
}
M.Server.installRetry = retryState

local retryInstall

local function stopRetry()
    if retryState.registered and Events.OnTick and retryInstall then
        Events.OnTick.Remove(retryInstall)
    end
    retryState.registered = false
end

local function installFromLifecycleEvent()
    local installed = install()
    if installed then stopRetry() end
end

retryInstall = function()
    local now = nowMs()
    if now > 0 then
        if now < retryState.nextAttemptAt then return end
        retryState.nextAttemptAt = now + INSTALL_RETRY_INTERVAL_MS
    else
        retryState.fallbackTicks = retryState.fallbackTicks + 1
        if retryState.fallbackTicks < 60 then return end
        retryState.fallbackTicks = 0
    end

    retryState.attempts = retryState.attempts + 1
    local installed, registryInstalled, commandsInstalled = install()
    if installed then
        stopRetry()
        return
    end

    if retryState.attempts >= INSTALL_RETRY_MAX_ATTEMPTS then
        print(string.format(
            "[TVMPerformance][server] unavailable registry_hook=%s command_hooks=%s attempts=%d",
            tostring(registryInstalled),
            tostring(commandsInstalled),
            retryState.attempts
        ))
        stopRetry()
    end
end

local installed, registryInstalled, commandsInstalled = install()
if not installed then
    print(string.format(
        "[TVMPerformance][server] waiting registry_hook=%s command_hooks=%s retry_interval_ms=%d",
        tostring(registryInstalled),
        tostring(commandsInstalled),
        INSTALL_RETRY_INTERVAL_MS
    ))
    if Events.OnTick then
        retryState.registered = true
        Events.OnTick.Add(retryInstall)
    else
        print("[TVMPerformance][server] unavailable retry_event=false")
    end
end

if Events.OnInitGlobalModData then Events.OnInitGlobalModData.Add(installFromLifecycleEvent) end
if Events.OnServerStarted then Events.OnServerStarted.Add(installFromLifecycleEvent) end

-- Build stamp: log the build and effective settings once, after sandbox settings load.
local function logConfig()
    if M.Server.configLogged then return end
    M.Server.configLogged = true
    print(string.format(
        "[TVMPerformance][server] CONFIG | build=%s | mode=%s | diagnostics=%s | diagnostics_interval_s=%d | slice_interval_s=%d | movement_tiles=%d | snapshot_interval_s=%d",
        Version.BUILD_VERSION,
        M.visualSyncMode(),
        tostring(M.diagnosticsEnabled()),
        math.floor(M.diagnosticsIntervalMs() / 1000),
        math.floor(M.visualSliceIntervalMs() / 1000),
        M.visualMovementThresholdTiles(),
        math.floor(M.visualSnapshotIntervalMs() / 1000)
    ))
end

if Events.OnServerStarted then Events.OnServerStarted.Add(logConfig) else logConfig() end

-- Version handshake: send this server's build once to each player per connection.
-- A client's own request at OnGameStart arrives before the server has registered
-- the player and is lost (2026-09-29 smoke test), so the server sends instead,
-- once the player is in the online list. Finding new players is a local check;
-- the only network traffic is one BuildState per join.
local function sendBuildState(player)
    local ok, err = pcall(sendServerCommand, player, BUILD_STATE_MODULE, BUILD_STATE_COMMAND, {
        protocolVersion = BUILD_STATE_PROTOCOL_VERSION,
        buildVersion = Version.BUILD_VERSION,
    })
    if not ok and not M.Server.buildStateErrorLogged then
        M.Server.buildStateErrorLogged = true
        print("[TVMPerformance][server] ERROR | BuildState send failed: " .. tostring(err))
    end
end

local buildStateSent = {}
local nextBuildStateScanAt = 0

local function sendBuildStateToNewPlayers()
    local now = nowMs()
    if now <= 0 or now < nextBuildStateScanAt then return end
    nextBuildStateScanAt = now + BUILD_STATE_SCAN_INTERVAL_MS
    if type(getOnlinePlayers) ~= "function" then return end
    local players = getOnlinePlayers()
    if not players then return end

    local online = {}
    for i = 0, players:size() - 1 do
        local player = players:get(i)
        local key = playerKey(player)
        if key ~= "" then
            online[key] = true
            if not buildStateSent[key] then
                buildStateSent[key] = true
                sendBuildState(player)
            end
        end
    end
    -- Forget players who left, so a reconnect gets BuildState again.
    local gone = {}
    for key in pairs(buildStateSent) do
        if not online[key] then gone[#gone + 1] = key end
    end
    for i = 1, #gone do buildStateSent[gone[i]] = nil end
end

if Events.OnTickEvenPaused then
    Events.OnTickEvenPaused.Add(sendBuildStateToNewPlayers)
elseif Events.OnTick then
    Events.OnTick.Add(sendBuildStateToNewPlayers)
end

-- 0.3.0-beta clients also ask with RequestBuildState; keep answering them.
local function onClientCommand(module, command, player, args)
    if module ~= BUILD_STATE_MODULE or command ~= BUILD_STATE_REQUEST then return end
    sendBuildState(player)
end

if Events.OnClientCommand then Events.OnClientCommand.Add(onClientCommand) end

print("[TVMPerformance][server] Loaded v" .. Version.BUILD_VERSION .. " TVM visual traffic guard.")
