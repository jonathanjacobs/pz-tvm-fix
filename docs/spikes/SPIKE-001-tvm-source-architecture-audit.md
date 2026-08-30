# SPIKE-001: TVM source architecture audit

Status: **Source review complete; runtime measurement remains incomplete**

## Question

Which TVM paths are safe candidates for traffic control, and what blocks an uninstall claim?

## Evidence

The supplied TVM and TVM-fix archives were inspected on 2026-08-30. No third-party source or assets are included in this repository.

## Findings

- TVM keeps its authoritative machine registry in global mod data `TVM_Server`; machine objects also have TVM object mod data.
- The automatic client visuals lane periodically requests nearby registry slices and visual snapshots. The server answers accepted slices directly; this is the addon’s target lane.
- TVM separately reconciles all machines on a container-update path. It may transmit object mod data and must be measured separately from visual-request traffic.
- TVM uses server-authoritative removal and registry cleanup paths, but the supplied source does not prove that an independent addon can safely remove all machine/world references or TVM global data.

## Decision

The alpha addon limits only automatic visual-runtime requests and owns no persistent state. TVM cleanup/removal and stub ideas remain separate, backup-first investigations. Required next evidence is packet/byte measurement plus copied-save cleanup/removal testing.
