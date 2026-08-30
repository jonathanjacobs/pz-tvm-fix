-- Limits only TVM's automatic visual-runtime requests; UI and gameplay calls pass through.
require "TVMPerformance/TVMPerformance_Config"

if isServer() then return end

local M = TVMPerformance
M.Client = M.Client or {}

local function nowMs()
    return getTimestampMs and getTimestampMs() or 0
end

local function isVisualRuntime(hints)
    return type(hints) == "table" and tostring(hints.source or "") == "visuals_runtime"
end

local function movedEnough(previous, x, y, z, threshold)
    if not previous then return true end
    if tonumber(previous.z) ~= tonumber(z) then return true end
    return math.max(math.abs((tonumber(previous.x) or 0) - x), math.abs((tonumber(previous.y) or 0) - y)) >= threshold
end

local function install()
    local client = TVM and TVM.Client or nil
    if type(client) ~= "table" then return false end
    if client.TVMPerformanceOriginalVisualSlice then return true end
    if type(client.requestVisualRegistrySlice) ~= "function"
        or type(client.requestSnapshotsBatch) ~= "function"
        or type(client.requestSnapshot) ~= "function" then
        return false
    end

    local originalSlice = client.requestVisualRegistrySlice
    local originalBatch = client.requestSnapshotsBatch
    local originalSnapshot = client.requestSnapshot
    local state = {
        lastSlice = nil,
        lastVisualSnapshotByMachine = {},
        diagnostics = {
            active = false,
            lastReport = 0,
            sliceForwarded = 0,
            sliceSuppressed = 0,
            snapshotsForwarded = 0,
            snapshotsSuppressed = 0,
        },
    }

    local function recordDiagnostic(name, amount, now)
        local diagnostics = state.diagnostics
        if not M.diagnosticsEnabled() then
            diagnostics.active = false
            return
        end
        if not diagnostics.active then
            diagnostics.active = true
            diagnostics.lastReport = now
            diagnostics.sliceForwarded = 0
            diagnostics.sliceSuppressed = 0
            diagnostics.snapshotsForwarded = 0
            diagnostics.snapshotsSuppressed = 0
        end
        diagnostics[name] = (diagnostics[name] or 0) + amount
        if (now - diagnostics.lastReport) < M.diagnosticsIntervalMs() then return end
        print(string.format(
            "[TVMPerformance][client] guard=%s registry forwarded=%d suppressed=%d snapshots forwarded=%d suppressed=%d",
            tostring(M.trafficControlEnabled()),
            diagnostics.sliceForwarded,
            diagnostics.sliceSuppressed,
            diagnostics.snapshotsForwarded,
            diagnostics.snapshotsSuppressed
        ))
        diagnostics.lastReport = now
        diagnostics.sliceForwarded = 0
        diagnostics.sliceSuppressed = 0
        diagnostics.snapshotsForwarded = 0
        diagnostics.snapshotsSuppressed = 0
    end

    client.requestVisualRegistrySlice = function(x, y, z, radius, maxRows, hints)
        if not isVisualRuntime(hints) then
            return originalSlice(x, y, z, radius, maxRows, hints)
        end
        local now = nowMs()
        if now <= 0 then return originalSlice(x, y, z, radius, maxRows, hints) end
        if not M.trafficControlEnabled() then
            recordDiagnostic("sliceForwarded", 1, now)
            return originalSlice(x, y, z, radius, maxRows, hints)
        end
        local px, py, pz = tonumber(x), tonumber(y), tonumber(z) or 0
        if not (px and py) then
            recordDiagnostic("sliceForwarded", 1, now)
            return originalSlice(x, y, z, radius, maxRows, hints)
        end
        local previous = state.lastSlice
        local due = not previous or (now - previous.ts) >= M.visualSliceIntervalMs()
        local moved = movedEnough(previous, px, py, pz, M.visualMovementThresholdTiles())
        if not due and not moved then
            recordDiagnostic("sliceSuppressed", 1, now)
            return false
        end
        local sent = originalSlice(x, y, z, radius, maxRows, hints)
        if sent == true then
            state.lastSlice = { ts = now, x = px, y = py, z = pz }
            recordDiagnostic("sliceForwarded", 1, now)
        end
        return sent
    end

    local function snapshotDue(machineId, now)
        local key = tostring(tonumber(machineId) or "")
        if key == "" then return false end
        local last = tonumber(state.lastVisualSnapshotByMachine[key]) or 0
        return last <= 0 or (now - last) >= M.visualSnapshotIntervalMs()
    end

    local function markSnapshot(machineId, now)
        state.lastVisualSnapshotByMachine[tostring(tonumber(machineId) or "")] = now
    end

    client.requestSnapshotsBatch = function(machineIds, hints)
        if not isVisualRuntime(hints) then return originalBatch(machineIds, hints) end
        local now = nowMs()
        if now <= 0 then return originalBatch(machineIds, hints) end
        if not M.trafficControlEnabled() then
            recordDiagnostic("snapshotsForwarded", #(machineIds or {}), now)
            return originalBatch(machineIds, hints)
        end
        local eligible = {}
        for i = 1, #(machineIds or {}) do
            local id = tonumber(machineIds[i]) or 0
            if id > 0 and snapshotDue(id, now) then eligible[#eligible + 1] = id end
        end
        recordDiagnostic("snapshotsSuppressed", #(machineIds or {}) - #eligible, now)
        if #eligible <= 0 then return false end
        local sent = originalBatch(eligible, hints)
        if sent == true then
            for i = 1, #eligible do markSnapshot(eligible[i], now) end
            recordDiagnostic("snapshotsForwarded", #eligible, now)
        end
        return sent
    end

    client.requestSnapshot = function(machineId, uiType, hints)
        if tostring(uiType or "") ~= "visuals" or not isVisualRuntime(hints) then
            return originalSnapshot(machineId, uiType, hints)
        end
        local now = nowMs()
        if not M.trafficControlEnabled() then
            if now > 0 then recordDiagnostic("snapshotsForwarded", 1, now) end
            return originalSnapshot(machineId, uiType, hints)
        end
        if now > 0 and not snapshotDue(machineId, now) then
            recordDiagnostic("snapshotsSuppressed", 1, now)
            return false
        end
        local sent = originalSnapshot(machineId, uiType, hints)
        if sent == true and now > 0 then
            markSnapshot(machineId, now)
            recordDiagnostic("snapshotsForwarded", 1, now)
        end
        return sent
    end

    client.TVMPerformanceOriginalVisualSlice = originalSlice
    client.TVMPerformanceOriginalVisualBatch = originalBatch
    client.TVMPerformanceOriginalVisualSnapshot = originalSnapshot
    return true
end

M.Client.install = install
install()
Events.OnGameStart.Add(install)
Events.OnCreatePlayer.Add(install)
