# Project Zomboid Modding Policy compliance

Do not update for: an individual asset or piece of third-party material (record it in [`../CREDITS.md`](../CREDITS.md)).

This project is intended for work under The Indie Stone's current Project Zomboid Modding Policy and applicable distribution-platform rules. This document is the project's engineering and release-control policy; it does not replace the authoritative policy:

- <https://projectzomboid.com/blog/modding-policy/>

A project created from this template is an unofficial independent community mod; nothing in it implies affiliation with or endorsement by The Indie Stone.

Last reviewed: **2026-09-28**, against the policy page marked "Last Updated: 04/10/2022", for Workshop item `3793134223` at package revision `0bc8905`.

This addon must not copy or redistribute TVM or Project Zomboid material without verified rights, and must not imply official endorsement. Before each Workshop update or release, recheck the current policy, provenance of each distributed file, and the release checklist.

## Mandatory rules

These apply from the first commit, not just at release.

1. Added code, art, audio, models, text, data, and tools must be original or have documented redistribution rights.
2. Public availability of another mod does not permit copying or redistribution.
3. Record every distributed asset and every piece of third-party material in [`../CREDITS.md`](../CREDITS.md) when it is added.
4. Prefer runtime references to vanilla APIs and identifiers over extracting or copying Project Zomboid assets.
5. Do not imply official status or endorsement by The Indie Stone.
6. Do not add paid/donor-exclusive functionality, malicious behavior, licensing circumvention, piracy support, or unauthorized modpack redistribution.
7. Describe material behavior changes accurately in release notes and Workshop material.

## License boundary

The repository license applies only to material the project has the right to license. It does not relicense Project Zomboid or third-party material.

## Review outcome

| Policy area | Status | Basis |
| --- | --- | --- |
| Third-party material and permission (1.1.2, 4.1, 6.1.2–6.1.3) | Pass | The package contains only original Lua, sandbox options, translation text, `mod.info`, and `preview.png`. TVM is a declared runtime dependency, not bundled. See [`../CREDITS.md`](../CREDITS.md). |
| Credit for third-party work (4.2–4.3) | Pass | The Workshop description names Trader Vending Machines as the required dependency. No third-party content requires credit. |
| Not presented as official (2.2.3) | Pass | The README and Workshop description state that the addon is unofficial and unaffiliated with The Indie Stone or the TVM authors. |
| Restricted content (2.2.1–2.2.2, 2.5) | Pass | Runtime traffic control only. No login, ownership, device-harming, objectionable, or political content. |
| Donations and commercialization (2.3–2.4) | Pass | No paid access, donation-gated content, or donation links. |
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
| 6.A, 6.B: license granted to Valve for uploaded content; Workshop items are free Subscriptions | Pass | The item is free. Its content is original and Apache-2.0 licensed, so it can be licensed to Valve as the agreement requires. |
| 6.D: uploader has sufficient rights and the item is original | Pass | Same basis as the Modding Policy third-party row above. |
| 2.G: no copying, decompiling, or derivative works of Steam Content and Services without permission | Pass | No TVM or Project Zomboid files are copied, decompiled, or redistributed. TVM behavior is changed only at runtime through the Project Zomboid Lua mod system, and no TVM work is submitted (Modding Policy 4.1). TVM Lua was read as shipped, not decompiled; see SPIKE-001. |
| 2.G(ii): no emulating or redirecting Valve network protocols | Pass | The addon filters TVM's own Lua requests inside the game. It does not touch Steam or Valve protocols. |
| 4.B: no cheats or unfair competitive advantage | Pass | The addon only reduces automatic visual-sync traffic and gives no gameplay advantage. The server stays authoritative. |
| 4.C: no automation of gameplay or Steam accounts | Not applicable | The only automated behavior is the server's bounded hook-install retry, which is internal to the mod. |
| 6.C: disclosure of paid promotion or endorsement | Not applicable | No consideration is received for the item. |

This table is a project compliance record, not a legal opinion.

## Open items

- None. TVM is credited as a Steam required item (Workshop ID `3699451356`); see [`RELEASING.md`](RELEASING.md#current-workshop-item). Tested TVM versions are tracked in [`ROADMAP.md`](ROADMAP.md).

## Release checks

Part of the [release checklist](RELEASING.md#release-checklist):

- Before the first public release, recheck the live policy and update the review date above.
- [`../CREDITS.md`](../CREDITS.md) covers every distributed file that is not original code.
- Public material (README, Workshop description, `mod.info`) presents the mod as unofficial and independent.
