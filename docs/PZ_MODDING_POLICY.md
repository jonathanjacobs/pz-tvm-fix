# Project Zomboid Modding Policy compliance

Authoritative policy: <https://projectzomboid.com/blog/modding-policy/>

Last reviewed: **2026-09-28**, against the policy page marked "Last Updated: 04/10/2022", for alpha Workshop item `3793134223` at package revision `0bc8905`.

This addon must not copy or redistribute TVM or Project Zomboid material without verified rights, and must not imply official endorsement. Before each Workshop update or non-alpha release, recheck the current policy, provenance of each distributed file, and the release checklist.

## Review outcome

| Policy area | Status | Basis |
| --- | --- | --- |
| Third-party material and permission (1.1.2, 4.1, 6.1.2–6.1.3) | Pass | The package contains only original Lua, sandbox options, translation text, `mod.info`, and `preview.png`. TVM is a declared runtime dependency, not bundled. See [`../THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md) and [`../ASSET_LICENSE.md`](../ASSET_LICENSE.md). |
| Credit for third-party work (4.2–4.3) | Pass | The Workshop description names Trader Vending Machines as the required dependency. No third-party content requires credit. |
| Not presented as official (2.2.3) | Pass | The README and Workshop description state that the addon is unofficial and unaffiliated with The Indie Stone or the TVM authors. |
| Restricted content (2.2.1–2.2.2, 2.5) | Pass | Runtime traffic control only. No login, ownership, device-harming, objectionable, or political content. |
| Donations and commercialisation (2.3–2.4) | Pass | No paid access, donation-gated content, or donation links. |
| Hidden or unexpected content (2.6) | Pass | Behavior is documented in the Workshop description and repository. Diagnostics are off by default and log only. |
| Modpacks and abandoned mods (7, 8) | Not applicable | The addon is not a modpack and does not reupload another mod. |

## Open items

- Valve's Mod Content Usage Policy and the Steam Subscriber Agreement, referenced by policy section 6.1.1, were not reviewed here.
- The exact TVM Workshop ID and version are not yet recorded. Add them to the Workshop description's dependency credit once they are confirmed.
