# Changelog

## Unreleased

- Recorded a Project Zomboid 42.21.0 (`4a0e9546ec`) compatibility checkpoint for the published v0.1.0-dev package with the TVM Workshop release dated 2026-08-12, and updated the README, Workshop description, deployment guide, and release checklist to match. No package change.

## [0.1.0-dev] - 2026-08-30

- Initialized the independent Build 42 TVM traffic-control addon.
- Added client and server guards for automatic visual registry and snapshot polling, with event-driven map-marker refreshes after successful TVM state changes.
- Added bounded late-start retries and explicit server-hook status logging when TVM initializes after the addon.
- Added sandbox controls and opt-in, low-volume diagnostics for controlled comparison.
- Added alpha Workshop staging assets and concise publication metadata.
- Recorded Workshop ID `3793134223` and removed duplicate identifiers from the Steam BBCode description.
- Consolidated repository documentation around the template’s canonical ownership model.

Runtime status: dedicated-server smoke evidence exists; measured byte reduction, broad compatibility, and addon-removal safety remain unverified.
