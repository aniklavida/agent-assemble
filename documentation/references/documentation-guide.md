# Documentation Guide and Drift Protocol

This reference describes durable documentation management and the drift reconciliation protocol between durable plans and active task cards.

## Managing Durable Documents

1. **Plans (`documentation/plans/`):**
   - Authored by the Business Analyst (BA) during the Full execution path.
   - Records problem statements, technical plans, interface boundaries, and task decomposition.
   - Edited whenever requirements or constraints evolve.

2. **Decisions (`documentation/decisions/`):**
   - Houses the Decided and Deferred registry (`decided-deferred.md`).
   - Houses Architecture Decision Records (`adr-XXX.md`) for major architectural decisions.
   - Edited as technical choices are settled or superseded.

3. **Conventions (`documentation/conventions/`):**
   - Records local Definition of Done, coding guidelines, and project rules.
   - Edited as team agreements change.

---

## Documentation Drift Protocol

Documentation is edited, not appended. When plans or decisions change, task cards written against earlier versions silently go stale — and the drift is silent, because nobody re-reads an item that was correct when written.

### Locked Constraints

1. **Never silently rewrite a card:**
   Every proposed change to a task item must be presented to the user for confirmation. A board that edits itself is a second source of truth wearing a disguise.
2. **A card that cannot be reconciled is flagged, not deleted:**
   When work in progress or ambiguity prevents immediate reconciliation, the item is flagged in place with explicit notes detailing what changed beneath it. Deleting a card erases work and creates unmonitored blind spots.
3. **No false positives on unaffected items:**
   Cards unaffected by the change are left strictly alone. A procedure that flags everything is the same as one that flags nothing, because the reader stops looking.

---

### Procedure

Whenever an agent modifies any document in `documentation/`:

```
Documentation update committed or staged
               ↓
Scan non-done columns (board/todo/, board/in-progress/, board/testing/)
               ↓
Evaluate dependencies: does this item assume or reference the changed section?
               ↓
   ┌───────────────────────────┴───────────────────────────┐
   ▼                                                       ▼
Unaffected item                                 Dependent item surfaced
   │                                                       │
Leave untouched                               Present to user for confirmation
(zero false positives)                        (never rewrite silently)
                                                           │
                                             ┌─────────────┴─────────────┐
                                             ▼                           ▼
                                      User confirms               Cannot reconcile /
                                      reconciliation              needs decision
                                             │                           │
                                      Update criteria             Flag item in place
                                      & notes in item             ([DRIFT_DETECTED])
                                             │                           │
                                      Append to log:              Append to log:
                                      CARD_RECONCILED             DRIFT_DETECTED
```

#### Step 1 — Audit Open Columns
Inspect all active items in `board/todo/`, `board/in-progress/`, and `board/testing/`. Items in `board/done/` represent completed historical records and are not active work items.

#### Step 2 — Evaluate Dependency and Avoid False Positives
For each active item, inspect its acceptance criteria, context, and handoff notes:
- If the item references, implements, or depends on the section modified in documentation, mark the item as surfaced.
- If the item touches an orthogonal area (e.g. an HTTP health check when queue transport changed), leave it untouched. Do not add drift notes, do not alter timestamps, do not reassign roles.

#### Step 3 — Present Surfaced Items for Confirmation
For each surfaced item, present the proposed adjustments to the user rather than editing silently:
- State the item identifier, title, and current column.
- State exactly what changed beneath it in the documentation.
- Present the proposed modification to acceptance criteria or scope.

#### Step 4 — Reconcile or Flag
Depending on user response and task state:

- **Confirmed reconciliation:**
  If the user confirms the updated criteria:
  1. Update acceptance criteria in the item file to reflect the new documentation.
  2. Record a reconciliation note in the handoff trail.
  3. Update `updated_at` (and optional `reconciled_at`) timestamp in frontmatter.
  4. Atomically append a `CARD_RECONCILED` event to `log/LOG.md`.

- **Unreconciled or ambiguous:**
  If the item is in progress, requires design clarification, or cannot be immediately updated:
  1. Do not delete the item.
  2. Set frontmatter `drift_status: "flagged"`.
  3. Set frontmatter `assigned_role: "user"`.
  4. Set frontmatter `blocked_on: "<one sentence summarizing what changed beneath it and what is required>"`.
  5. Add a `### Drift Warning` block in the notes containing the exact document path and what changed beneath it.
  6. Atomically append a `DRIFT_DETECTED` event to `log/LOG.md`.

---

## Claims and Limits

**What this provides:** A clear operational procedure for agents to audit active work against revised durable documentation, presenting changes for user confirmation, flagging stale work without deletion, logging adjustments, and avoiding false positives.

**What it cannot provide:** Any guarantee that an agent executing in an arbitrary host loaded this skill, understood the procedure, or executed the audit steps. No host reports whether an agent followed a Markdown skill. This is a convention followed by cooperating agents, not a compiler guarantee or runtime daemon.

---

## Worked Fixture

A complete worked fixture demonstrating this protocol against a realistic scenario is located in [`fixtures/drift-reconciliation/`](../../fixtures/drift-reconciliation/). The fixture includes:
- A documentation change in `documentation/decisions/decided-deferred.md`.
- Surfaced and reconciled task item `TASK-101` in `board/todo/`.
- Flagged task item `TASK-102` in `board/in-progress/` (flagged with what changed beneath it, not deleted).
- Unaffected task items `TASK-103` (in-progress) and `TASK-104` (todo) left completely untouched.
- Event log entries in `log/LOG.md` recording `CARD_RECONCILED` and `DRIFT_DETECTED`.
- Mechanical verification via `scripts/verify-drift-reconciliation.sh`.
