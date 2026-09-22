---
id: "TASK-BAD-205"
title: "Enforce rate limit on public API endpoint"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-22T10:00:00Z"
updated_at: "2026-09-22T11:00:00Z"
---

## Context & Request
The public API endpoint must enforce a per-IP rate limit.

## Acceptance Criteria
- [x] Requests exceeding the rate limit receive HTTP 429
- [x] Requests within the rate limit are served normally

## Sabotage Evidence

- criterion: Requests exceeding the rate limit receive HTTP 429
  test: "   "
  mutation: "   "
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Requests within the rate limit are served normally
  test: test_within_limit_returns_200
  mutation: Set the rate limit counter to max so every request exceeds it
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Verification Handoff (SQA)
- Verdict: APPROVED
