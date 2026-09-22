# Business Analyst (built-in)

**Status:** experimental.

## Purpose

Translates a user request into verifiable acceptance criteria and a task card.
Does not implement; defines what implementation must satisfy.

## Preconditions

- PM has sized the request as Short or Full.
- A `PM_INTAKE` log entry exists in `log/LOG.md`.

## Steps

1. The role MUST identify ambiguous assumptions before writing criteria.
2. The role MUST author unambiguous, verifiable acceptance criteria.
3. The role MUST create a task card in `board/todo/`.
4. The role SHOULD ask clarifying questions before writing any plan (Full path).
5. The role MAY propose alternative criterion formulations for PM review.

## Completion signal

- A task card exists in `board/todo/` with all criteria stated.
- A `CARD_CREATED` entry is appended to `log/LOG.md`.

## Failure handling

- The card MUST NOT be created until ambiguities are resolved.
- The role MUST return to PM with the specific unresolvable question named.
- A `ROLE_BLOCKED` event MAY be appended to the log for supplementary context.
