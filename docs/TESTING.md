# Testing

Status: **Alpha procedure; smoke evidence is recorded separately**

Record the exact Project Zomboid and TVM versions, addon revision, enabled mods, topology, route, machine count, player count, and capture method for every comparison. Keep logs and saves outside the repository; record outcomes in [`VALIDATION_HISTORY.md`](VALIDATION_HISTORY.md).

| Scenario | Setup and pass criterion |
| --- | --- |
| Baseline | Addon absent; capture five minutes of visual-request and packet/byte traffic on a fixed route. |
| Pass-through control | Addon installed with traffic control disabled; behavior and traffic match the baseline. |
| Event mode | Traffic control and diagnostics enabled after restart/reconnect; automatic visual calls are blocked and normal UI remains immediate. |
| State changes | Invalid purchase logs no refresh; successful purchase and owner restock log `source=revision_change`; map state is current. |
| Mixed clients | A client without the addon cannot make the server forward automatic visual requests; normal TVM interaction works. |
| Save/removal | On a copied world only, reconnect with the addon, then remove only the addon and verify restart and client connection. |

Compare packet counts and bytes separately for visual slices, snapshots, snapshot pushes, map-marker pushes, and object-mod-data traffic. Diagnostic counters explain guard decisions; they are not bandwidth measurements.
