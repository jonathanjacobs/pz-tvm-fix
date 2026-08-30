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

`TVMPerformance_Client.lua` wraps only TVM client calls tagged `source = "visuals_runtime"`: registry slices, visual snapshot batches, and visual fallback snapshots. The default event-driven mode blocks those background calls. The fallback throttled mode permits the first request, then permits a refresh after the configured interval or after the player crosses the configured tile threshold. Public UI requests are not wrapped.

`TVMPerformance_Server.lua` enforces the selected policy for visual registry and snapshot handlers. In event-driven mode, it wraps TVM's world reconciliation result: detected inventory changes cause a call to TVM's existing deduplicated `pushMapMarkers` transport. Public purchases receive the same deduplicated marker-refresh attempt after their authoritative handler finishes. This protects the server from unmodified or misconfigured clients while preserving TVM's authority and protocol.

The sandbox options are `TVMPerformance.TrafficControlEnabled` (default true), `TVMPerformance.EventDrivenVisualSync` (default true), `TVMPerformance.DiagnosticsEnabled` (default false), `TVMPerformance.DiagnosticsIntervalSeconds` (default 60), `TVMPerformance.VisualSliceIntervalSeconds` (default 15), `TVMPerformance.VisualMovementThresholdTiles` (default 8), and `TVMPerformance.VisualSnapshotIntervalSeconds` (default 10). The guard reads these values at request time. The test evidence shows changes can take effect during a running session, but restart/reconnect remains the safe operating procedure until live propagation is formally validated.

When diagnostics are enabled, each side writes one aggregate line only after the configured interval and only when visual-runtime activity occurs. The client line counts automatic slice and snapshot calls forwarded or suppressed by its guard. The server line counts visual registry/snapshot calls passed, forwarded, blocked, or throttled plus event-marker refresh attempts. The server also writes an install-status line and an immediate, per-source marker-refresh-attempt line, limited to one per source per second, so a stock-change test can verify the event hook without waiting for an aggregate interval. These counters and lines describe requests or refresh attempts, not packet-byte measurements, and are stored only in ordinary logs.
