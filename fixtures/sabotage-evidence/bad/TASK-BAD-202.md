---
id: "TASK-BAD-202"
title: "Enforce identity check on sensitive resource access"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-21T11:30:00Z"
updated_at: "2026-09-21T12:30:00Z"
---

## Context & Request
Sensitive resources must only be accessed by their owning identity.

## Acceptance Criteria
- [x] Access by a different identity is denied with HTTP 403

## Sabotage Evidence

- criterion: Access by a different identity is denied with HTTP 403
  test: test_identity_check_denies_cross_identity_access
  mutation: Deleted the identity comparison in the resource guard
  sabotage_outcome: pass
  sabotage_cause: ""

## Handoff Trail

### Verification Handoff (SQA)
- Verdict: APPROVED
