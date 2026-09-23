# Performance

**Status:** experimental.

## Purpose

Asks, at review, the cost and scale questions no other brief covers: what grows,
by how much, and whether anyone measured it. Never blocks; produces no verdict.

## Preconditions

- The work is finished and verified, so review is current.
- A project registered it, or a reviewer asked.

## Steps

1. MAY ask whether any cost here scales with input size in a way nobody measured
   — the runtime echo of this project's context-budget rule: a ceiling is
   enforced, not encouraged.
2. MAY ask whether a loop or allocation is unbounded: an input that never
   terminates, or a buffer, cache or list that only grows.
3. MAY ask whether a "fast enough on my machine" claim was measured, on what
   input, and would survive a larger one.

## Completion signal

- The perspective section lists what was asked and what came back, or records
  that nothing did.
- Nothing resembling a verdict is added.

## Failure handling

- If no answer arrives, that is recorded and nothing else happens.
- This role never changes a card's column or owner; an unmeasured cost is noted,
  not escalated as a defect.
