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
| Event-driven traffic | Same scenario with event-driven mode; automatic visual registry/snapshot calls are blocked while no inventory changes occur. |
| Clean save/load | Server and clients reconnect with addon installed. |
| Addon removal | A copied save created with addon enabled loads and permits client connection after the addon is removed. |
| TVM absence/incompatibility | Addon fails safely without corrupting saves or blocking connections. |
| Diagnostic comparison | With diagnostics enabled, one aggregate server line and one aggregate client line identify the selected mode and forwarded, blocked, or throttled request counts. |
| Event-driven map update | A successful purchase and a restock each cause a fresh map-marker update without re-enabling automatic visual polling. With diagnostics enabled, each operation emits a rate-limited `marker_refresh_attempt source=revision_change` server line; a rejected purchase emits none. |

For traffic capture, record command direction/count and bytes separately for visual-registry slices, snapshot batches/singles, snapshot pushes, map-marker pushes, and object-mod-data transmissions. Record machine count, player count, player movement, open UIs, and container mutations.

For TVM removal investigation, test only on a copied save. Record every machine identity and coordinate, deletion success/failure, registry cleanup result, presence/absence of `TVM_Server` in Build 42 global mod data, connected-client observations, and the result of a full server restart with TVM removed.

Record real results in `VALIDATION_HISTORY.md`.

## Initial traffic-control procedure

1. With the same TVM version and copied test world, record five minutes of baseline traffic with the addon absent. Repeat a fixed route through a TVM-dense area, then open one machine and make one purchase.
2. Install `pz-tvm-fix` on both server and clients, retain TVM, set `TrafficControlEnabled=false` and `DiagnosticsEnabled=true`, then restart the server and reconnect clients. Repeat the fixed route and retain equal-duration aggregate logs as an addon-present pass-through control.
3. Set `TrafficControlEnabled=true`, `EventDrivenVisualSync=true`, and diagnostics enabled. Restart/reconnect, repeat the fixed route without opening or changing machines, and confirm automatic visual requests are blocked on both client and server.
4. In the same event-driven session, attempt one invalid purchase, then complete one purchase and restock one machine. Confirm the opened UI is immediate; the invalid purchase emits no marker-refresh line; and each real stock change causes a `marker_refresh_attempt` server line with `source=revision_change`, without background visual polling. A direct container edit detected by TVM reconciliation may instead report `source=inventory_change`.
5. Capture packet counts and byte totals for the same wall-clock windows at the server network interface or host monitor. Keep client count, machine count, route, open UIs, and mutations identical. Compare bytes and packets by direction; diagnostic counters only explain which TVM lane produced them.
6. Repeat with one client intentionally lacking the addon. Confirm the server blocks that client's automatic visual registry and snapshot requests while normal TVM interactions work.
7. Remove only `pz-tvm-fix` from the copied world and confirm normal TVM server/client connection and operation. Do not record a pass until this occurs.
