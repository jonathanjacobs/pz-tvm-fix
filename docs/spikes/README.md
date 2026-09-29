# Spikes

Do not update for: planned test procedures ([`../TESTING.md`](../TESTING.md)), dated test results that are not part of an open question ([`../VALIDATION_HISTORY.md`](../VALIDATION_HISTORY.md)), or release claims.

Use a spike for a bounded feasibility question or uncertain engine behavior: *does this event fire on a dedicated server?*, *can the client read this value without a server round trip?*, *why does this option reset after a restart?* Name it `SPIKE-###-short-topic.md`. Numbers are never reused.

A question you can answer in an hour and explain in a sentence does not need a spike. Write one when the answer will shape a requirement, an architecture choice, or an ADR, or when the reasoning would be expensive to reconstruct later.

A spike is evidence, not a release claim. Promote supported conclusions into requirements, architecture, or an ADR when appropriate; until then, a conclusion recorded only in a spike is not a requirement or a validated behavior.

Write up a NO-GO as carefully as a GO. It records the evidence that ruled the approach out, so the question is not reopened months later by someone, or some agent, with no way of knowing it was already answered.

Spikes are where log excerpts and server details get pasted while work is still informal. Follow [`../PRIVATE_DATA.md`](../PRIVATE_DATA.md): describe the test server by kind and replace IP addresses, Steam IDs, and player names with placeholders.

## Status

| Status | Meaning |
| --- | --- |
| `Open` | Still being investigated |
| `GO` | The evidence supports the approach |
| `GO with conditions` | Supported only within the stated limits |
| `NO-GO` | The evidence does not support the approach |
| `Inconclusive` | Work stopped without a usable answer; the spike says why |
| `Superseded` | A later spike replaced this one; link to it |

Leave a finished spike in place. If later evidence overturns it, write a new spike and mark this one `Superseded`.

## Index

One line per spike with its status, so the state of open questions is visible without opening every file.

| Spike | Status | Question |
| --- | --- | --- |
| [SPIKE-001](SPIKE-001-tvm-source-architecture-audit.md) | Source review complete; runtime measurement incomplete (recorded before this status scale was adopted) | Which TVM paths are safe candidates for traffic control, and what blocks an uninstall claim? |

## Record structure

Keep only the sections that help someone judge or repeat the work.

```markdown
# SPIKE-###: <short title>

- Status: Open | GO | GO with conditions | NO-GO | Inconclusive | Superseded
- Started / last updated: YYYY-MM-DD
- Related requirement, ADR, or issue: <links>

## Question

The single question this answers, and what decision depends on it.

## What would settle it

The result that would mean GO, and the result that would mean NO-GO. Write this before running anything, so the answer is not chosen after seeing the logs.

## Environment and procedure

Project Zomboid version and revision, mod build, topology described by kind, and the steps taken, in enough detail for someone else to repeat them.

## Evidence

What was observed, including unexpected, partial, and negative results, with the relevant log lines (private values replaced). Raw logs stay in a local folder outside the repository.

## Outcome

The status, what the evidence supports and what it does not, and the conditions under which the conclusion may not hold.

## Follow-up

The requirement, architecture note, ADR, test, or issue this produced, and any question left open.
```
