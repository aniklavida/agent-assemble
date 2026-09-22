# Principles

**Status:** experimental.

## Purpose

Holds craft principles chosen once per project. Does not teach those principles;
points at where they are invoked and at what severity. A model that already knows
TDD does not need a tutorial — it needs to know whether TDD applies here, and
what happens if it is skipped.

## Selection

Asked once at project setup. Three answers:

- Pick from the list in [references/catalogue.md](references/catalogue.md).
- **Keep what is already here** — detected from the codebase, shown for
  confirmation. See [references/detection.md](references/detection.md).
- None — no principles apply.

Selection is recorded in `documentation/principles.md`.

## Three modes

Each selected principle operates in exactly one mode. See
[references/modes.md](references/modes.md) for definitions and examples.

| Mode | Keyword | Where |
|---|---|---|
| Advisory | SHOULD | while the employee works |
| Prescriptive | MUST | at a handoff gate |
| Perspective | MAY | at review |

## Families

Coding · Business Analysis · Design · SQA. Full lists in
[references/catalogue.md](references/catalogue.md).
