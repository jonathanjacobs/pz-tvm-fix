# Validation history

Status: **Beta; addon-removal test pending for 1.0**

Do not update for: planned tests ([`TESTING.md`](TESTING.md) or [`ROADMAP.md`](ROADMAP.md)), or correcting an earlier entry in place (add a new entry instead).

Record only tests that actually occurred, including observations from normal play.

This is an append-only ledger. If a later run overturns an earlier entry, add a new dated entry that says so — correcting or withdrawing the earlier finding — rather than editing history.

| Date | Version | Scope | Outcome | Evidence |
| --- | --- | --- | --- | --- |
| 2026-09-29 | 0.3.0-beta | Smoke test, build stamp and handshake | Smoke test `INCOMPLETE`; build-stamp handshake `FAIL`, client logged no `SERVER_BUILD` (fixed in 0.3.1-beta, not yet tested) | [entry](#2026-09-29--smoke-test-build-stamp-and-handshake) |
| 2026-09-28 | 0.2.0-beta | Beta decision | Left alpha; the copied-save addon-removal test remains the 1.0 gate | [entry](#2026-09-28--beta-decision) |
| 2026-09-28 | 0.1.0-dev | Project Zomboid 42.21.0 compatibility checkpoint | No `TVMPerformance` error in five client logs; hook and counter lines were not logged | [entry](#2026-09-28--project-zomboid-42210-compatibility-checkpoint) |
| 2026-08-30 | 0.1.0-dev (`d70d78c`) | Event-driven smoke test | Automatic requests suppressed with zero forwarded; both server hooks installed | [entry](#2026-08-30--event-driven-smoke-test) |

The three entries above were recorded before this repository adopted pz-mod-template. They are kept as written and do not use the results scale below.

The table is an index. When an entry needs more than a line, add a dated section below it in this shape:

```markdown
## <YYYY-MM-DD> — <what was tested>

Build `<x.y.z>` on Project Zomboid `<version>` `<revision>`; <topology: single-player, hosted, or dedicated, and player count, described by kind>. Logs reviewed: <which, from what window>.

- <what was observed, with the relevant log values>
- <…>

Result: <one result per check in TESTING.md, for example "smoke test PASS; core behavior INCOMPLETE">.

Not covered: <what did not happen during the window or was not reviewed, so no one later reads this entry as proving it>.
```

## Results

Give each check one of these results, in the index table and in the entry:

| Result | Meaning |
| --- | --- |
| `PASS` | Everything the check covers was observed and behaved as expected |
| `PASS with conditions` | It behaved as expected only within stated limits, such as one topology or with an option off; the entry says which |
| `FAIL` | Something the check covers behaved wrongly; link the issue |
| `INCOMPLETE` | The check started but not everything it covers was observed, for example because the session ended early or the situation never came up |
| `NOT RUN` | The check was part of this session's plan but was not performed |

Only `PASS` and `PASS with conditions` count as evidence for the [release checklist](RELEASING.md#release-checklist). `INCOMPLETE` and `NOT RUN` are recorded so a gap stays visible; they are not partial passes.

Entries are public. Describe servers by kind ("a rented dedicated server"), and replace IP addresses, Steam IDs, and other players' names in quoted log values with placeholders; see [`PRIVATE_DATA.md`](PRIVATE_DATA.md).

For a Project Zomboid update, this entry is the compatibility checkpoint: record it before changing any "tested with" claim or `versionMin=`.

## 2026-09-29 — smoke test, build stamp and handshake

Build `0.3.0-beta` from the Workshop item (the server and the client both loaded it from Workshop content `3793134223`) on Project Zomboid `42.21.0` `4a0e9546ec`; a rented dedicated server with one player joining from a Windows client for about 70 seconds. Logs reviewed: the server console and DebugLog from startup through the session, and the client `console.txt`, DebugLog, and connections log for the same window.

- Same build: both sides loaded `pz-tvm-fix` `0.3.0-beta` from the Workshop copy; no local copy was loaded.
- Server: `[TVMPerformance][server] installed mode=event registry_hook=true command_hooks=true`, then `Loaded v0.3.0-beta TVM visual traffic guard.`, then once at startup `CONFIG | build=0.3.0-beta | mode=event | diagnostics=false | diagnostics_interval_s=60 | slice_interval_s=15 | movement_tiles=8 | snapshot_interval_s=10`. No `unavailable` line.
- Client: `[TVMPerformance][client] Loaded v0.3.0-beta TVM visual request guard.`, and no other `[TVMPerformance]` line. No `SERVER_BUILD` and no `BUILD_MISMATCH`.
- Cause of the missing `SERVER_BUILD`: the client sends `RequestBuildState` at `OnGameStart`, which in this log fires when `GameLoadingState` exits, before `Waiting for player-connect response from server` and `ReceivePlayerConnect`. The server logged no reply and no error, so the request most likely arrived before the server had registered the player and was dropped. Enshrouded Sleep's server-initiated state messages, in the same client log, arrived right after `ReceivePlayerConnect`.
- No Lua error from this addon on either side. The `mod "pz-tvm-fix" overrides icon.png` line and four `NoSuchFileException` lines for `AnimSets` and `actiongroups` under the mod folders also appear for dozens of other mods and are engine output, not addon errors.

Result: smoke test `INCOMPLETE` (steps 1, 2, and 4 passed: no addon Lua error, hooks installed, and with diagnostics off the only `[TVMPerformance]` lines were the expected ones; step 3 failed on the client's missing `SERVER_BUILD`); build-stamp handshake `FAIL`, fixed in 0.3.1-beta by having the server send `BuildState` once each player connects (see the 0.3.1-beta entry in [`../CHANGELOG.md`](../CHANGELOG.md)).

Not covered: the 0.3.1-beta fix; how the poster and icon look in the Mod Manager (not visible in logs); a `BUILD_MISMATCH` case; more than one player; reconnects.

## 2026-09-28 — beta decision

- Evidence: the 2026-08-30 diagnostic smoke test, the 42.21.0 checkpoint below, a same-day client DebugLog on Project Zomboid `42.20.4` (`b0bbce05d5`) that loads `pz-tvm-fix` with no `TVMPerformance` error, and the operator report of live dedicated-server use since Workshop publication on 2026-08-30 with no addon-related issue.
- Decision: leave alpha and label the package v0.2.0-beta. Public claims describe automatic-polling suppression, not measured bandwidth reduction. The copied-save addon-removal test is the remaining 1.0 gate.

## 2026-09-28 — Project Zomboid 42.21.0 compatibility checkpoint

- Package: published revision `27e277c` (v0.1.0-dev), unchanged. The installed Workshop copy matches the repository package apart from line endings.
- Versions: Project Zomboid `42.21.0` revision `4a0e9546ec` on the dedicated server and client; TVM Workshop release dated 2026-04-20 (corrected 2026-09-28 from an earlier 2026-08-12 entry), unchanged since the 2026-08-30 smoke test.
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
