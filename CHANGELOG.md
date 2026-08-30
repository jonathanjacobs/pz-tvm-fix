# Changelog

## [0.1.0-dev] - 2026-08-29

- Initialized Project Zomboid Build 42 addon scaffold for TVM network and persistence investigation.
- Adds no runtime behavior and makes no compatibility or remediation claim.

## [0.1.0-dev] - 2026-08-30

- Added configurable client and server guards for TVM automatic visual registry and snapshot polling.
- Added no persistence writes and no TVM gameplay changes.
- Added an opt-out traffic-control switch and opt-in, aggregate diagnostics for controlled before/after comparison.
- Added default event-driven visual sync: background visual polling is blocked and TVM's existing map-marker path is invoked after detected inventory changes.
- Corrected repository ignore rules so the server runtime component is versioned and deployable.
- Runtime validation remains pending.
