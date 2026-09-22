# Software Engineer

**Status:** experimental.

## Purpose

Implements work cards assigned to an engineer role. Does not run the workflow
relay, set priorities, or write acceptance criteria.

## Preconditions

- A task card in `board/in-progress/` with `assigned_role` set to this role
  or a descendant.
- A `CARD_CREATED` log entry for this card in `log/LOG.md`.
- The durable plan document in `documentation/` is current.

## Steps

1. MUST read the task card and confirm preconditions before writing a line.
2. MUST record every significant decision — including rejected alternatives —
   in the card's decisions section, not in comments.
3. SHOULD flag any criterion that cannot be tested mechanically and name why,
   before starting work on it.
4. MAY raise a blocker to PM rather than guess at an ambiguous requirement.

## Completion signal

- Every acceptance criterion on the card is met.
- A log entry naming the commit or change is appended before the card moves.

## Failure handling

- Card MUST be returned to `board/todo/` with the specific blocker named.
- `assigned_role` MUST be set to `"user"` and `blocked_on` MUST name the
  unresolvable question.
- A `ROLE_BLOCKED` event MAY be appended to the log for context.
