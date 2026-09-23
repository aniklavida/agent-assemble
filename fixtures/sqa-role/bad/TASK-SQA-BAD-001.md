---
id: "TASK-SQA-BAD-001"
title: "Add rate-limiting to the public API endpoint"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-23T08:00:00Z"
updated_at: "2026-09-23T12:00:00Z"
---

## Context & Request

The public API endpoint must reject requests above 100 per minute per client.

## Acceptance Criteria

- [x] Requests above 100 per minute are rejected with HTTP 429
- [x] Requests within the limit are served normally

## Sabotage Evidence

<!-- This card is intentionally bad: the first criterion has blank test and mutation fields. -->
<!-- SQA MUST reject this card — it violates the per-criterion evidence requirement. -->

- criterion: Requests above 100 per minute are rejected with HTTP 429
  test: ""
  mutation: ""
  sabotage_outcome: ""
  sabotage_cause: ""

- criterion: Requests within the limit are served normally
  test: test_api_rate_limit_passes_normal_requests
  mutation: Changed the limit check from <= to < so boundary request would be rejected
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Verification Handoff (SQA)
- Verdict: APPROVED
