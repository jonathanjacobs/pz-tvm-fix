# Roadmap

Status: **Discovery**

Audience: contributors and reviewers.
Use this when: planning work and release gates.
Update this when: scope, sequencing, risks, or exit evidence changes.
Do not update for: completed test observations; use validation history.

## Current milestone — evidence baseline

1. Identify the exact TVM distribution, supported Project Zomboid build, and permitted integration surface.
2. Reproduce and measure network behavior in a controlled dedicated-server scenario.
3. Characterize the reported `worlddata.bin` mutation and whether it is attributable to TVM, configuration, or another mod.
4. Define a minimal addon design with no new durable save dependency.

Source audit: [`SPIKE-001-tvm-source-architecture-audit.md`](spikes/SPIKE-001-tvm-source-architecture-audit.md).

## Exit evidence

- Reproducible traffic baseline and captured evidence.
- Save-diff evidence from clean and addon-enabled scenarios.
- A documented compatibility boundary and test matrix.
