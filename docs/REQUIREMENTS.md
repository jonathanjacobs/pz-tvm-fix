# Requirements

Status: **Initial traffic-control implementation**

Audience: implementers and reviewers.
Use this when: defining or verifying required behavior.
Update this when: a requirement changes or is evidence-backed.
Do not update for: unverified engine hypotheses; use a spike instead.

## Project identity

- Mod name: `TVM Network and Persistence Fix`
- Mod ID: `pz-tvm-fix` (provisional)
- Target Build: `Project Zomboid Build 42; exact version TBD`
- Primary supported mode: `Dedicated multiplayer`
- Dependency: `Trader Vending Machine (TVM); exact compatible version TBD`

## Scope

- In scope: an optional, independently packaged TVM addon; traffic characterization; reductions supported by verified integration points; save/uninstall safety for addon-owned behavior.
- Explicitly out of scope: bundling, copying, or modifying TVM; untested repair of existing TVM save data; a claim that removing TVM itself is safe.

## Normative behavior

1. The addon must fail safely when its required TVM version or integration surface is absent or incompatible.
2. The addon must not create a persistent world or player-save dependency required for future server or client connection.
3. Removing the addon after normal use must not require its data to load, subject to dedicated save/load and client-connection validation.
4. Network changes must preserve server authority and be supported by before/after evidence from a defined multiplayer scenario.
5. A migration touching pre-existing save data, if ever proposed, must be opt-in, backup-first, separately documented, and validated on copied saves.
6. The initial traffic-control release must affect only TVM automatic visual-runtime requests. Public UI, purchases, owner actions, placement, and registry persistence are out of scope.
7. The server must reject over-frequent visual registry-slice requests even if a client does not run the companion client guard.
