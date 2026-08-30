# Documentation ownership

This file defines where mutable project information belongs so the repository does not maintain competing copies of the same facts.

| Information | Canonical source |
| --- | --- |
| Public overview and release identity | [`../README.md`](../README.md), [`../VERSION`](../VERSION), and [`../CHANGELOG.md`](../CHANGELOG.md) |
| Normative runtime behavior | [`REQUIREMENTS.md`](REQUIREMENTS.md) |
| Implementation design | [`ARCHITECTURE.md`](ARCHITECTURE.md) and [`adr/`](adr/) |
| Planned work and release-exit criteria | [`ROADMAP.md`](ROADMAP.md) |
| Repeatable test procedure | [`TESTING.md`](TESTING.md) |
| Actual test outcomes | [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md) |
| Experimental evidence | [`spikes/`](spikes/) |
| Deployment and rollback | [`DEPLOYMENT.md`](DEPLOYMENT.md) |
| Workshop publication | [`STEAM_WORKSHOP.md`](STEAM_WORKSHOP.md) |
| Release gate | [`RELEASE_CHECKLIST.md`](RELEASE_CHECKLIST.md) |
| Policy and provenance | [`PZ_MODDING_POLICY.md`](PZ_MODDING_POLICY.md), [`../COMPLIANCE.md`](../COMPLIANCE.md), [`../THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md), and [`../ASSET_LICENSE.md`](../ASSET_LICENSE.md) |

## Duplication rule

Repeat a small fact only when necessary for immediate usability or safety. Do not duplicate complete specifications, validation tables, experimental narratives, roadmaps, or configuration explanations that already have a canonical home.

Update the canonical source first when behavior changes; replace secondary detail with a link where practical.
