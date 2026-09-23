---
id: "TASK-SQA-GOOD-001"
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

<!-- SQA ran the sabotage discipline per-criterion. -->
<!-- sabotage_cause is required when sabotage_outcome is "pass". -->

- criterion: Requests above 100 per minute are rejected with HTTP 429
  test: test_api_rate_limit_rejects_excess_requests
  mutation: Changed the rate-limit threshold constant from 100 to 999_999
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Requests within the limit are served normally
  test: test_api_rate_limit_passes_normal_requests
  mutation: Changed the limit check from <= to < so boundary request would be rejected
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Analysis Handoff (BA)
- Notes: Scope is the single public endpoint only; internal endpoints are out of scope.

### Implementation Handoff (Employee)
- Files modified:
  - `api/middleware/rate_limit.py`
- Decisions: Used token bucket algorithm to allow short bursts without rejection.
- Self-verification:
  - Command: `pytest tests/test_rate_limit.py`
  - Output: 2 passed

### Verification Handoff (SQA)
- Verification check:
  - Command run: `pytest tests/test_rate_limit.py`
  - Result: pass — 2 tests, 0 failures
- Sabotage check: see Sabotage Evidence section above
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Log audit: confirmed unbroken transitions in log/LOG.md
- Sign-off note: accepted and closed
