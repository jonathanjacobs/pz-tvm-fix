# SPIKE-001: TVM source architecture audit

Status: **Source review complete; runtime measurement pending**

Audience: implementers and reviewers.
Use this when: evaluating the initial TVM integration, traffic, and removal hypotheses.
Update this when: the inspected TVM release changes or runtime evidence alters a conclusion.
Do not update for: implementation decisions; promote those to architecture or an ADR.

## Question

Which TVM subsystems can cause the reported network load and save dependency, and what must a safe addon investigate before altering them?

## Evidence reviewed

- TVM archive `3699451356.zip`, supplied for this project on 2026-08-30.
- TVM fix archive `3788811850.zip`, supplied for this project on 2026-08-30.

No source code or assets from either archive are included in this repository.

## Observed architecture

TVM stores its authoritative registry in global mod data under `TVM_Server`. The registry includes machine records, a coordinate index, watcher state, and marker preferences. Individual world objects also carry TVM identity, ownership, label, power, battery, and lock fields in object mod data.

The client visuals runtime runs from an `OnTick` hook but gates its heavier work to roughly 0.75–2.5 seconds. It requests a nearby registry slice around the player (nominally every 1.8 seconds before backoff), then queues up to six snapshot requests per active cadence. The queue batches requests when possible and retries with an escalating backoff. Player movement or several lifecycle hints reset the slice backoff.

The server answers each visual-registry request directly; the handler accepts a radius up to 60 tiles and up to 512 rows. Batched snapshot requests can contain up to 64 machines. The server has snapshot and marker deduplication for many push paths, but the visual-registry slice response itself is returned for every accepted request.

Separately, the server runs `syncAllMachinesFromWorld()` at least once per minute and on `OnContainerUpdate` with a 250 ms gate. This walks the entire registry. Its reconciliation path writes TVM object mod data and calls object-mod-data transmission in multiple places even when the enclosing state scan ultimately reports no registry-state change. This is a plausible high-volume traffic source and must be measured separately from client request traffic.

## Removal finding

TVM already removes an entry from its global registry when a machine object is picked up or removed, clears index/watcher state, notifies every online player about the machine removal, and updates markers. That only removes registry state; it does not prove that an independent addon can safely remove the server-side world object or preserve all client/world-save invariants.

The supplied Build 42 reference confirms that `IsoGridSquare:transmitRemoveItemFromSquare(object, true)` is the server-authoritative deletion primitive. On a server it removes the object from the map and broadcasts the normal removal packet to relevant clients; the safe form also handles multi-square objects. A cleanup helper must invoke it only for an object positively matched to a TVM registry record, then confirm the deletion before completing registry retirement. A client-only sweep cannot make a dedicated-server save removable.

The cleanup must run while TVM is still installed because the current machine object and its sprite/type definitions must load before it can be identified and removed. Players not currently near a removed object do not need a client-side sweep: later chunk loading should reflect the authoritative saved world after successful deletion.

The TVM registry is global mod data under `TVM_Server`. In the supplied Build 42 reference, global mod data persists as `global_mod_data.bin`; this is the concrete file to inspect for this registry, rather than assuming it is `worlddata.bin`. The Lua API exposes `ModData.remove(tag)`, but its normal transmit API only sends an existing table. The cleanup design should therefore clear and transmit the table first for currently connected clients, retire the tag, verify it is absent before shutdown, then restart immediately with TVM removed so TVM cannot recreate it.

## Implications for the three investigations

1. **Traffic tuning:** distinguish and measure visual slice requests, batch/single snapshot requests, snapshot pushes, marker traffic, and object-mod-data transmissions. Do not tune only the client loop until the server reconciliation lane is measured.
2. **Uninstall helper:** explore a one-time, server-authoritative cleanup that inventories TVM records, finds the matching loaded world object, deletes it through `transmitRemoveItemFromSquare(..., true)`, confirms removal, retires the matching registry data, then clears/transmits/retires the global registry immediately before a controlled shutdown. It must be backup-first, admin-gated, resumable, and tested on copied saves with connected clients.
3. **Stub:** a separate addon cannot be presumed to satisfy world-save references to missing TVM object definitions. A stub may require TVM's original identity or assets and could conflict with rights or distribution rules. It is therefore a compatibility hypothesis, not the initial removal strategy.

## Missing evidence

- Whether all affected machine squares can be loaded safely and deterministically for server cleanup.
- Packet and bytes-per-command baseline for the live server topology.
- Behavior of a copied affected save after TVM cleanup and after a reboot with TVM absent.

## Next decision

Run a controlled traffic and persistence spike before implementing a runtime addon or removal tool.
