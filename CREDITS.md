# Credits and provenance

This file records where every distributed non-code asset and every piece of third-party material came from, and on what basis the mod may distribute it. Fill it in as material is added, not at release time. The rules behind it are in [`docs/PZ_MODDING_POLICY.md`](docs/PZ_MODDING_POLICY.md).

The mod distributes one piece of original artwork, in three files (`preview.png` and the derived `42/poster.png` and `42/icon.png`), and no third-party material.

## Assets

List every distributed non-code asset — artwork, UI elements, icons, preview and poster images, audio, models, fonts, and marketing images — including original work made for this mod.

| File(s) | Origin | Author | License or permission basis |
| --- | --- | --- | --- |
| `preview.png` | Generated with ChatGPT 5.6 Sol from a written description; not modified after generation. It does not copy or redistribute Project Zomboid or TVM assets | Jonathan Jacobs | Original work, licensed under Apache-2.0 like the rest of the repository; no attribution required |
| `Contents/mods/pz-tvm-fix/42/poster.png`, `Contents/mods/pz-tvm-fix/42/icon.png` | Derived from `preview.png`: the poster is an unmodified copy (256×256); the icon is the whole image scaled to 32×32 | Jonathan Jacobs | Same as `preview.png` |

Do not extract or redistribute Project Zomboid assets unless the right to do so has been explicitly verified.

## Project template

This project was created from [pz-mod-template](https://github.com/jonathanjacobs/pz-mod-template), Copyright 2026 Jonathan Jacobs, licensed under the Apache License, Version 2.0. Its attribution notice is the pz-mod-template block in [`NOTICE`](NOTICE); Apache 2.0 requires that block to stay in the `NOTICE` file of anything redistributed from this repository, including the Workshop package.

## Third-party material

None. Trader Vending Machines [42] (TVM; Workshop ID `3699451356`, mod ID `TraderVendingMachines`) is a runtime dependency declared with `require=`, not bundled material: the addon wraps TVM functions by name at runtime and includes no TVM code, assets, or text.

Add a record for each piece of third-party code, art, audio, models, text, data, or tools that the mod distributes:

- component and source URL or repository;
- author or copyright holder, where known;
- version or revision;
- license or written permission basis;
- whether it was modified;
- redistribution conditions and required attribution.

Do not list Project Zomboid runtime references here unless material is actually copied or redistributed. Mods studied only for ideas are credited in [`docs/RESEARCH_LINKS.md`](docs/RESEARCH_LINKS.md) instead.
