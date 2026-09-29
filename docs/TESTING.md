# Testing

Status: **Beta procedure; evidence is recorded separately**

Do not update for: a test that was run (record it in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md)), or a change in what the mod should do (change the requirements in [`DESIGN.md`](DESIGN.md#requirements) first).

This document owns repeatable test procedures, not historical results. Record real outcomes in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md); expected behavior lives in the requirements in [`DESIGN.md`](DESIGN.md#requirements); long experimental procedures belong in [`spikes/`](spikes/).

Keep this guide short and proportionate to a hobby mod. Logs from normal play count as evidence; stage a dedicated test only when normal play does not cover a change.

Record the exact Project Zomboid and TVM versions, addon revision, enabled mods, topology, route, machine count, player count, and capture method for every comparison. Keep logs and saves outside the repository; record outcomes in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md).

## Contents

- [Before testing](#before-testing)
- [Smoke test](#smoke-test)
- [Core behavior test](#core-behavior-test)
- [After a Project Zomboid update](#after-a-project-zomboid-update)
- [Chasing a problem](#chasing-a-problem)
- [Engine logging note](#engine-logging-note)
- [Local files and automation](#local-files-and-automation)

## Before testing

- Tests run on a remote dedicated server with one player joining. Deploying to it and collecting its logs are manual steps until test-cycle scripts are added (see [Local files and automation](#local-files-and-automation)).
- `bash tools/validate-package.sh` passes for the build under test, and so does `bash tools/check-lua-syntax.sh` (or the "Check Lua syntax" CI job, where no Lua 5.1 compiler is installed locally).
- Server and clients show the same Project Zomboid `version=` / `revision=` line and the same mod build (server `CONFIG | build=`, client `SERVER_BUILD`, and no `BUILD_MISMATCH`; see the build-stamp convention in [`DESIGN.md`](DESIGN.md#build-stamp-and-version-handshake)).
- This mod has no build stamp yet (see [`ROADMAP.md`](ROADMAP.md#gaps-from-adopting-pz-mod-template)), so the same-build check above cannot yet be read from its logs; until it can, the next point carries that check.
- Only one copy of the mod is installed on each machine. A local copy and a Workshop copy with the same Mod ID can load mixed Lua and sandbox-option versions, which makes every result untrustworthy.
- Note the active sandbox settings; expected results use the active settings, not the shipped defaults.

## Smoke test

Run after any change, new release, or Project Zomboid update.

1. The server starts and a client joins with no Lua errors from this mod on either side.
2. The server log shows exactly one `[TVMPerformance][server] installed … registry_hook=true command_hooks=true` line after startup, and no `unavailable` line. This line appears even with diagnostics off.
3. Disabled optional features stay quiet, and diagnostics produce no output while off.

## Core behavior test

Run when the core behavior may have changed. A normal session that exercises the behavior counts.

| Scenario | Setup and pass criterion |
| --- | --- |
| Baseline | Addon absent; capture five minutes of visual-request and packet/byte traffic on a fixed route. |
| Pass-through control | Addon installed with traffic control disabled; behavior and traffic match the baseline. |
| Event mode | Traffic control and diagnostics enabled after restart/reconnect; automatic visual calls are blocked and normal UI remains immediate. |
| Server hook startup | Restart the dedicated server with diagnostics enabled; an optional `waiting` line is followed by exactly one `installed` line, with both registry and command hooks reported as `true` and no `unavailable` line. |
| State changes | Invalid purchase logs no refresh; successful purchase and owner restock log `source=revision_change`; map state is current. |
| Mixed clients | A client without the addon cannot make the server forward automatic visual requests; normal TVM interaction works. |
| Save/removal | On a copied world only, reconnect with the addon, then remove only the addon and verify restart and client connection. |

Compare packet counts and bytes separately for visual slices, snapshots, snapshot pushes, map-marker pushes, and object-mod-data traffic. Diagnostic counters explain guard decisions; they are not bandwidth measurements.

## After a Project Zomboid update

1. Skim the patch notes and modding news for changes to the systems this mod touches.
2. Run the smoke test, and the core behavior test if a touched system changed.
3. Check the server log for anti-cheat warnings, kicks, or rejected packets around the mod's activity.
4. Record a compatibility checkpoint in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md). Update "tested with" claims in `README.md`, the Workshop description, and `versionMin=` only after it is recorded.

## Chasing a problem

1. Save the normal server and client logs around the event.
2. Turn on the mod's diagnostics, reproduce once, then turn them off again.
3. Collect the server console/DebugLog and the affected client's DebugLog. This mod's lines start with `[TVMPerformance][server]` or `[TVMPerformance][client]`; diagnostics are turned on with `TVMPerformance.DiagnosticsEnabled`. Lines starting with `[TVMFix]` belong to the separate TraderVendingMachinesFix mod, not this one.

Server logs record IP addresses, Steam IDs, and player names. Keep the raw logs in a local folder outside the repository (see [Local files and automation](#local-files-and-automation)), and quote only the lines that matter, with those values replaced, in validation history, spikes, or issues ([`PRIVATE_DATA.md`](PRIVATE_DATA.md)).

If an optional layer is the suspect, turn it off first using the rollback steps in [`RELEASING.md`](RELEASING.md#rollback).

## Engine logging note

Project Zomboid's client debug log is capped in place with no rotation (observed around 4.3MB on one machine): once a session's log volume crosses that line, the engine silently drops its own oldest lines rather than archiving them. A long or verbose diagnostic session can lose its early evidence this way. Keep per-event diagnostics off by default, and if a session needs verbose logging over a long run, snapshot the client log between test phases rather than relying on its final state.

## Local files and automation

Keep test logs, decompiled game source, and research material (saved wiki or Javadoc pages, other mods studied for ideas) in local folders outside the repository. Logs carry private details, and decompiled source and other mods may be studied but never redistributed ([`PZ_MODDING_POLICY.md`](PZ_MODDING_POLICY.md)). `.gitignore` still ignores `Logs/`, `decompiled/`, `research-source/`, and Java files, in case copies end up inside the repository anyway.

A coding agent cannot see those folders by default. In Claude Code, `/add-dir <path>` grants access for one session, and `permissions.additionalDirectories` in `.claude/settings.local.json` grants it every session on that computer without committing the path.

Once the same test cycle repeats, scripts for its non-gameplay steps save time. Put them in `tools/` and document them in [`../tools/README.md`](../tools/README.md). Useful ones:

- **Deploy:** mirror `Contents/mods/<mod-id>/` into the local Project Zomboid mods folder, and optionally to a remote test server. Do not clear the game's logs first: Project Zomboid archives each session's logs into a dated `logs_<date>` folder at startup, and clearing them destroys that archive.
- **Collect:** after a session, archive the client logs, and the remote server's logs if configured, into the local logs folder.
- **Snapshot:** copy the current client log into a timestamped folder mid-session without stopping anything, for the log cap described above.

For a remote test server, keep its connection details in an ignored `.env.server` file and commit a placeholder copy such as `server.env.example`:

```text
SFTP_HOST=
SFTP_PORT=
SFTP_USERNAME=
SFTP_PASSWORD=
SFTP_HOST_FINGERPRINT_SHA256=
REMOTE_MOD_PATH=
REMOTE_LOGS_PATH=
```

Have scripts skip the remote steps until the real file exists with real values. Verify the server's host key fingerprint once and record it in that file, since some SFTP clients refuse to connect without it. Scripts should print a label such as "remote test server" instead of the address or credentials, which are otherwise easy to paste into an issue or a chat. `tools/check-sensitive-content.sh` fails on a tracked `.env` file or a filled-in `*PASSWORD=` line; see [`PRIVATE_DATA.md`](PRIVATE_DATA.md).
