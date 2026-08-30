-- Server-authoritative policy for TVM automatic visual synchronization.
require "TVMPerformance/TVMPerformance_Config"

if not isServer() then return end

local M = TVMPerformance
M.Server = M.Server or {}

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
    if installed and M.diagnosticsEnabled() and not M.Server.installLogged then
        M.Server.installLogged = true
        print(string.format(
            "[TVMPerformance][server] installed mode=%s registry_hook=true command_hooks=true",
            M.visualSyncMode()
        ))
    end
    return installed
end

M.Server.install = install
install()
if Events.OnInitGlobalModData then Events.OnInitGlobalModData.Add(install) end
