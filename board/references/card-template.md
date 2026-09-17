# Task Card Template

Use this template when creating any task card in `board/todo/`.

```markdown
---
id: "TASK-001"
title: "Imperative short summary"
size: "direct | short | full"
status: "todo"
assigned_role: "BA"
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
