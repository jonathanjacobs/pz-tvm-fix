# Changelog

## [0.2.0-beta] - 2026-09-28

- Moved from alpha to beta after live dedicated-server use since 2026-08-30 without an addon-related issue. No runtime change; the package differs from v0.1.0-dev only in `modversion`.
- Recorded a Project Zomboid 42.21.0 (`4a0e9546ec`) compatibility checkpoint with the TVM Workshop release dated 2026-04-20.
- Restated the public claim as automatic-polling suppression rather than measured bandwidth reduction, dropped the `WIP` Workshop tag, and split the release checklist into beta and 1.0 gates. The copied-save addon-removal test remains the 1.0 gate.

## [0.1.0-dev] - 2026-08-30

- Initialized the independent Build 42 TVM traffic-control addon.
- Added client and server guards for automatic visual registry and snapshot polling, with event-driven map-marker refreshes after successful TVM state changes.
- Added bounded late-start retries and explicit server-hook status logging when TVM initializes after the addon.
- Added sandbox controls and opt-in, low-volume diagnostics for controlled comparison.
- Added alpha Workshop staging assets and concise publication metadata.
- Recorded Workshop ID `3793134223` and removed duplicate identifiers from the Steam BBCode description.
- Consolidated repository documentation around the template’s canonical ownership model.

Runtime status: dedicated-server smoke evidence exists; measured byte reduction, broad compatibility, and addon-removal safety remain unverified.
