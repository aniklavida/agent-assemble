---
id: "TASK-BAD-204"
title: "Validate session token expiry on protected routes"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-22T10:00:00Z"
updated_at: "2026-09-22T11:00:00Z"
---

## Context & Request
Protected routes must reject requests carrying an expired session token.

## Acceptance Criteria
- [x] Expired session token is rejected with HTTP 401
- [x] Valid session token is accepted on protected routes
- [x] Expiry is checked against server time, not client-supplied time

## Sabotage Evidence

- criterion: Expired session token is rejected with HTTP 401
  test: test_expired_token_returns_401
  mutation: Removed the expiry comparison from the token validator
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Verification Handoff (SQA)
- Verdict: APPROVED
