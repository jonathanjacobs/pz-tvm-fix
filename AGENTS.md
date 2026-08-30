# Codex project handoff

## Privacy boundary

- Do not copy private assistant conversation content, titles, summaries, prompts, attachments, project metadata, or inferred personal context into this repository without explicit permission.
- Translate permitted requirements into impersonal, repository-native technical language.

## Start every task here

1. Run `git status --short --branch` and preserve unrelated user changes.
2. Read `docs/DOCUMENTATION_OWNERSHIP.md` before changing documentation.
3. Use the canonical document for behavior, design, planned work, procedures, or evidence as defined there.
4. Treat reproducible tests and live Project Zomboid logs as stronger evidence than remembered API behavior or prior chat assertions.

## Project facts

- Mod name: `TVM Network and Persistence Fix`
- Mod ID: `pz-tvm-fix` (provisional; do not release until confirmed stable)
- Steam Workshop ID: `Not yet assigned`
- Supported Project Zomboid build: `Build 42; exact version TBD`
- Primary multiplayer target: `Willow Hill Games dedicated server`
- Upstream dependency: `Trader Vending Machine (TVM); exact Workshop ID/version/API TBD`

## Engineering boundaries

- This is an independent addon, not a redistribution or modification of TVM. Do not copy TVM code or assets without verified permission.
- Do not introduce persistent data in `worlddata.bin`, player saves, map data, or any other save artifact unless an explicit, evidence-backed design decision permits it.
- A disabled or removed addon must not leave a required save-state dependency. Never claim it repairs pre-existing TVM save data without a tested, backup-first migration procedure.
- Preserve server authority for shared multiplayer state. Keep diagnostics off or low-volume by default.
- Keep the deployable tree under `Contents/mods/pz-tvm-fix/`; do not package saves, logs, private configuration, decompiled source, or extracted assets.

## Verification expectations

- Before changing runtime behavior, update `docs/TESTING.md`; write actual outcomes only in `docs/VALIDATION_HISTORY.md`.
- Investigate TVM integration, traffic baselines, and persistence behavior through a spike before implementation claims.
- Recheck `git diff` for generated files, logs, saves, Workshop artifacts, and accidental third-party material before committing.
