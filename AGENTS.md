# Codex project handoff

## Privacy boundary

- Do not copy private assistant conversation content, titles, summaries, prompts, attachments, project metadata, or inferred personal context into this repository without explicit permission.
- Do not add persona-identifying or personal information without an explicit request.
- Translate permitted requirements into impersonal, repository-native technical language.
- Apply this rule to source, docs, comments, commit messages, fixtures, logs, generated artifacts, and issue or pull-request text.

## Start every task here

1. Run `git status --short --branch` and preserve unrelated user changes.
2. Read `docs/DOCUMENTATION_OWNERSHIP.md` before changing documentation.
3. Use the canonical document for the subject being changed:
   - behavior: `docs/REQUIREMENTS.md`;
   - implementation: `docs/ARCHITECTURE.md` and `docs/adr/`;
   - planned work and release gates: `docs/ROADMAP.md`;
   - test procedure: `docs/TESTING.md`;
   - completed evidence: `docs/VALIDATION_HISTORY.md`;
   - experiments: `docs/spikes/`;
   - deployment and rollback: `docs/DEPLOYMENT.md`;
   - Workshop publication: `docs/STEAM_WORKSHOP.md`;
   - release gate: `docs/RELEASE_CHECKLIST.md`.
4. Treat reproducible tests and live Project Zomboid logs as stronger evidence than remembered API behavior or prior chat assertions.

## Project facts

- Mod name: `TVM Network Tuner`
- Mod ID: `pz-tvm-fix` (provisional; do not release until confirmed stable)
- Steam Workshop ID: `Not yet assigned`
- Supported Project Zomboid build: `Build 42; exact version TBD`
- Primary multiplayer target: `Dedicated multiplayer test server`
- Upstream dependency: `Trader Vending Machine (TVM); exact Workshop ID/version/API TBD`
- Current development state: `Alpha; controlled multiplayer validation in progress`

## Engineering boundaries

- This is an independent addon, not a redistribution or modification of TVM. Do not copy TVM code or assets without verified permission.
- Do not introduce persistent data in `worlddata.bin`, player saves, map data, or any other save artifact unless an explicit, evidence-backed design decision permits it.
- A disabled or removed addon must not leave a required save-state dependency. Never claim it repairs pre-existing TVM save data without a tested, backup-first migration procedure.
- Preserve server authority for shared multiplayer state. Keep diagnostics off or low-volume by default.
- Keep the deployable tree under `Contents/mods/pz-tvm-fix/`; do not package saves, logs, private configuration, decompiled source, or extracted assets.

## Verification expectations

- When package structure, `mod.info`, sandbox options, translations, or required Lua modules change, run the applicable validation workflow before claiming success.
- For runtime changes, update `docs/TESTING.md` before or with the implementation; add an entry to `docs/VALIDATION_HISTORY.md` only after a real test occurs.
- Use a spike for bounded uncertainty or feasibility research. Promote conclusions into requirements, architecture, or an ADR only after evidence supports them.
- Recheck `git diff` for generated files, logs, saves, Workshop artifacts, and accidental third-party material before committing.
