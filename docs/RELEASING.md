# Releasing

Status: **Beta item published**

Do not update for: player-facing installation or configuration ([`../README.md`](../README.md)), Workshop description text ([`workshop-description.bbcode`](workshop-description.bbcode)), or test results ([`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md)).

This document owns how a version gets from the repository to players: the release checklist, Steam Workshop publication, post-release checks, and rollback. Player-facing installation and configuration live in [`../README.md`](../README.md); public Workshop text is canonical in [`workshop-description.bbcode`](workshop-description.bbcode). If the mod is not published on the Workshop, delete the Workshop sections along with `workshop.txt` and `workshop-description.bbcode`.

Project Zomboid Mod ID: `pz-tvm-fix`  
Permanent Steam Workshop ID: `3793134223`

## Current Workshop item

- Title: `Trader Vending Machines - Network Tuner`. The title follows TVM's naming so the addon is found next to it.
- Tags: Build 42, Multiplayer, QoL. The `WIP` tag was dropped when the addon left alpha.
- Required item: Trader Vending Machines [42], Workshop ID `3699451356`, mod ID `TraderVendingMachines`. TVM publishes no version number; record its Workshop update date as its version.
- Published revision: v0.3.0-beta, uploaded 2026-09-29. The exact commit was not recorded; the Workshop copy includes the poster and icon, so it was built from `eeea107` or later. v0.2.0-beta was never uploaded; the previous upload was `27e277c` (v0.1.0-dev) on 2026-08-30. The next upload is v0.3.1-beta, which fixes the client never logging `SERVER_BUILD` (see [`../CHANGELOG.md`](../CHANGELOG.md)).

## Release gates

Each applicable item needs evidence before the addon is labeled at that stage.

### Beta gate

- [x] `VERSION`, `CHANGELOG.md`, both `mod.info` files, and Workshop metadata agree. (0.3.1-beta.)
- [x] Exact TVM and Project Zomboid compatibility versions are recorded. (Project Zomboid 42.21.0, TVM Workshop release dated 2026-04-20.)
- [x] Diagnostic evidence shows automatic visual requests suppressed and state-change hooks installed. (2026-08-30 smoke test.)
- [x] Live dedicated-server use on the current Project Zomboid build without an addon-related error. (Live use since 2026-08-30; 42.21.0 checkpoint 2026-09-28.)
- [x] Public claims match [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md); no measured bandwidth reduction or removal safety is claimed.
- [x] Package contains no logs, saves, credentials, private configuration, source-control metadata, decompiled source, or extracted assets.
- [x] Third-party rights, attribution, Project Zomboid policy, Workshop metadata, backup, and rollback instructions are current. (Policy reviewed 2026-09-28; see [`PZ_MODDING_POLICY.md`](PZ_MODDING_POLICY.md).)

### 1.0 gate

- [ ] Copied-save addon-removal test from [`TESTING.md`](TESTING.md) passes and is recorded.
- [ ] Public claims and Workshop description drop the beta removal caveat only after that record exists.

Measured packet/byte comparison is optional investigation, not a release gate; public claims describe request suppression, not bandwidth.

## Release checklist

Tick an item only where recorded evidence supports it; evidence lives in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md). Require what protects players' saves and the mod's core behavior, and watch the rest during normal play.

- [ ] `VERSION`, `CHANGELOG.md`, both `mod.info` files, the README, the Workshop text, and runtime build stamps agree — `bash tools/validate-package.sh` passes.
- [ ] The Validate Package (package and Lua syntax) and Sensitive Content CI workflows pass on the release commit.
- [ ] The smoke test and core behavior test in [`TESTING.md`](TESTING.md) passed on this build (normal-session logs count) and are recorded in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md).
- [ ] Multiplayer authority and save/load behavior were tested wherever the public text claims them.
- [ ] No known high-severity save, world, player, client, or server defect is being shipped silently.
- [ ] Public claims (status, compatibility, "tested with", configuration) match the recorded evidence.
- [ ] Every distributed asset and any third-party material is recorded in [`../CREDITS.md`](../CREDITS.md), `NOTICE` still carries the pz-mod-template block, and the [modding-policy checks](PZ_MODDING_POLICY.md#release-checks) are done.
- [ ] Every change to a [compatibility contract](DESIGN.md#compatibility-contracts) since the last release is in that list and in an `Upgrading` subsection of `CHANGELOG.md` that says what server operators and players must do, and the version number follows the rule below.
- [ ] Rollback below is still accurate for this release.

A **stable** release (`1.0.0` or later) additionally needs server and client logs from normal play showing the core behavior with no recurring error from this mod.

## Choosing the version number

Choose the increment by what an update does to people already running the mod:

| Increment | When | Effect on existing worlds and servers |
| --- | --- | --- |
| Major (`X.0.0`) | A [compatibility contract](DESIGN.md#compatibility-contracts) is renamed, removed, or changes meaning or default, or players or server operators must act | Something breaks or changes unless they follow the `Upgrading` note |
| Minor (`x.Y.0`) | New features, sandbox options, or other contracts, with existing behavior and defaults unchanged | Existing worlds and settings keep working as before |
| Patch (`x.y.Z`) | Fixes that change no contract | Existing worlds and settings keep working, now without the bug |

A pre-release may add a SemVer suffix to the number it leads up to, such as `0.2.0-beta` or `1.0.0-rc.1`; `tools/validate-package.sh` accepts it and requires the same suffix everywhere the version appears.

Below `1.0.0` the mod is still settling, and a minor release may carry a breaking change; its `Upgrading` note must still say so and what to do. Keep breaking changes rare either way: every one costs every server running the mod.

Watch these during normal play rather than staging tests for them, record anything notable in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md), and treat a real problem as a blocker for the next release: joins, disconnects, deaths, and respawns leaving stale state; optional presentation (notifications, UI) missing or noisy; CPU cost or log volume becoming a problem for the server.

## Publishing to Steam Workshop

1. Stop the test server cleanly, and back up the world, save, and configuration of any server you will update.
2. Prepare a clean authoring directory under `Zomboid/Workshop/<item-name>/` from the repository, for example `git archive HEAD | tar -x -C <authoring-dir>`. That exports only tracked files, which keeps `.git/`, logs, saves, credentials, and decompiled source out; tracked docs and tooling come along, which is harmless.
3. In Project Zomboid, use **Workshop → Create and Update Items** to update the existing item. Never create a new item for a routine update.
4. Write an accurate change note (BBCode works). If the uploader does not carry it over, add or edit it on the item's Steam **Change Notes** tab.
5. **Paste [`workshop-description.bbcode`](workshop-description.bbcode) into the item description again.** Every upload replaces the Steam description with the one-line `description=` summary from `workshop.txt`.
6. After the first upload only: commit the `id=` line the uploader wrote into `workshop.txt`, and record the Workshop ID above and in [`../AGENTS.md`](../AGENTS.md).

**Do not subscribe to the item on the machine that holds the authoring copy.** The subscribed and authoring copies share the Mod ID, and the game can load files from both, so older Lua or sandbox options may run alongside the new version. Verify from the dedicated server or from a client without the authoring copy.

## After publishing

1. The dedicated server downloads the update and logs the new `CONFIG | build=` line; a client reports the matching `SERVER_BUILD` with no `BUILD_MISMATCH` (see the build-stamp convention in [`DESIGN.md`](DESIGN.md#build-stamp-and-version-handshake)).2. Poster, icon, and preview show as intended.
3. The smoke test in [`TESTING.md`](TESTING.md) passes on the live server.
4. Keep the early server and client logs from the release in case a problem appears.

## Deploying to a server

The current compatibility checkpoint is recorded in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md).

### Preflight

- Record the exact TVM and Project Zomboid versions, then back up the server world, server configuration, and account database.
- Deploy one matching addon build to the server and every participating client. Use only one effective `pz-tvm-fix` copy per machine.
- For Workshop delivery, follow [Publishing to Steam Workshop](#publishing-to-steam-workshop).

### Rollout

1. Enable TVM and `pz-tvm-fix`, set the desired sandbox settings, then restart the server and reconnect clients.
2. Keep diagnostics enabled only for the focused evidence window.
3. Test UI opening, purchases, restocks, map state, reconnects, and traffic counters using [`TESTING.md`](TESTING.md).

## Rollback

- **Per feature:** set `TVMPerformance.TrafficControlEnabled=false`, restart the server, and reconnect clients. The addon then passes TVM's automatic visual requests through unchanged.
- **Whole mod:** do not remove the addon from a live world until the copied-save removal scenario in [`TESTING.md`](TESTING.md) has passed. The addon stores no saved state of its own (`R5` in [`DESIGN.md`](DESIGN.md#behavior)), but removal from an existing world has not been tested.

## Workshop reference

### Package layout

A clean repository root doubles as the Workshop item directory:

```text
<workshop-item>/
├── workshop.txt
├── docs/workshop-description.bbcode
├── preview.png
├── Contents/mods/<mod-id>/      (the only runtime tree; see DESIGN.md)
└── README.md, CHANGELOG.md, the rest of docs/, licensing files
```

### `workshop.txt`

- `id=` — absent until the first upload writes it; never change it afterward. [`../tools/validate-package.sh`](../tools/validate-package.sh) treats a numeric `id=` as the signal that the project is publishing, and from then on requires the artwork below and a placeholder-free Workshop description. Here `id=` is the Steam Workshop ID; in `mod.info`, `id=` is the Mod ID. This repository's `workshop.txt` used `workshopid=` until the adoption to pz-mod-template, when it was changed to `id=` with the same value.
- `title=` — the public item title.
- `description=` — the one-line summary that overwrites the Steam description on every upload.
- `tags=` — Workshop tags such as `Build 42` and `Multiplayer`.
- `visibility=` — `private` until the first public release, then `public`.

### Artwork

| File | Purpose | Checked by the validator |
| --- | --- | --- |
| `preview.png` (item root) | Workshop uploader preview | PNG, 256×256, at most 1000 KB |
| `Contents/mods/<mod-id>/42/poster.png` | In-game mod-manager poster (`poster=`) | PNG identity |
| `Contents/mods/<mod-id>/42/icon.png` | In-game mod-list icon (`icon=`) | PNG identity |

Record the provenance of every image in [`../CREDITS.md`](../CREDITS.md). Do not silently resize publication artwork as part of an unrelated code release.

### Workshop description

- Update [`workshop-description.bbcode`](workshop-description.bbcode) in Git when public behavior or status changes, then paste it into the item. Do not keep a second copy of the description anywhere else.
- Steam does not render `[center]` or `[br]`; they show as literal text. Use blank lines for spacing. The validator rejects both.
- Replace every bracketed `[PLACEHOLDER]` before the first publication.
- An optional support or donation section is allowed as long as donations unlock nothing (rule 6 in [`PZ_MODDING_POLICY.md`](PZ_MODDING_POLICY.md)). Host any button image externally and link it with `[url=...][img]...[/img][/url]`.
