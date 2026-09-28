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

## Valve Mod Content Usage

Policy section 6.1.1 references Valve's Mod Content Usage Policy, published as the [Mod Content Usage](https://developer.valvesoftware.com/wiki/Mod_Content_Usage) page on the Valve Developer Community wiki. Reviewed **2026-09-28** from the page text. The page is community-edited and flagged there as out of date, so treat it as guidance rather than a versioned legal agreement.

| Guidance | Status | Basis |
| --- | --- | --- |
| Content from other mods requires the author's permission | Pass | No TVM code, assets, or text are included. The addon wraps TVM functions by name at runtime; see [`spikes/SPIKE-001-tvm-source-architecture-audit.md`](spikes/SPIKE-001-tvm-source-architecture-audit.md). |
| Content from other games is limited by the owner's license or EULA | Not applicable | No game assets or game code are included or mounted. |
| User-uploaded content on mod-run forums must be kept free of infringement | Not applicable | The project hosts no asset-sharing forum. |

## Steam Subscriber Agreement

Policy section 6.1.1 also references the [Steam Subscriber Agreement](https://store.steampowered.com/subscriber_agreement/). Reviewed **2026-09-28** against the revision dated September 10, 2026. Only the sections that bear on publishing this Workshop item are listed.

| Section | Status | Basis |
| --- | --- | --- |
| 6.A, 6.B: licence granted to Valve for uploaded content; Workshop items are free Subscriptions | Pass | The item is free. Its content is original and Apache-2.0 licensed, so it can be licensed to Valve as the agreement requires. |
| 6.D: uploader has sufficient rights and the item is original | Pass | Same basis as the Modding Policy third-party row above. |
| 2.G: no copying, decompiling, or derivative works of Steam Content and Services without permission | Pass | No TVM or Project Zomboid files are copied, decompiled, or redistributed. TVM behavior is changed only at runtime through the Project Zomboid Lua mod system, and no TVM work is submitted (Modding Policy 4.1). TVM Lua was read as shipped, not decompiled; see SPIKE-001. |
| 2.G(ii): no emulating or redirecting Valve network protocols | Pass | The addon filters TVM's own Lua requests inside the game. It does not touch Steam or Valve protocols. |
| 4.B: no cheats or unfair competitive advantage | Pass | The addon only reduces automatic visual-sync traffic and gives no gameplay advantage. The server stays authoritative. |
| 4.C: no automation of gameplay or Steam accounts | Not applicable | The only automated behavior is the server's bounded hook-install retry, which is internal to the mod. |
| 6.C: disclosure of paid promotion or endorsement | Not applicable | No consideration is received for the item. |

This table is a project compliance record, not a legal opinion.

## Open items

- None. TVM is credited as a Steam required item (Workshop ID `3699451356`); see [`STEAM_WORKSHOP.md`](STEAM_WORKSHOP.md). Tested TVM versions are tracked in [`ROADMAP.md`](ROADMAP.md).
