---
id: "TASK-DIRECT-BAD-001"
title: "Fix typo in error message"
size: "direct"
status: "done"
assigned_role: "PM"
created_at: "2026-09-23T09:00:00Z"
updated_at: "2026-09-23T09:05:00Z"
---

## Context & Request

Fix the typo "calulate" → "calculate" in `lib/math.py` line 7.

## Acceptance Criteria

- [x] The string "calulate" no longer appears in `lib/math.py`

## Handoff Trail

### Implementation Handoff (Employee)
- Files modified:
  - `lib/math.py`
- Decisions: Simple typo correction; no logic change.
- Self-verification:
  - Command: `grep -c "calulate" lib/math.py`
  - Output: 0

### Acceptance Sign-off (PM)
- Sign-off note: accepted and closed
