# Architecture

Status: **Initial traffic-control design — runtime validation pending.**

Audience: implementers and reviewers.
Use this when: choosing module boundaries, authority, persistence, or diagnostics.
Update this when: a design decision is supported by evidence.
Do not update for: temporary exploratory notes; use a spike instead.

## Constraints

- Treat TVM as an external runtime dependency; verify documented/public extension points before relying on them.
- Prefer event filtering, batching, caching, or observation only where behavior can be proven equivalent and server authority remains intact.
- Add no persistent state by default. Any exception needs an ADR plus removal and save/load evidence.
- Diagnostics must be opt-in or rate-limited and must not create high-volume network or log traffic.

## Source-audit observations

`SPIKE-001-tvm-source-architecture-audit.md` records the current TVM source findings. The leading candidates for traffic work are the client visual registry/snapshot hydration lane and the server-wide reconciliation triggered by container updates. These are hypotheses awaiting a controlled baseline, not performance claims.

## Initial traffic-control design

`TVMPerformance_Client.lua` wraps only TVM client calls tagged `source = "visuals_runtime"`: registry slices, visual snapshot batches, and visual fallback snapshots. It permits the first request, then permits a refresh after the configured interval or after the player crosses the configured tile threshold. Public UI requests are not wrapped.

`TVMPerformance_Server.lua` applies the equivalent gate to TVM's visual registry-slice handler. This protects the server from unmodified or misconfigured clients while preserving TVM's authoritative response construction.

The sandbox options are `TVMPerformance.TrafficControlEnabled` (default true), `TVMPerformance.DiagnosticsEnabled` (default false), `TVMPerformance.DiagnosticsIntervalSeconds` (default 60), `TVMPerformance.VisualSliceIntervalSeconds` (default 15), `TVMPerformance.VisualMovementThresholdTiles` (default 8), and `TVMPerformance.VisualSnapshotIntervalSeconds` (default 10). The guard reads these values at request time, but operators must restart the server and reconnect clients after changing sandbox configuration until live update behavior is verified.

When diagnostics are enabled, each side writes one aggregate line only after the configured interval and only when visual-runtime activity occurs. The client line counts automatic slice and snapshot calls forwarded or suppressed by its guard. The server line counts visual registry slices passed, forwarded, or throttled. These counters are request counts, not packet-byte measurements, and are stored only in ordinary logs.
