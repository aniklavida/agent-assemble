# Example Role

**Status:** experimental.

## Purpose

Demonstrates that a role file with all five required sections passes
`scripts/check-role-skeleton.sh`. Accepts task cards, validates them,
and forwards conforming cards to the next stage.

## Preconditions

- A task card in `board/in-progress/` with `assigned_role` set to this role.
- A matching log entry for the prior transition in `log/LOG.md`.

## Steps

1. MUST read the task card and verify all preconditions are met.
2. MUST confirm the prior log entry exists before acting.
3. SHOULD cross-reference open items in `board/todo/` for related work.
4. SHOULD document key decisions in the card's designated section.
5. MAY suggest alternative approaches in the card's notes section.

## Completion signal

- All acceptance criteria in the card are marked complete.
- The card's designated section is filled with findings and evidence.
- A log entry is appended to `log/LOG.md` before the card moves.

## Failure handling

- Card MUST be returned to the prior column with explicit defect notes.
- `assigned_role` MUST be updated to the prior role.
- A log entry MUST be appended naming the specific blocker.
- The role MAY append a `ROLE_BLOCKED` event for supplementary context.
