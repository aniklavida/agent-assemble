# Relay Role Instructions

This reference links each relay role to its canonical role file and summarises
the procedural steps it contributes to the relay.

Role files are the authoritative source; this document must not restate them.

## Project Manager (PM)

Role file: [employees/project-manager/SKILL.md](../../employees/project-manager/SKILL.md)

1. **Intake & Sizing:** Receive the user request and classify as Direct, Short,
   or Full using [sizing-rubric.md](sizing-rubric.md).
   - Direct: route to Employee; no BA, no SQA gate.
   - Short: route to BA for card criteria only; no plan document.
   - Full: route to BA to elicit, plan, then create card.

2. **Closure:** Audit `log/LOG.md` for an unbroken trail, move the card to
   `board/done/`, and append `CARD_CLOSED` (or `DIRECT_CLOSED` for Direct).

## Business Analyst (BA)

Role file: [employees/business-analyst/SKILL.md](../../employees/business-analyst/SKILL.md)

1. **Elicitation (Full path only):** Surface assumptions; ask clarifying
   questions before writing a plan.
2. **Planning (Full path only):** Author a durable plan in `documentation/plans/`.
3. **Card Creation (Short and Full):** Write unambiguous criteria; create the
   task card in `board/todo/` with the required frontmatter fields from
   `board/references/card-template.md`; append `CARD_CREATED` to `log/LOG.md`.

## Employee

The employee role is determined by the card's `assigned_role` field. For the
Software Engineer vertical slice, see
[employees/software-engineer/SKILL.md](../../employees/software-engineer/SKILL.md)
and its descendants.

1. **Acquisition:** Read the card; move to `board/in-progress/`; append
   `WORK_STARTED` to `log/LOG.md`.
2. **Implementation:** Execute the task; run self-verification.
3. **Handoff:** Fill `### Implementation Handoff`; move card to
   `board/testing/`; append `WORK_COMPLETED` to `log/LOG.md`.

## SQA

Role file: [employees/sqa/SKILL.md](../../employees/sqa/SKILL.md)

1. **Intake:** Read the card in `board/testing/`, reviewing criteria and
   the implementation handoff.
2. **Independent Verification:** Verify each criterion independently. Run the
   per-criterion sabotage discipline with the three-outcome rule as described
   in the role file and `board/references/sabotage-evidence-guide.md`.
3. **Handoff / Rejection:** Fill `### Verification Handoff`. On pass, append
   `VERIFICATION_PASSED` and assign to PM. On fail, move back to
   `board/in-progress/`, reassign to Employee, and append
   `VERIFICATION_FAILED` to `log/LOG.md`.
