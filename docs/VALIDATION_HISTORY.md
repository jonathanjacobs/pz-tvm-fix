# Validation history

Status: **Alpha smoke evidence recorded; performance and removal qualification pending**

## 2026-08-30 — event-driven smoke test

- Package: `d70d78c`; exact Project Zomboid and TVM versions were not recorded.
- Topology: dedicated server and one administrative test client.
- Observed: five client intervals suppressed 298 automatic registry requests and 25 visual snapshots, with zero forwarded. The server installed both hooks, recorded zero visual requests at its guard, and recorded 11 `revision_change` marker-refresh attempts.
- Evidence: operator-supplied server and client console archives; not retained in this public repository.
- Decision: continue controlled multiplayer testing. No packet/byte reduction, broad compatibility, or addon-removal claim is established.
