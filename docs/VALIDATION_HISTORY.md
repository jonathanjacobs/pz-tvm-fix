# Validation history

Status: **Beta; addon-removal test pending for 1.0**

## 2026-09-28 — beta decision

- Evidence: the 2026-08-30 diagnostic smoke test, the 42.21.0 checkpoint below, a same-day client DebugLog on Project Zomboid `42.20.4` (`b0bbce05d5`) that loads `pz-tvm-fix` with no `TVMPerformance` error, and the operator report of live dedicated-server use since Workshop publication on 2026-08-30 with no addon-related issue.
- Decision: leave alpha and label the package v0.2.0-beta. Public claims describe automatic-polling suppression, not measured bandwidth reduction. The copied-save addon-removal test is the remaining 1.0 gate.

## 2026-09-28 — Project Zomboid 42.21.0 compatibility checkpoint

- Package: published revision `27e277c` (v0.1.0-dev), unchanged. The installed Workshop copy matches the repository package apart from line endings.
- Versions: Project Zomboid `42.21.0` revision `4a0e9546ec` on the dedicated server and client; TVM Workshop content dated 2026-08-12, unchanged since the 2026-08-30 smoke test.
- Topology: dedicated multiplayer server and one client in normal play with default settings (traffic control and event-driven mode enabled, diagnostics disabled).
- Observed: five client DebugLogs from 2026-09-28 report `42.21.0 4a0e9546ec`, load `pz-tvm-fix` from Workshop item `3793134223`, and contain no stack trace or Lua error referencing `TVMPerformance`. The operator reports that the server and client ran normally with the addon enabled.
- Not captured: with diagnostics disabled the addon prints no `[TVMPerformance]` lines, so hook-installation and suppression counters were not logged in this window. `[TVMFix]` lines in the same logs belong to the separate TraderVendingMachinesFix mod.
- Evidence: operator-supplied client DebugLogs and operator report; not retained in this public repository.
- Decision: v0.1.0-dev is recorded as tested with Project Zomboid 42.21.0. Alpha limits are unchanged: no packet/byte reduction, broad compatibility, or addon-removal claim is established.

## 2026-08-30 — event-driven smoke test

- Package: `d70d78c`; exact Project Zomboid and TVM versions were not recorded.
- Topology: dedicated server and one administrative test client.
- Observed: five client intervals suppressed 298 automatic registry requests and 25 visual snapshots, with zero forwarded. The server installed both hooks, recorded zero visual requests at its guard, and recorded 11 `revision_change` marker-refresh attempts.
- Evidence: operator-supplied server and client console archives; not retained in this public repository.
- Decision: continue controlled multiplayer testing. No packet/byte reduction, broad compatibility, or addon-removal claim is established.
