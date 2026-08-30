# TVM Network Tuner

An optional Project Zomboid Build 42 companion for Trader Vending Machines (TVM) that reduces automatic visual synchronization traffic.

Status: **Initial implementation — runtime validation pending.**
Version: **v0.1.0-dev**
Target: **TVM for Project Zomboid Build 42.13+**
License: **Apache-2.0**

## Goals

- Reduce unnecessary TVM visual registry and snapshot polling without changing TVM gameplay.
- Ensure this addon adds no permanent world-save dependency that prevents its own removal.
- Establish evidence before making compatibility, performance, migration, or uninstall-safety claims.

The addon does not yet claim a measured traffic reduction. It does not repair existing TVM persistence; that investigation remains separate.

## Install and tune

Enable `TraderVendingMachines` and `pz-tvm-fix` on the server and every client. The dependency declaration loads TVM first.

The server controls the following Sandbox options:

- Visual Registry Refresh Interval — default 15 seconds.
- Visual Refresh Movement Threshold — default 8 tiles.
- Visual Snapshot Refresh Interval — default 10 seconds.

The addon affects only TVM requests tagged as automatic visual-runtime work. Machine UI opens, purchases, owner actions, placement, and TVM persistence are not throttled. The server independently rejects over-frequent visual registry-slice requests.

## Repository map

- `Contents/mods/pz-tvm-fix/` — deployable addon package.
- `docs/REQUIREMENTS.md` — normative scope and behavior.
- `docs/ARCHITECTURE.md` — integration and persistence design.
- `docs/spikes/` — bounded investigation records.
- `docs/TESTING.md` and `docs/VALIDATION_HISTORY.md` — repeatable procedures and actual evidence.

See [documentation ownership](docs/DOCUMENTATION_OWNERSHIP.md) for the complete map.

## Dependency and rights boundary

TVM is a third-party dependency. This repository contains neither TVM code nor TVM assets and does not imply affiliation with its authors, The Indie Stone, or Steam.

## License

The original source in this repository is licensed under the [Apache License 2.0](LICENSE). Third-party names and materials remain subject to their respective rights.
