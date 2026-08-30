# Testing

Status: **Procedure scaffold — no test has occurred.**

Audience: testers and release reviewers.
Use this when: running repeatable validation.
Update this when: the procedure or pass criteria change.
Do not update for: observed outcomes; use validation history.

## Required environment record

- Exact Project Zomboid build and branch.
- TVM Workshop ID/version and all enabled mods.
- Addon package revision.
- Dedicated server and client topology.
- Relevant logs, packet/traffic capture method, and saved-world copies.

## Required scenarios before claims

| Scenario | Pass criterion |
| --- | --- |
| Baseline traffic | Reproducible measurement with addon absent. |
| Addon traffic | Same scenario; evidence supports any stated reduction. |
| Clean save/load | Server and clients reconnect with addon installed. |
| Addon removal | A copied save created with addon enabled loads and permits client connection after the addon is removed. |
| TVM absence/incompatibility | Addon fails safely without corrupting saves or blocking connections. |

For traffic capture, record command direction/count and bytes separately for visual-registry slices, snapshot batches/singles, snapshot pushes, map-marker pushes, and object-mod-data transmissions. Record machine count, player count, player movement, open UIs, and container mutations.

For TVM removal investigation, test only on a copied save. Record every machine identity and coordinate, deletion success/failure, registry cleanup result, presence/absence of `TVM_Server` in Build 42 global mod data, connected-client observations, and the result of a full server restart with TVM removed.

Record real results in `VALIDATION_HISTORY.md`.

## Initial traffic-control procedure

1. With the same TVM version and copied test world, record a five-minute baseline with a stationary player, then repeat while walking through at least one TVM-dense area and opening a machine UI.
2. Install `pz-tvm-fix` on both server and clients, retain TVM, and use the default sandbox values. Repeat the same scenarios.
3. Confirm visual overlays eventually refresh after the interval and after moving at least eight tiles; confirm an opened public UI and a purchase remain immediate.
4. Repeat with one client intentionally lacking the addon. Confirm the server gate still limits visual registry slices and normal TVM interactions work.
5. Remove only `pz-tvm-fix` from the copied world and confirm normal TVM server/client connection and operation. Do not record a pass until this occurs.
