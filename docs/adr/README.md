# Architecture decision records

Do not update for: a routine implementation choice, or a change to an accepted decision (write a new ADR that supersedes it, and mark the old one `Superseded`).

Create an ADR when a consequential technical decision has realistic alternatives and should remain understandable after the immediate implementation work is over. Do not create ADRs for routine implementation details. In this mod, that particularly means decisions about persistence, TVM integration, or network authority.

## Format

Name each file `ADR-###-short-decision-name.md`. ADR numbers are stable and never reused; decisions start at `ADR-001`.

Each ADR includes:

- Status
- Context
- Decision
- Alternatives considered
- Consequences and tradeoffs
- Validation evidence
- Related spike, issue, or commit references where applicable

Status values: `Proposed`, `Accepted`, `Rejected`, `Deprecated`, `Superseded`. A superseded ADR stays in the repository and links to its replacement rather than being deleted.

## Index

Maintain a running list here as ADRs are added, one line each with its status and a short description. This gives an at-a-glance view of project decisions without opening every file.

None yet.
