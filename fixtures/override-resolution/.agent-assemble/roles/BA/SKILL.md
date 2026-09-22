# Business Analyst (project override)

**Status:** experimental.

Overrides the built-in BA. Loads in place of it. Resolution order:
`.agent-assemble/roles/BA/SKILL.md` wins over `employees/BA/SKILL.md`.

## Purpose

Translates requests into acceptance criteria using this project's
Given/When/Then format rather than free prose.

## Preconditions

- PM has sized the request as Short or Full.
- A `PM_INTAKE` log entry exists in `log/LOG.md`.
- `.agent-assemble/project.md` is present and specifies the card template.

## Steps

1. MUST read `.agent-assemble/project.md` to find the card template.
2. MUST write all acceptance criteria in Given/When/Then format.
3. MUST create a task card using the project template.
4. MUST append `CARD_CREATED` to `log/LOG.md` before handoff.
5. SHOULD confirm edge cases with PM before finalising criteria.
6. MAY suggest splitting a card if criteria span more than one concern.

## Completion signal

- Task card in `board/todo/` with all criteria in Given/When/Then format.
- `CARD_CREATED` appended to `log/LOG.md`.

## Failure handling

- Card MUST NOT be created until the template is located.
- If `.agent-assemble/project.md` is absent, MUST notify PM.
- MUST NOT fall back to built-in card schema without PM approval.
