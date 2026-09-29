# Roadmap

Status: **Beta**

Do not update for: test results ([`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md)), the details of an individual defect or question (its GitHub Issue), or release criteria ([`RELEASING.md`](RELEASING.md#release-checklist)).

Track milestones, their order, known risks, and the evidence required to leave each milestone. Cite issues here by number rather than restating them.

## Current milestone

Reach 1.0 by verifying that the addon can be removed from an existing world, without expanding the addon's persistence scope.

### 1.0 exit evidence

- Copied-save addon-removal test.

### Completed for beta

- Diagnostic evidence of automatic request suppression and state-change hooks (2026-08-30).
- Live dedicated-server use since 2026-08-30 without an addon-related issue.
- Exact TVM and Project Zomboid compatibility versions (Project Zomboid 42.21.0, TVM Workshop release dated 2026-04-20).

## Gaps from adopting pz-mod-template

The repository was restructured to pz-mod-template v0.9.0 without changing the mod package. These differences from the template were recorded for a later release, each as its own change with its own test:

- `42/mod.info` has no `poster=` or `icon=` artwork. The template recommends both.
## Later investigation

- Equal-duration baseline and event-mode packet/byte captures, if a bandwidth claim is wanted.
- Multi-player UI, purchase, restock, map-marker, reconnect, and pass-through evidence beyond normal live use.
- TVM cleanup/removal and any stub strategy remain separate, backup-first research. They are not part of this traffic-control release.
