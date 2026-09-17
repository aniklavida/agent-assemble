# Append-Only Event Log

**Status:** experimental.

The log records an immutable, chronological history of what occurred across the relay.

Documentation records *how things are done here* (edited when decisions change); the log records *what actually happened* (accumulates indefinitely).

## The By-Product Constraint

The log is a by-product of completing a handoff, never a separate task remembered later.

Every role transition follows an atomic protocol:
1. **Fill payload:** Complete the designated role section in the task card.
2. **Append log:** Append the transition record to `log/LOG.md`.
3. **Move status:** Move the task card to the next column directory.

**Handoff validity check:** A receiving role must verify that the corresponding handoff record exists in `log/LOG.md` before commencing work. If a task card is moved without a matching log entry, the handoff is invalid and must be rejected back immediately.

## What is Recorded, When, and by Whom

All records append to `log/LOG.md` in standard tabular Markdown format:

| Column | Description | Example |
|---|---|---|
| **Timestamp** | UTC timestamp in ISO 8601 | `2026-09-18T02:30:00Z` |
| **Card ID** | Unique task identifier | `TASK-001` |
| **Event** | Lifecycle transition event | `WORK_COMPLETED` |
| **Role** | Current acting placeholder role | `Employee` |
| **Summary / Evidence** | Brief description of action and test evidence | `Fixed null check in parser; unit tests pass` |
| **Result / Next State** | Resulting state or next assigned role | `testing (SQA)` |

## Canonical Event Types

- `REQUEST_SIZED`: PM evaluates sizing (Direct, Short, or Full).
- `CARD_CREATED`: BA creates task card with acceptance criteria in `board/todo/`.
- `WORK_STARTED`: Employee moves task card to `board/in-progress/` and begins work.
- `WORK_COMPLETED`: Employee records diff and self-verification, handing off to SQA.
- `VERIFICATION_STARTED`: SQA acquires task card in `board/testing/`.
- `VERIFICATION_PASSED`: SQA verifies acceptance criteria and sabotage test, approving item.
- `VERIFICATION_FAILED`: SQA records failure evidence and returns item to Employee.
- `CARD_CLOSED`: PM confirms log completeness and moves task card to `board/done/`.
- `DIRECT_CLOSED`: PM completes direct path verification and closes work item.

For full schema details and examples, see [references/log-schema.md](references/log-schema.md).

## Rules of Append-Only Integrity

1. **Never edit past lines:** Once written, log entries are permanent.
2. **Corrections append:** If an error occurs in documentation or implementation, append an explanatory corrective event rather than rewriting history.
3. **Diffable:** Plain text tabular layout allows straightforward diff inspection and git conflict resolution.
