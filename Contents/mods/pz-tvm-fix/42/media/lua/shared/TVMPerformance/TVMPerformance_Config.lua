-- Runtime-only configuration for the TVM visual polling guard.
TVMPerformance = TVMPerformance or {}

local M = TVMPerformance

local function integerOption(name, fallback, minimum, maximum)
    local vars = SandboxVars and SandboxVars.TVMPerformance or nil
    local value = math.floor(tonumber(vars and vars[name]) or fallback)
    if value < minimum then return minimum end
    if value > maximum then return maximum end
    return value
end

function M.visualSliceIntervalMs()
    return integerOption("VisualSliceIntervalSeconds", 15, 3, 300) * 1000
end

function M.visualMovementThresholdTiles()
    return integerOption("VisualMovementThresholdTiles", 8, 1, 60)
end

function M.visualSnapshotIntervalMs()
    return integerOption("VisualSnapshotIntervalSeconds", 10, 1, 300) * 1000
end
