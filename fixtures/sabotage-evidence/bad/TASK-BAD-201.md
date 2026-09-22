---
id: "TASK-BAD-201"
title: "Reject duplicate submissions"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-21T11:00:00Z"
updated_at: "2026-09-21T12:00:00Z"
---

## Context & Request
Submissions with a duplicate idempotency key must be rejected.

## Acceptance Criteria
- [x] Duplicate submission is rejected with HTTP 409
- [x] First submission is accepted normally

## Sabotage Evidence

- criterion: Duplicate submission is rejected with HTTP 409
  test: ""
  mutation: ""
  sabotage_outcome: ""
  sabotage_cause: ""

- criterion: First submission is accepted normally
  test: test_first_submission_accepted
  mutation: Inverted the idempotency key lookup result
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Verification Handoff (SQA)
- Verdict: APPROVED
