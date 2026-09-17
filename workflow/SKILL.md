# Workflow Relay

**Status:** experimental.

Governs how work changes hands across named roles. Roles are named placeholders that coordinate and hand over without embedding domain assumptions.

## Sizing Gate

Every request must be evaluated by the Project Manager (PM) before any work begins. Sizing dictates the execution path, preventing trivial requests from traversing redundant gates.

Three execution paths exist:

1. **Direct**
   - **When:** Trivial typos, doc fixes, single-line adjustments with zero ambiguity and no behavioral side effects.
   - **Skips:** BA elicitation, durable plan documentation, multi-item decomposition, independent SQA test gate.
   - **Relay:** PM sizes request → PM or Employee executes edit and self-verifies → PM validates, appends log entry, and closes work item.

2. **Short**
   - **When:** Well-defined bug fixes, minor additions (1–2 files), unambiguous scope, straightforward validation.
   - **Skips:** BA user elicitation interview, separate durable plan file. Acceptance criteria are recorded directly inside a task card.
   - **Relay:** PM sizes request → BA creates a task card with acceptance criteria → Employee implements and records diff and self-verification → SQA verifies against criteria → PM validates log integrity and closes work item.

3. **Full**
   - **When:** New capabilities, cross-cutting features, architectural questions, schema or API updates, ambiguous requests.
   - **Skips:** Nothing.
   - **Relay:** PM sizes request → BA clarifies with user → BA writes durable plan in `documentation/plans/` → BA creates cards in `board/todo/` → Employee implements and documents diff in each task card → SQA tests and executes sabotage check → PM closes work item and confirms log integrity.

For exact thresholds and scoring, see [references/sizing-rubric.md](references/sizing-rubric.md).

## The Relay Cycle

Work progresses through four placeholder roles:

1. **Project Manager (PM):** Intake, sizing evaluation, assigning, and final closure sign-off.
2. **Business Analyst (BA):** Requirements elicitation, plan documentation, and card creation.
3. **Employee:** Implementation, capturing diff summary, and providing self-test evidence.
4. **Software Quality Assurance (SQA):** Independent verification against acceptance criteria, sabotage testing, and sign-off.

For step-by-step role instructions, see [references/relay-roles.md](references/relay-roles.md).

## Handoff Invariants

Every transition between roles must follow two rules:

1. **A task card is the handoff vehicle, not a record of one.** A role must read prior sections of the task card and record its own findings, diffs, or test output within its designated section before handing off.
2. **The log entry is an atomic by-product of handoff.** A handoff is incomplete until the event is appended to `log/LOG.md`. Moving a task card without an accompanying log entry invalidates the handoff, and the receiving role must reject the work item back.
