---
id: "TASK-200"
title: "Validate upload size limit on ingest endpoint"
size: "short"
status: "done"
assigned_role: "PM"
created_at: "2026-09-21T10:00:00Z"
updated_at: "2026-09-21T14:30:00Z"
---

## Context & Request
The ingest endpoint must reject payloads above 10 MB. Three independent checks
were in place at the time of testing.

## Acceptance Criteria
- [x] Payloads above 10 MB are rejected with HTTP 413
- [x] Payloads at or below 10 MB are accepted
- [x] The rejection is logged to the audit trail

## Sabotage Evidence

- criterion: Payloads above 10 MB are rejected with HTTP 413
  test: test_ingest_rejects_oversized_payload
  mutation: Changed the size limit constant from 10_485_760 to 999_999_999
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Payloads at or below 10 MB are accepted
  test: test_ingest_accepts_boundary_payload
  mutation: Changed boundary from <= to < so boundary-exact payload would be rejected
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: The rejection is logged to the audit trail
  test: test_audit_log_records_rejection_event
  mutation: Removed the audit_log.record() call from the rejection branch
  sabotage_outcome: pass
  sabotage_cause: "A second independent safeguard also enforces it: the middleware layer captures all 4xx responses and writes them to the audit log independently of the handler. The handler-level call is therefore redundant for this criterion."

## Handoff Trail

### Analysis Handoff (BA)
- Notes: Three independent size checks exist — framework middleware, handler guard, and
  platform adapter. Sabotage must target each criterion's own layer to produce
  an informative result.

### Implementation Handoff (Employee)
- Files modified:
  - `ingest/handler.py`
- Decisions: Kept all three layers; removing any one would leave the others as silent
  redundancy with no visible test failure, which is the wrong signal.
- Self-verification:
  - Command: `pytest tests/test_ingest.py`
  - Output: 3 passed

### Verification Handoff (SQA)
- Verification check:
  - Command run: `pytest tests/test_ingest.py`
  - Result: pass — 3 tests, 0 failures
- Sabotage check: See Sabotage Evidence section above for per-criterion mutations
  and outcomes.
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Log audit: confirmed unbroken transitions in log/LOG.md
- Sign-off note: accepted and closed
