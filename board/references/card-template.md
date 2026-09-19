# Task Card Template

Use this template when creating any task card in `board/todo/`.

```markdown
---
id: "TASK-001"
title: "Imperative short summary"
size: "direct | short | full"
status: "todo"
assigned_role: "BA"        # who acts NEXT, not who acted last
# blocked_on: "..."      # set with assigned_role: "user" when waiting on an answer
created_at: "YYYY-MM-DDTHH:MM:SSZ"
updated_at: "YYYY-MM-DDTHH:MM:SSZ"
---

## Context & Request
Originating user request or problem description.

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Handoff Trail

### Analysis Handoff (BA)
- Plan: `documentation/plans/example.md` (or inline notes for Short path)
- Notes: Key assumptions and scope boundaries

### Implementation Handoff (Employee)
- Files modified:
  - `path/to/file.ext`
- Decisions: Technical rationale and trade-offs
- Self-verification:
  - Command: `test command`
  - Output: `result summary`

### Verification Handoff (SQA)
- Verification check:
  - Command run: `verification command`
  - Result: `pass/fail details`
- Sabotage check:
  - Mutation introduced: `inverted assertion or broken logic`
  - Sabotage test outcome: `confirmed test failure`
  - Restoration check: `restored working state and confirmed test passes`
- Verdict: `APPROVED | RETURNED`

### Acceptance Sign-off (PM)
- Log audit: `confirmed unbroken transitions in log/LOG.md`
- Sign-off note: `accepted and closed`
```

## Field Semantics and Assignment Rules

### `assigned_role` means who acts next, not who acted last

A card in `todo/` created by the BA does not say `assigned_role: "BA"` — the BA has finished with it. It says who is expected to pick it up.

This matters because the headline test for this project is that **a session with no memory can read the board and say what is done and what remains.** A column says where a card is; `assigned_role` says who it is waiting on. Without the second, "what remains" is answerable but "waiting on whom" is not, and those are different questions.

When a role finishes its part, it sets `assigned_role` to the next role before moving the task item.

### Waiting on someone outside the relay

A card blocked on an answer from the user is not in progress and is not ready to pick up. It stays in its current column with:

```yaml
assigned_role: "user"
blocked_on: "one sentence naming exactly what is needed"
```

Without this, a card waiting on a question sits in `todo/` or `in-progress/` looking like available work, and the next session picks it up and asks the same question again. That is the drift this project exists to prevent, reproduced inside the board itself.
