# TVM Network Tuner

A **beta** Project Zomboid Build 42 companion for Trader Vending Machines (TVM). It suppresses TVM's automatic visual registry and snapshot polling without changing TVM gameplay or copying TVM content.

Status: **Beta — in live dedicated-server use; addon-removal test pending for 1.0**

Version: **v0.3.0-beta**

Tested with: **Project Zomboid 42.21.0** (`4a0e9546ec`) and the TVM Workshop release dated 2026-04-20

Mod ID: **`pz-tvm-fix`**

Workshop ID: **`3793134223`**

License: **Apache-2.0**

## What it does

- Blocks automatic TVM visual-runtime requests by default.
- Keeps the normal machine UI, purchases, owner actions, placement, and TVM persistence outside the guard.
- Refreshes TVM's existing deduplicated map-marker path after a successful TVM state revision or detected direct container change.
- Offers a server-controlled pass-through switch and low-volume diagnostics.

## Beta boundary

The addon has run in live dedicated-server use since 2026-08-30 without an addon-related issue, and diagnostic logs confirm automatic request suppression and successful state-change hooks. Bandwidth savings have not been measured in bytes, and removing the addon from an existing world has not yet been tested; back up the world before changing its mod list. Do not use this addon to remove TVM or repair existing TVM save data.

## Install and test

Install the same addon build with TVM on the dedicated server and each client, then restart the server and reconnect clients. Event-driven traffic control is enabled by default; diagnostics are disabled by default. See [`docs/RELEASING.md`](docs/RELEASING.md#deploying-to-a-server) for the rollout and rollback procedure and [`docs/TESTING.md`](docs/TESTING.md) for the repeatable test matrix.

## Repository map

- `Contents/mods/pz-tvm-fix/` — deployable addon package.
- [`docs/DOCUMENTATION_OWNERSHIP.md`](docs/DOCUMENTATION_OWNERSHIP.md) — source-of-truth map.
- [`docs/`](docs/) — behavior, design, validation, deployment, and release controls.
- [`docs/spikes/`](docs/spikes/) — bounded source and engine investigations.

## License and rights

This is an unofficial, independent community addon. TVM, Project Zomboid, Steam, and their assets remain the property of their respective owners; this repository redistributes none of them.

Built with [pz-mod-template](https://github.com/jonathanjacobs/pz-mod-template).
