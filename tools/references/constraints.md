# Constraints

Constraints decide whether a candidate is offered at all. They are the
project's, recorded once, and applied before a suggestion is made.

## The constraints

| Constraint | Rule |
|---|---|
| **Licence policy** | See [licence-policy.md](licence-policy.md). Compiled → permissive; separate process → copyleft allowed; never the gated list. |
| **Cost ceiling** | A maximum monthly spend, recorded per project. A candidate above it is not offered. |
| **Already paid for** | Tools the project already pays for. A vendor-locked tool already paid for is not a new lock. |
| **Vendor lock** | A candidate that ties the project to one vendor is not offered unless it is already paid for. |

The cost ceiling is a number the project sets. It is not "cheap" or "reasonable";
it is the figure above which the answer is no.

## The filter

A suggestion request runs through the constraints in this order:

1. **Never-adopt licence** — SSPL, BSL, RSAL, Elastic, RPL or revenue-/
   headcount-gated → remove. No caveat, no "but".
2. **Compiled and non-permissive** — a compiled candidate whose licence is not
   MIT, Apache-2.0 or BSD → remove.
3. **Cost** — above the project's ceiling → remove.
4. **Vendor lock** — a vendor-locked candidate not already paid for → remove.

Only survivors are offered. This ordering matters: the licence rules come first,
so a candidate is never rescued by being cheap.

## What the caller gets

The filter never returns a rejected candidate with a warning attached. A
violation is not offered at all, full stop — the same rule as the licence
policy itself. What is returned is the short list that already passed; the
refusals are recorded as decision rows
([registry.md](registry.md)), not shown as live options.

This is the difference between two behaviours:

- **Wrong:** "`elasticsearch` is popular, but its licence may be a problem."
- **Right:** `elasticsearch` is not in the list.

## A worked filter

Given the ceiling `0`, one already-paid tool, and candidates across all four
constraint types, the filter returns only the four that pass and drops the four
that do not. `fixtures/tools-registry/suggestion/` holds that case and
`scripts/check-tools-registry.sh` proves it.
