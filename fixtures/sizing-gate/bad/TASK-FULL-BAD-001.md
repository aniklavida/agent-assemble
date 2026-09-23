---
id: "TASK-FULL-BAD-001"
title: "Add configurable timeout to HTTP client"
size: "full"
status: "done"
assigned_role: "PM"
created_at: "2026-09-23T10:00:00Z"
updated_at: "2026-09-23T17:00:00Z"
---

## Context & Request

Add a configurable timeout to the HTTP client used across the service.

## Acceptance Criteria

- [x] The HTTP client respects the configured timeout value
- [x] The timeout defaults to 30 seconds when not configured

## Sabotage Evidence

- criterion: The HTTP client respects the configured timeout value
  test: test_http_client_uses_configured_timeout
  mutation: Removed the timeout parameter from the client constructor call
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: The timeout defaults to 30 seconds when not configured
  test: test_http_client_default_timeout
  mutation: Removed the default fallback so the config read would raise KeyError
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Analysis Handoff (BA)
- Plan: `documentation/plans/http-timeout.md`
- Notes: Elicitation confirmed: timeout is in seconds; defaults to 30.

### Implementation Handoff (Employee)
- Files modified:
  - `lib/http_client.py`
  - `setup/references/project-config-template.md`
- Self-verification:
  - Command: `pytest tests/test_http_client.py`
  - Output: 2 passed

### Verification Handoff (SQA)
- Verification check:
  - Command run: `pytest tests/test_http_client.py`
  - Result: pass — 2 tests, 0 failures
- Sabotage check: see Sabotage Evidence section above
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Sign-off note: accepted and closed
