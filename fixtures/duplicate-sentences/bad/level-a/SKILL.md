# Level A (fixture)

**Status:** experimental.

## Purpose

First level of the duplicate-sentences bad fixture. Accepts task cards in
the demonstration domain and forwards conforming cards to Level B.

## Preconditions

- A task card is present with `assigned_role` set to this level.
- A prior log entry exists for the preceding transition.

## Steps

1. MUST read the task card before taking any action.
2. MUST record decisions in the card's decisions section, not in comments.
3. SHOULD confirm all preconditions are met before proceeding.

## Completion signal

- All acceptance criteria on the card are marked complete.
- A log entry is appended before the card moves.

## Failure handling

- Card MUST be returned with the specific blocker named.
- `assigned_role` MUST be set to `"user"` when blocked.
