# Design

Status: **Beta traffic-control implementation; live-use and bounded runtime evidence collected**

Do not update for: task status or milestones ([`ROADMAP.md`](ROADMAP.md)), test results ([`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md)), or experiment narratives ([`spikes/`](spikes/)).

This document has two parts with different authority. **Requirements** state what the mod must do, as players and server operators see it. **Architecture** describes how the current implementation does it. Keep them separate: an implementation detail is not a requirement until it is written into the requirements section, and a requirement does not change because the code happens to behave differently.

## Requirements

### Project identity

- Mod name: `TVM Network Tuner`
- Mod ID: `pz-tvm-fix`
- Target Build: Project Zomboid Build 42
- Primary supported mode: dedicated multiplayer
- Dependency: Trader Vending Machines [42] (TVM), mod ID `TraderVendingMachines`, Workshop ID `3699451356`; the tested release is recorded in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md)

### Scope

- In scope: an independent, optional addon that reduces TVM automatic visual-runtime traffic and adds no new durable save dependency.
- Explicitly out of scope: redistributing or modifying TVM; repairing existing TVM saves; claiming that TVM itself is removable.

### Behavior

- `R1` — The addon affects only TVM requests tagged as automatic visual-runtime work. Public UI, purchases, owner actions, placement, and TVM persistence remain outside the guard.
- `R2` — Shared state remains server-authoritative. In event mode, the server rejects automatic visual registry and snapshot requests from clients that lack or bypass the client guard.
- `R3` — A successful TVM state revision or detected direct container change may refresh TVM's existing deduplicated map-marker path. A rejected purchase must not trigger the addon refresh.
- `R4` — Traffic control defaults on; diagnostics default off. Operators can switch to pass-through mode and enable aggregate, rate-limited diagnostics through sandbox settings.
- `R5` — The addon must add no persistent telemetry or required world/player-save state, and must fail safely if its TVM integration surface is absent or incompatible.
- `R6` — Performance, compatibility, and addon-removal claims require the evidence listed in [`TESTING.md`](TESTING.md).

### Compatibility contracts

Some names outlive the code that defines them, because something outside the current build stores or calls them. Changing one breaks existing worlds, server settings, or other mods even when the new code is correct. List each one here as it is introduced, so a later change can be checked against the list.

| Kind | What depends on it |
| --- | --- |
| Mod ID | Server `Mods=` lines, saved worlds' mod lists, and other mods that declare it in `require=`. A changed ID is a different mod |
| Sandbox option names | Server settings files and saved worlds store values by name; a renamed option loses the value that was set |
| Sandbox option defaults | New worlds, and any setup that never set the option, get the new behavior without being told |
| ModData keys and saved-data layout | Data already saved in worlds and player files; a renamed key orphans it |
| Client/server command module and command names | A client and server on different mod versions during an update, and any other mod that sends or listens for them |
| Item, recipe, and other script full types (`Module.Name`) | Items already in saved inventories and containers, and other mods' recipes and distributions |
| Lua module paths other mods `require` | Add-ons and compatibility patches built on this mod |

| Kind | Name | Defined in | Since version |
| --- | --- | --- | --- |
| Mod ID | `pz-tvm-fix` | `Contents/mods/pz-tvm-fix/mod.info`, `42/mod.info` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.TrafficControlEnabled` (boolean, default `true`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.EventDrivenVisualSync` (boolean, default `true`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.DiagnosticsEnabled` (boolean, default `false`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.DiagnosticsIntervalSeconds` (integer 15–300, default `60`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.VisualSliceIntervalSeconds` (integer 3–300, default `15`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.VisualMovementThresholdTiles` (integer 1–60, default `8`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| Sandbox option | `TVMPerformance.VisualSnapshotIntervalSeconds` (integer 1–300, default `10`) | `42/media/sandbox-options.txt` | 0.1.0-dev |
| ModData keys | None. The addon owns no persistent state (`R5`) | — | — |
| Client/server commands | Module `TVMPerformance`: client-to-server `RequestBuildState` (no args) and server-to-client `BuildState` (`{ protocolVersion = 1, buildVersion }`), the version handshake. The addon otherwise wraps TVM's existing handlers | `42/media/lua/server/TVMPerformance/TVMPerformance_Server.lua`, `client/TVMPerformance/TVMPerformance_Client.lua` | 0.3.0-beta |
| Script full types | None | — | — |
| Lua modules | None offered to other mods. The global table `TVMPerformance` and the module paths `TVMPerformance/TVMPerformance_Config` and `TVMPerformance/TVMPerformance_Version` are internal, not a supported interface | `42/media/lua/shared/TVMPerformance/` | — |

A change to a listed name follows the rules in `AGENTS.md`: only on explicit request, with an `Upgrading` note in [`../CHANGELOG.md`](../CHANGELOG.md) and a version number chosen as [`RELEASING.md`](RELEASING.md#choosing-the-version-number) describes. Mark a retired name `retired in x.y.z` instead of deleting its row, so the history of what saves may still contain stays visible.

## Architecture

Cover module responsibilities, Lua client/server/shared boundaries, persistence, networking, configuration, and diagnostics once a design exists. Record a decision with realistic alternatives as an ADR under [`adr/`](adr/).

### Runtime layout

```text
Contents/mods/pz-tvm-fix/
  mod.info
  common/
    media/lua/shared/Translate/EN/Sandbox_EN.txt
  42/
    mod.info
    media/
      lua/
        client/TVMPerformance/TVMPerformance_Client.lua
        server/TVMPerformance/TVMPerformance_Server.lua
        shared/TVMPerformance/TVMPerformance_Config.lua
        shared/TVMPerformance/TVMPerformance_Version.lua
      sandbox-options.txt
```

Build 42 expects both a `common/` folder and a build-specific `42/` folder beside the root `mod.info`. This mod keeps its sandbox translations under `common/`.

The template's recommended `mod.info` carries the same `id=`, `name=`, `description=`, `author=`, `category=`, `modversion=`, and `versionMin=` values in both files, and the build-specific `42/mod.info` also references `poster=` and `icon=` artwork. This mod's two `mod.info` files are identical and carry `name=`, `id=`, `description=`, `author=`, `category=features`, `require=TraderVendingMachines`, `versionMin=42.20.4`, and `modversion=`; `poster=` and `icon=` are not yet present (see [`ROADMAP.md`](ROADMAP.md)). `category=` only sets the in-game Mod Manager filter, and only `map`, `vehicle`, `features`, and `modpack` are known to create one; Steam Workshop tags are set separately in `workshop.txt`. Use `modversion=` for the mod's release version (not `version=`), and set `versionMin=` to the oldest Project Zomboid build the mod has actually been tested on. Keep `modversion=` equal to [`../VERSION`](../VERSION); the package validator checks this.

There is one authoritative runtime tree. Do not create a second root-level `42/`, `common/`, `media/`, or `mod.info` copy.

### Build stamp and version handshake

Recommended from the first multiplayer build. Mixed-version installs — a stale local copy beside the Workshop copy, a client that has not downloaded the update, or a server that has not restarted — are a common cause of confusing test results, and they are invisible unless the mod reports which build is running.

- Define the build version once, in a shared module (for example `42/media/lua/shared/<ModName>/Version.lua` returning `{ BUILD_VERSION = "x.y.z" }`), and `require` it wherever the version is needed. Keep it equal to [`../VERSION`](../VERSION); [`../tools/validate-package.sh`](../tools/validate-package.sh) rejects any `BUILD_VERSION = "..."`, `buildVersion = "..."`, or `Loaded vX.Y.Z` literal in runtime Lua that disagrees.
- **Server:** log the build and the effective configuration once at startup, for example `[<ModName>] CONFIG | build=x.y.z | <key settings>`.
- **Server to client:** include `buildVersion` in the first state message each client receives.
- **Client:** log `[<ModName>] SERVER_BUILD | x.y.z` once on receipt, and log `BUILD_MISMATCH | client=… | server=…` once if it differs from the client's own build.

With this in place, confirming that everyone runs the same package is a log search rather than a guess, and it is the first step in [`TESTING.md`](TESTING.md#before-testing) and in post-release verification.

Current state in this mod (since 0.3.0-beta; the version module, log lines, and `protocolVersion`/`buildVersion` message fields match Enshrouded Sleep): the version is defined once, in `42/media/lua/shared/TVMPerformance/TVMPerformance_Version.lua`, which returns `{ BUILD_VERSION = "…" }`, and the client and server files require it. Each logs a `Loaded v…` banner when it loads. The server logs `[TVMPerformance][server] CONFIG | build=… | mode=… | …` once at `OnServerStarted`. The addon has no state messages of its own to carry `buildVersion`, so the handshake runs once per login instead: at `OnGameStart` the client sends `RequestBuildState`, and the server replies to that player only with `BuildState` (`protocolVersion = 1`, `buildVersion`). Nothing repeats and neither side polls. The client logs `[TVMPerformance][client] SERVER_BUILD | …` when the server's build is first seen or changes, and `ERROR | BUILD_MISMATCH | client=… | server=…` once when it differs. A server on a build older than 0.3.0-beta ignores the request, so a newer client joined to it logs no `SERVER_BUILD` line at all; a client older than 0.3.0-beta never asks, so the server logs nothing about it either.

### Components

The shared configuration reads sandbox settings at request time. The client guard intercepts only TVM calls marked `source = "visuals_runtime"`: registry slices, visual snapshot batches, and visual fallback snapshots. Event mode blocks them; throttled mode remains an operator fallback. Public UI traffic is not wrapped.

The server applies the same policy to TVM visual handlers, protecting against unmodified or misconfigured clients. If TVM's server tables are not ready when the addon loads, installation retries once per second for up to five minutes and stops immediately after both hooks attach. It wraps TVM's `bumpRevision` to request a deduplicated map-marker refresh after completed TVM mutations, and wraps `syncAllMachinesFromWorld()` as a fallback for detected direct container changes. It owns no durable state.

Server hook startup emits one low-volume status sequence even when diagnostics are disabled, and both sides log the build stamp described above. The one `RequestBuildState`/`BuildState` exchange per login is the only network traffic the addon originates. Diagnostics are otherwise opt-in and log-only: interval aggregates for visual requests plus rate-limited marker-refresh attempts. They count guard decisions and refresh attempts, not packet bytes. See [`TESTING.md`](TESTING.md) for measurement requirements and [`spikes/SPIKE-001-tvm-source-architecture-audit.md`](spikes/SPIKE-001-tvm-source-architecture-audit.md) for the source boundary.
