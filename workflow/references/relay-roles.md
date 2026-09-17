# Relay Role Instructions

This reference describes the procedural steps for each named placeholder role across the relay.

## Project Manager (PM)

1. **Intake & Sizing:**
   - Receive the user request.
   - Consult [sizing-rubric.md](sizing-rubric.md) to classify as Direct, Short, or Full.
   - For Direct: route directly to Employee or execute immediately.
   - For Short: route to BA with instructions to write criteria into a task card.
   - For Full: route to BA with instructions to initiate requirements elicitation.

2. **Closure & Gatekeeping:**
   - Verify that all acceptance criteria are marked complete.
   - Verify that the log trail in `log/LOG.md` contains unbroken records for every role transition.
   - Move the task card from `board/testing/` to `board/done/`.
   - Atomically append `CARD_CLOSED` (or `DIRECT_CLOSED`) to `log/LOG.md`.

## Business Analyst (BA)

1. **Elicitation (Full path only):**
   - Identify ambiguous assumptions or unstated constraints.
   - Ask clarifying questions before writing code or plans.

2. **Planning (Full path only):**
   - Author a durable plan document under `documentation/plans/`.
   - Verify existing plans and decisions for potential drift.

3. **Card Creation (Short and Full paths):**
   - Formulate unambiguous, verifiable acceptance criteria.
   - Create a task card in `board/todo/` following the schema in `board/SKILL.md`.
   - Atomically append `CARD_CREATED` to `log/LOG.md`.
   - Hand off to Employee.

## Employee

1. **Acquisition:**
   - Read the assigned task card from `board/todo/`.
   - Update frontmatter status to `in-progress` and move the file into `board/in-progress/`.
   - Atomically append `WORK_STARTED` to `log/LOG.md`.

2. **Implementation:**
   - Execute the necessary edits and adjustments using local tools.
   - Run self-verification tests to confirm the changes satisfy the criteria.

3. **Handoff:**
   - Fill the `### Implementation Handoff` section inside the task card with:
     - Modified file paths.
     - Implementation rationale and key decisions.
     - Self-verification commands and results.
   - Move the file to `board/testing/`.
   - Atomically append `WORK_COMPLETED` to `log/LOG.md`.
   - Hand off to SQA.

## Software Quality Assurance (SQA)

1. **Intake:**
   - Read the task card in `board/testing/`, specifically reviewing acceptance criteria and implementation notes.

2. **Independent Verification:**
   - Run verification tests against the modified code.
   - Perform a sabotage test: deliberately introduce a break or invert an assertion to verify that tests fail when broken. Then restore working code. A test that passes when the implementation is broken proves nothing.

3. **Handoff / Rejection:**
   - Document verification results and sabotage test evidence inside `### Verification Handoff` in the task card.
   - If criteria pass: update status to `testing`, assign to PM, and atomically append `VERIFICATION_PASSED` to `log/LOG.md`.
   - If criteria fail: move the file back to `board/in-progress/`, reassign to Employee with explicit defect notes, and atomically append `VERIFICATION_FAILED` to `log/LOG.md`.
