# Changelog

Human-readable history of notable changes between releases. Git remains authoritative for exact diffs.

This file records **what changed between releases**. Test evidence belongs in [`docs/VALIDATION_HISTORY.md`](docs/VALIDATION_HISTORY.md) and [`docs/spikes/`](docs/spikes/); current and future work belongs in [`docs/ROADMAP.md`](docs/ROADMAP.md); durable design rationale belongs in [`docs/adr/`](docs/adr/). Cross-reference GitHub issues by number where one exists.

Format: newest release first, each as `## [x.y.z] - YYYY-MM-DD` with `Added`, `Changed`, `Fixed`, `Removed`, and `Documentation` subsections as needed. When server operators or players must do something after updating, such as re-enter a renamed sandbox option, add an `Upgrading` subsection that says what; [`docs/RELEASING.md`](docs/RELEASING.md#choosing-the-version-number) says how that affects the version number. Collect unreleased work under `## [Unreleased]` and rename it when the release is cut.

## [Unreleased]

Planned as 0.3.1-beta; `VERSION` and both `mod.info` files already carry it.

### Fixed

- The client never logged `SERVER_BUILD`. A 0.3.0-beta client sent `RequestBuildState` at `OnGameStart`, which fires before the server has registered the player, so the request got no reply (2026-09-29 smoke test). The server now sends `BuildState` once to each player a few seconds after they connect, found by a local check of its online-player list; clients no longer send `RequestBuildState`, and the server still answers it for 0.3.0-beta clients.

### Upgrading

- Update the server and clients together as usual. The fix is on the server side: a 0.3.0-beta client already handles `BuildState`, so on a 0.3.1-beta server it logs `SERVER_BUILD | 0.3.1-beta` and, correctly, `BUILD_MISMATCH` until it updates. A 0.3.1-beta client joined to a 0.3.0-beta server logs no `SERVER_BUILD` line.

## [0.3.0-beta] - 2026-09-29

0.2.0-beta was never uploaded to the Workshop; this release includes its changes.

### Added

- Build stamp and version handshake. `TVMPerformance_Version.lua` defines the build once; the server logs a `Loaded v` banner and a `CONFIG | build=` line with the effective settings, and the client logs a `Loaded v` banner. When a player's game starts, the client sends one `RequestBuildState`, the server replies to that player with `BuildState`, and the client logs `SERVER_BUILD` and, if the builds differ, `BUILD_MISMATCH`. This is the addon's first client/server command pair, hence the minor version bump.
- Mod Manager artwork: `42/mod.info` now references `poster.png` (the 256×256 Workshop preview art) and `icon.png` (the same art scaled to 32×32).

### Changed

- Restructured the repository to [pz-mod-template](https://github.com/jonathanjacobs/pz-mod-template) v0.9.0. The mod package under `Contents/mods/pz-tvm-fix/` is unchanged. Documentation moved into the template's documents: requirements and architecture into `docs/DESIGN.md`; the release checklist, Workshop notes, and deployment steps into `docs/RELEASING.md`; asset and third-party notes into `CREDITS.md`; compliance notes into `docs/PZ_MODDING_POLICY.md`.
- Added the template's automated checks (package validator, Lua syntax, and private details), which run on GitHub and before each commit.
- `workshop.txt` stores the Workshop ID as `id=` instead of `workshopid=`, with the same value.
- `.gitignore` anchors root-level runtime folders, so server Lua is never ignored.
- Landed in this repository as a single change on the `adopt-pz-mod-template` branch; the package tree ID is unchanged (`261c7c3d4fb2f3a4c450c4935cf31bd6a3f410c7`).
- Raised `versionMin` in both `mod.info` files from `42.13` to `42.20.4`, the oldest Project Zomboid build the addon has been tested on.
- `tools/validate-package.sh` accepts a SemVer pre-release suffix such as `0.2.0-beta`, so the Validate Package check no longer fails on this beta. The version-drift checks now compare the full version, suffix included; before, a README label such as `**v0.2.0-beta**` was not checked at all.
- Added `author=` and `category=features` to both `mod.info` files. They feed the in-game Mod Manager's author line and category filter; the addon's runtime behavior is unchanged.

### Upgrading

- Servers and players need Project Zomboid 42.20.4 or later to load this version of the addon.
- Nothing else to do. The handshake only logs; it never refuses a client or server on a different build. A 0.3.0-beta client joined to an older server logs no `SERVER_BUILD` line, which shows that the server still needs the update.

## [0.2.0-beta] - 2026-09-28

- Moved from alpha to beta after live dedicated-server use since 2026-08-30 without an addon-related issue. No runtime change; the package differs from v0.1.0-dev only in `modversion`.
- Recorded a Project Zomboid 42.21.0 (`4a0e9546ec`) compatibility checkpoint with the TVM Workshop release dated 2026-04-20.
- Restated the public claim as automatic-polling suppression rather than measured bandwidth reduction, dropped the `WIP` Workshop tag, and split the release checklist into beta and 1.0 gates. The copied-save addon-removal test remains the 1.0 gate.

## [0.1.0-dev] - 2026-08-30

- Initialized the independent Build 42 TVM traffic-control addon.
- Added client and server guards for automatic visual registry and snapshot polling, with event-driven map-marker refreshes after successful TVM state changes.
- Added bounded late-start retries and explicit server-hook status logging when TVM initializes after the addon.
- Added sandbox controls and opt-in, low-volume diagnostics for controlled comparison.
- Added alpha Workshop staging assets and concise publication metadata.
- Recorded Workshop ID `3793134223` and removed duplicate identifiers from the Steam BBCode description.
- Consolidated repository documentation around the template’s canonical ownership model.

Runtime status: dedicated-server smoke evidence exists; measured byte reduction, broad compatibility, and addon-removal safety remain unverified.
