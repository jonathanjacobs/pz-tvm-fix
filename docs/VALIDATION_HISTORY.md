# Validation history

Status: **Beta; addon-removal test pending for 1.0**

Do not update for: planned tests ([`TESTING.md`](TESTING.md) or [`ROADMAP.md`](ROADMAP.md)), or correcting an earlier entry in place (add a new entry instead).

Record only tests that actually occurred, including observations from normal play.

This is an append-only ledger. If a later run overturns an earlier entry, add a new dated entry that says so — correcting or withdrawing the earlier finding — rather than editing history.

| Date | Version | Scope | Outcome | Evidence |
| --- | --- | --- | --- | --- |
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
