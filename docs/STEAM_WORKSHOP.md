# Steam Workshop

Status: **Alpha item published; validation continues**

## Identifiers

- Workshop ID: `3793134223`
- Mod ID: `pz-tvm-fix`
- Title: `Trader Vending Machines - Network Tuner`
- Tags: Build 42, Multiplayer, QoL, WIP
- Required item: Trader Vending Machines [42], Workshop ID `3699451356`, mod ID `TraderVendingMachines`. TVM publishes no version number; record its Workshop update date as its version.
- Published revision: `27e277c`, uploaded 2026-08-30. The package has not changed since; the Workshop change note for that upload lists the late-start hook retries.

## Publish

1. Use the repository root as the staging folder: `preview.png`, `workshop.txt`, `workshop-description.bbcode`, and `Contents/mods/pz-tvm-fix/` are present. Paste the BBCode description into Steam when publishing.
2. In the Project Zomboid Workshop uploader, validate and update the existing item using `workshopid=3793134223`.
3. Retain that ID in `workshop.txt` for later updates, and update the published revision above.
4. On the server, add the numeric ID to `WorkshopItems=` and `pz-tvm-fix` to `Mods=`, then restart and confirm the download/load messages.

The title follows TVM's naming so the addon is found next to it. The description and `WIP` tag identify this as an alpha test build.
