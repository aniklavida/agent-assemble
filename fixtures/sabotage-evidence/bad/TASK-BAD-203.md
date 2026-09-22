---
id: "TASK-BAD-203"
title: "Block overwrite of finalized records"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-21T12:00:00Z"
updated_at: "2026-09-21T13:00:00Z"
---

## Context & Request
Finalized records must not be overwritten.

## Acceptance Criteria
- [x] Attempting to overwrite a finalized record returns HTTP 422

## Sabotage Evidence

- criterion: Attempting to overwrite a finalized record returns HTTP 422
  test: test_finalized_record_rejects_overwrite
  mutation: Removed the finalization guard check from the update handler
  sabotage_outcome: unresolved
  sabotage_cause: "The test stayed green after the guard was removed. Cause not yet investigated."

## Handoff Trail

### Verification Handoff (SQA)
- Verdict: APPROVED
