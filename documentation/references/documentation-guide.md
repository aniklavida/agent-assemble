# Documentation Guide and Drift Protocol

This reference describes documentation management and the drift reconciliation protocol between durable plans and active task cards.

## Managing Durable Documents

1. **Plans (`documentation/plans/`):**
   - Created by the BA during the Full execution path.
   - Documents problem statements, target architecture, interfaces, and decomposition into tasks.
   - Updated whenever user requirements shift.

2. **Decisions (`documentation/decisions/`):**
   - Holds the Decided and Deferred registry (`decided-deferred.md`).
   - May hold Architecture Decision Records (`adr-XXX.md`) for major structural choices.

3. **Conventions (`documentation/conventions/`):**
   - Documents local engineering standards, Definition of Done, and team-specific rules.

## Drift Reconciliation Protocol

Plans and task cards must remain aligned. When a plan changes, active work items can silently diverge unless deliberately reconciled.

Whenever an agent modifies any plan or decision document:

```
Documentation update occurs
          ↓
Enumerate all non-done cards (board/todo/, board/in-progress/, board/testing/)
          ↓
Evaluate each task card: does the documentation update alter its criteria?
          ↓
  ┌───────────────┴───────────────┐
  ▼                               ▼
No impact                      Criteria impacted
  │                               │
Proceed                        Update task card criteria & add drift note
                                  │
                               Append drift event to log/LOG.md
```

### Protocol Steps

1. **Scan Open Columns:** Read every task card residing in `board/todo/`, `board/in-progress/`, and `board/testing/`.
2. **Assess Conflict:** Determine if any acceptance criterion, assumption, or interface reference is obsolete.
3. **Reconcile Card Content:**
   - If work has not started (card is in `board/todo/`), update acceptance criteria directly.
   - If work is in progress (`board/in-progress/` or `board/testing/`), flag the item with a `[DRIFT_DETECTED]` warning in the notes, pause implementation, and re-confirm with the BA or PM.
4. **Log the Adjustment:** Append a record to `log/LOG.md` recording that criteria were updated to match the revised plan.
