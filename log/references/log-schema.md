# Event Log Schema and Examples

This reference provides the schema specification and end-to-end examples for `log/LOG.md`.

## Table Structure

```markdown
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
```

### Field Definitions

1. **Timestamp:** ISO 8601 UTC formatted string (`YYYY-MM-DDTHH:MM:SSZ`).
2. **Card ID:** Alphanumeric identifier matching the frontmatter `id:` in the corresponding task card (or direct task tag).
3. **Event:** Exactly one of the permitted lifecycle events:
   - `REQUEST_SIZED`: PM evaluates sizing (Direct, Short, or Full).
   - `CARD_CREATED`: BA creates task card with acceptance criteria in `board/todo/`.
   - `WORK_STARTED`: Employee moves task card to `board/in-progress/` and begins work.
   - `WORK_COMPLETED`: Employee records diff and self-verification, handing off to SQA.
   - `VERIFICATION_STARTED`: SQA acquires task card in `board/testing/`.
   - `VERIFICATION_PASSED`: SQA verifies acceptance criteria and sabotage test, approving item.
   - `VERIFICATION_FAILED`: SQA records failure evidence and returns item to Employee.
   - `CARD_CLOSED`: PM confirms log completeness and moves task card to `board/done/`.
   - `DIRECT_CLOSED`: PM completes direct path verification and closes work item.
   - `DRIFT_DETECTED`: Documentation changed beneath active task item; item flagged with changes and blocked on user resolution.
   - `CARD_RECONCILED`: Task item criteria updated to match revised documentation following user confirmation.
4. **Role:** Placeholder role executing the event (`PM`, `BA`, `Employee`, `SQA`).
5. **Summary / Evidence:** Concrete factual record of actions taken, files edited, test outcomes, or rationale.
6. **Result / Next State:** Resulting column and recipient role (e.g., `testing (SQA)`, `done`).

---

## Worked Examples

### 1. Full Path Relay Lifecycle

```markdown
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-09-18T10:00:00Z | TASK-101 | REQUEST_SIZED | PM | Sized incoming query feature as Full due to API changes | backlog (BA) |
| 2026-09-18T10:15:00Z | TASK-101 | CARD_CREATED | BA | Elicited scope; created plan documentation/plans/query.md and acceptance criteria | todo (Employee) |
| 2026-09-18T10:20:00Z | TASK-101 | WORK_STARTED | Employee | Acquired task card; initialized branch and local workspace | in-progress (Employee) |
| 2026-09-18T11:00:00Z | TASK-101 | WORK_COMPLETED | Employee | Implemented query parser; modified src/query.py; self-tests passed | testing (SQA) |
| 2026-09-18T11:05:00Z | TASK-101 | VERIFICATION_STARTED | SQA | Began independent test execution and boundary analysis | testing (SQA) |
| 2026-09-18T11:20:00Z | TASK-101 | VERIFICATION_PASSED | SQA | All acceptance criteria satisfied; sabotage check passed (broken assertion failed) | review (PM) |
| 2026-09-18T11:30:00Z | TASK-101 | CARD_CLOSED | PM | Verified log completeness and acceptance criteria; merged | done |
```

### 2. Direct Path Trivial Lifecycle

```markdown
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-09-18T12:00:00Z | DIRECT-01 | REQUEST_SIZED | PM | Evaluated typo fix in README.md as Direct path | in-progress (PM) |
| 2026-09-18T12:05:00Z | DIRECT-01 | DIRECT_CLOSED | PM | Fixed typo in README.md line 14; visual check confirmed clean rendering | done |
```

### 3. Rejection and Resubmission Lifecycle

```markdown
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-09-18T14:00:00Z | TASK-102 | VERIFICATION_FAILED | SQA | Edge case failed: empty payload raises uncaught ValueError | in-progress (Employee) |
| 2026-09-18T14:30:00Z | TASK-102 | WORK_COMPLETED | Employee | Added guard for empty payload; regression test added and passing | testing (SQA) |
| 2026-09-18T14:45:00Z | TASK-102 | VERIFICATION_PASSED | SQA | Empty payload handled gracefully; sabotage check verified; approved | review (PM) |
| 2026-09-18T15:00:00Z | TASK-102 | CARD_CLOSED | PM | Final review verified; closed | done |
```

### 4. Documentation Drift Reconciliation Lifecycle

```markdown
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-09-21T10:00:00Z | TASK-101 | CARD_CREATED | BA | Created queue consumer item assuming in-memory channel (DEC-004) | todo (Employee) |
| 2026-09-21T10:30:00Z | TASK-101 | CARD_RECONCILED | BA | Reconciled criteria to file spool transport following user confirmation on DEC-004 | todo (Employee) |
| 2026-09-21T10:30:00Z | TASK-102 | DRIFT_DETECTED | BA | Flagged: DEC-004 transport changed to file spool beneath in-progress retry logic | in-progress (user) |
```
