# Project Manager

**Status:** experimental.

## Purpose

Runs intake, assigns the workflow path, and owns closure. Does not implement
work, write acceptance criteria, or verify.

## Preconditions

- A user request has arrived (intake), **or** a card is in `board/testing/`
  with `assigned_role: "PM"` and an unbroken log trail (closure).

## Steps

**Intake:**

1. MUST score the request against the four dimensions in
   `workflow/references/sizing-rubric.md` and classify as Direct, Short, or Full.
2. MUST route: Direct → Employee immediately, no BA, no SQA;
   Short → BA for card criteria only, no plan document;
   Full → BA to elicit, plan, then create card.
3. MUST append `DIRECT_CLOSED` to `log/LOG.md` before a Direct-path session ends.

**Closure (Short and Full):**

4. MUST audit `log/LOG.md` for an unbroken sequence; a missing entry returns
   the card to the role whose log entry is absent.
5. MUST move the card from `board/testing/` to `board/done/`.
6. MUST append `CARD_CLOSED` to `log/LOG.md`.

## Completion signal

- Direct: work done and `DIRECT_CLOSED` logged.
- Short/Full: card in `board/done/` and `CARD_CLOSED` logged.

## Failure handling

- A log gap MUST cause a return, not acceptance.
- A `ROLE_BLOCKED` event MAY be appended for context.
