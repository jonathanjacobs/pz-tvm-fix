# Deployment

Status: **Not yet defined**

Audience: server operators.
Use this when: packaging, installing, rolling out, or rolling back the addon.
Update this when: deployment or recovery steps change.
Do not update for: experimental observations.

## Guardrails

- Never deploy a save-affecting change without a verified backup and recovery procedure.
- Document the exact TVM compatibility version before enabling the addon on a shared server.
- Do not state a removal procedure until the addon-removal scenario in `TESTING.md` has passed.
