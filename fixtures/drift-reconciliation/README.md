# Documentation Drift Reconciliation Fixture

This fixture provides a worked verification scenario demonstrating the documentation drift reconciliation protocol without requiring a runtime server or daemon.

## Scenario Setup

A project maintains durable architecture choices in `documentation/decisions/decided-deferred.md`. Initially, decision `DEC-004` specified:
- **Decision:** In-memory queue channel (`Memory channel`)
- **Rationale:** In-process asynchronous queue channel

Multiple task items were created on the board across different columns:
1. `board/todo/TASK-101.md`: "Implement queue consumer worker" (relies on DEC-004 queue transport).
2. `board/in-progress/TASK-102.md`: "Implement message publisher retry mechanism" (relies on DEC-004 queue transport; Employee started implementation).
3. `board/in-progress/TASK-103.md`: "Add HTTP health check endpoint" (relies on standard HTTP routing; independent of queue transport).
4. `board/todo/TASK-104.md`: "Format log output as JSON" (standard structured logging; independent of queue transport).
5. `board/done/TASK-100.md`: "Initialize project structure and manifests" (completed historical item; independent of queue transport).

---

## Recorded Documentation Edit

During architecture review, `DEC-004` in `documentation/decisions/decided-deferred.md` is edited to survive process restarts:
- **Old Decision:** `Memory channel`
- **New Decision:** `File spool directory`
- **Updated Rationale:** Durable file-based message spool surviving process restarts.

The diff is recorded in `recorded-edit.diff`.

---

## Procedure Walkthrough and Results

### 1. Identify and Surface Dependent Items (Done When #1)
The agent audits active columns (`board/todo/`, `board/in-progress/`, `board/testing/`) against the diff in `documentation/decisions/decided-deferred.md`:
- `TASK-101` explicitly depends on DEC-004 queue transport → **Surfaced**.
- `TASK-102` explicitly depends on DEC-004 queue transport → **Surfaced**.

### 2. Confirm and Reconcile (TASK-101)
- **Constraint enforced:** Never silently rewrite a card.
- Candidate criteria adjustments for `TASK-101` were presented to the user:
  - Old: Read from memory channel.
  - Proposed: Read serialized payloads from `.spool/events/` and atomically acknowledge files.
- The user confirmed the adjustment.
- `TASK-101` was reconciled in place with updated criteria and `reconciled_at` timestamp.
- Atomic log entry appended: `TASK-101 | CARD_RECONCILED | BA | Reconciled criteria to file spool transport following user confirmation on DEC-004 | todo (Employee)`.

### 3. Flag Stale Item with What Changed Beneath It (Done When #2 & #3)
- `TASK-102` is in progress (`status: "in-progress"`, Employee had started implementing channel backpressure).
- Transitioning retry handling from memory channel buffer overflow to file spool disk write failures and lock contention introduces design choices that cannot be automatically reconciled without direction.
- **Constraints enforced:**
  - Never silently rewrite a card.
  - A card that cannot be reconciled is flagged, not deleted.
- `TASK-102` was **not deleted**. It was flagged in place:
  - `drift_status: "flagged"`
  - `assigned_role: "user"`
  - `blocked_on: "Decision needed: DEC-004 switched transport to file spool; publisher retry semantics must be specified for disk write failures"`
  - `### Drift Warning` added to notes:
    - Status: `[DRIFT_DETECTED]`
    - What changed beneath it: DEC-004 in `documentation/decisions/decided-deferred.md` changed event queue transport from in-memory channel to file spool directory.
    - Impact: Existing retry logic assumed in-memory buffer backpressure; file spool requires disk write and file lock retry handling. Work paused awaiting user guidance.
- Atomic log entry appended: `TASK-102 | DRIFT_DETECTED | BA | Flagged: DEC-004 transport changed to file spool beneath in-progress retry logic | in-progress (user)`.

### 4. Zero False Positives on Unaffected Items (Done When #4)
- `TASK-103` ("Add HTTP health check endpoint"):
  - Sits in `board/in-progress/`.
  - Touches only HTTP probe routing (`/healthz`).
  - Evaluated: no dependency on queue transport `DEC-004`.
  - **Result:** Left strictly alone. No drift status, no role reassignment, no timestamp edit, no log churn.
- `TASK-104` ("Format log output as JSON"):
  - Sits in `board/todo/`.
  - Touches standard stdout logging format.
  - Evaluated: no dependency on queue transport `DEC-004`.
  - **Result:** Left strictly alone.
- `TASK-100` ("Initialize project structure and manifests"):
  - Sits in `board/done/`.
  - Closed prior to the documentation change.
  - **Result:** Preserved in historical done state without modification.

A procedure that flags everything causes alert fatigue; this procedure ensures only genuinely affected items surface.

---

## Mechanical Verification

The script `scripts/verify-drift-reconciliation.sh` validates all invariants across this fixture:
1. Proves `TASK-101` criteria reflect `file spool directory` and log records `CARD_RECONCILED`.
2. Proves `TASK-102` exists (not deleted), is flagged with `[DRIFT_DETECTED]`, specifies what changed beneath it, and log records `DRIFT_DETECTED`.
3. Proves unaffected items (`TASK-103`, `TASK-104`, `TASK-100`) have zero drift tags and no log churn.
4. Includes sabotage verification proving the validator catches missing items, false positives, or unlogged reconciliations.

---

## Claims and Limits

**What this demonstrates:** A verifiable Markdown-based protocol where documentation changes surface dependent work items, present them for confirmation, flag unresolvable items with what changed beneath them without deletion, record events in an append-only log, and leave unaffected items untouched.

**What it cannot guarantee:** This is a set of instructions an agent follows with its file tools and shell. No host reports whether an agent executed this procedure. A skill that is ignored produces no errors from the host application. Participating agents must deliberately execute this protocol when updating durable documents.
