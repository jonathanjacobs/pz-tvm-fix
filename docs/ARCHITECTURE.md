# Architecture

Status: **Alpha implementation; bounded runtime evidence collected**

## Runtime layout

```text
Contents/mods/pz-tvm-fix/
  42/media/lua/client/TVMPerformance/TVMPerformance_Client.lua
  42/media/lua/server/TVMPerformance/TVMPerformance_Server.lua
  42/media/lua/shared/TVMPerformance/TVMPerformance_Config.lua
```

## Design

The shared configuration reads sandbox settings at request time. The client guard intercepts only TVM calls marked `source = "visuals_runtime"`: registry slices, visual snapshot batches, and visual fallback snapshots. Event mode blocks them; throttled mode remains an operator fallback. Public UI traffic is not wrapped.

The server applies the same policy to TVM visual handlers, protecting against unmodified or misconfigured clients. It wraps TVM's `bumpRevision` to request a deduplicated map-marker refresh after completed TVM mutations, and wraps `syncAllMachinesFromWorld()` as a fallback for detected direct container changes. It owns no durable state.

Diagnostics are opt-in and log-only: interval aggregates for visual requests plus an install line and rate-limited marker-refresh attempts. They count guard decisions and refresh attempts, not packet bytes. See [`TESTING.md`](TESTING.md) for measurement requirements and [`spikes/SPIKE-001-tvm-source-architecture-audit.md`](spikes/SPIKE-001-tvm-source-architecture-audit.md) for the source boundary.
