# Release checklist

Each applicable item needs evidence before the addon is labeled at that stage.

## Beta gate

- [x] `VERSION`, `CHANGELOG.md`, both `mod.info` files, and Workshop metadata agree. (0.2.0-beta.)
- [x] Exact TVM and Project Zomboid compatibility versions are recorded. (Project Zomboid 42.21.0, TVM Workshop release dated 2026-04-20.)
- [x] Diagnostic evidence shows automatic visual requests suppressed and state-change hooks installed. (2026-08-30 smoke test.)
- [x] Live dedicated-server use on the current Project Zomboid build without an addon-related error. (Live use since 2026-08-30; 42.21.0 checkpoint 2026-09-28.)
- [x] Public claims match [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md); no measured bandwidth reduction or removal safety is claimed.
- [x] Package contains no logs, saves, credentials, private configuration, source-control metadata, decompiled source, or extracted assets.
- [x] Third-party rights, attribution, Project Zomboid policy, Workshop metadata, backup, and rollback instructions are current. (Policy reviewed 2026-09-28; see [`PZ_MODDING_POLICY.md`](PZ_MODDING_POLICY.md).)

## 1.0 gate

- [ ] Copied-save addon-removal test from [`TESTING.md`](TESTING.md) passes and is recorded.
- [ ] Public claims and Workshop description drop the beta removal caveat only after that record exists.

Measured packet/byte comparison is optional investigation, not a release gate; public claims describe request suppression, not bandwidth.
