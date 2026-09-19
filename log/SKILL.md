# Append-Only Event Log

**Status:** experimental.

The log records an immutable, chronological history of what occurred across the relay in `log/LOG.md`. Documentation records *how things are done here*; the log records *what actually happened*.

## The By-Product Constraint

The log is a by-product of completing a handoff, never a separate task remembered later. Every role transition follows an atomic protocol:

1. **Fill payload:** Complete the designated role section in the task card.
2. **Append log:** Append the transition event row to `log/LOG.md`.
3. **Move status:** Move the task card to the next column directory.

**Handoff validity check:** A receiving role must verify that the corresponding handoff record exists in `log/LOG.md` before commencing work. If a task card moves without a matching log entry, the handoff is invalid and must be rejected back immediately.

## Append-Only Integrity

1. **Never edit past lines:** Once written, log entries are permanent.
2. **Corrections append:** If an error occurs, append an explanatory corrective event rather than rewriting history.
3. **Diffable format:** Plain-text tabular layout enables clean inspection and git conflict resolution.

For column definitions, canonical event types, and lifecycle examples, see [references/log-schema.md](references/log-schema.md).
