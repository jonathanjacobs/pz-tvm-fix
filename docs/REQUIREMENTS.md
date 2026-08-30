# Requirements

Status: **Alpha traffic-control implementation**

## Project identity

- Mod ID: `pz-tvm-fix` (provisional)
- Target: Project Zomboid Build 42 dedicated multiplayer
- Dependency: Trader Vending Machine (TVM); exact compatible release remains to be recorded

## Scope

In scope: an independent, optional addon that reduces TVM automatic visual-runtime traffic and adds no new durable save dependency.

Out of scope: redistributing or modifying TVM; repairing existing TVM saves; claiming that TVM itself is removable.

## Normative behavior

1. The addon affects only TVM requests tagged as automatic visual-runtime work. Public UI, purchases, owner actions, placement, and TVM persistence remain outside the guard.
2. Shared state remains server-authoritative. In event mode, the server rejects automatic visual registry and snapshot requests from clients that lack or bypass the client guard.
3. A successful TVM state revision or detected direct container change may refresh TVM's existing deduplicated map-marker path. A rejected purchase must not trigger the addon refresh.
4. Traffic control defaults on; diagnostics default off. Operators can switch to pass-through mode and enable aggregate, rate-limited diagnostics through sandbox settings.
5. The addon must add no persistent telemetry or required world/player-save state, and must fail safely if its TVM integration surface is absent or incompatible.
6. Performance, compatibility, and addon-removal claims require the evidence listed in [`TESTING.md`](TESTING.md).
