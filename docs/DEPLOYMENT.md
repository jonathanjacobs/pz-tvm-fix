# Deployment

Status: **Beta deployment procedure**

Current compatibility checkpoint: Project Zomboid `42.21.0` (`4a0e9546ec`) with the TVM Workshop release dated 2026-08-12; see [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md).

## Preflight

- Record the exact TVM and Project Zomboid versions, then back up the server world, server configuration, and account database.
- Deploy one matching addon build to the server and every participating client. Use only one effective `pz-tvm-fix` copy per machine.
- For Workshop delivery, follow [`STEAM_WORKSHOP.md`](STEAM_WORKSHOP.md).

## Rollout

1. Enable TVM and `pz-tvm-fix`, set the desired sandbox settings, then restart the server and reconnect clients.
2. Keep diagnostics enabled only for the focused evidence window.
3. Test UI opening, purchases, restocks, map state, reconnects, and traffic counters using [`TESTING.md`](TESTING.md).

## Rollback

Set `TrafficControlEnabled=false`, restart the server, and reconnect clients. Do not remove the addon from a live world until the copied-save removal scenario has passed.
