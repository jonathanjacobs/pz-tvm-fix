# TVM Network Tuner

An **alpha** Project Zomboid Build 42 companion for Trader Vending Machines (TVM). It reduces TVM's automatic visual registry and snapshot polling without changing TVM gameplay or copying TVM content.

Status: **Alpha — controlled dedicated-server validation in progress**

Version: **v0.1.0-dev**

Mod ID: **`pz-tvm-fix`**

License: **Apache-2.0**

## What it does

- Blocks automatic TVM visual-runtime requests by default.
- Keeps the normal machine UI, purchases, owner actions, placement, and TVM persistence outside the guard.
- Refreshes TVM's existing deduplicated map-marker path after a successful TVM state revision or detected direct container change.
- Offers a server-controlled pass-through switch and low-volume diagnostics.

## Alpha boundary

Observed logs confirm request suppression and successful state-change hooks. They do **not** establish a measured byte reduction, broad live compatibility, or safe addon removal. Do not use this addon to remove TVM or repair existing TVM save data.

## Install and test

Install the same addon build with TVM on the dedicated server and each client, then restart the server and reconnect clients. Event-driven traffic control is enabled by default; diagnostics are disabled by default. See [`docs/DEPLOYMENT.md`](docs/DEPLOYMENT.md) for the alpha rollout/rollback procedure and [`docs/TESTING.md`](docs/TESTING.md) for the repeatable test matrix.

## Repository map

- `Contents/mods/pz-tvm-fix/` — deployable addon package.
- [`docs/DOCUMENTATION_OWNERSHIP.md`](docs/DOCUMENTATION_OWNERSHIP.md) — source-of-truth map.
- [`docs/`](docs/) — behavior, design, validation, deployment, and release controls.
- [`docs/spikes/`](docs/spikes/) — bounded source and engine investigations.

## License and rights

This is an unofficial, independent community addon. TVM, Project Zomboid, Steam, and their assets remain the property of their respective owners; this repository redistributes none of them.
