---
id: "TASK-103"
title: "Add HTTP health check endpoint"
size: "short"
status: "in-progress"
assigned_role: "Employee"
created_at: "2026-09-21T09:25:00Z"
updated_at: "2026-09-21T09:30:00Z"
---

## Context & Request
Expose health endpoint for container readiness probe.

## Acceptance Criteria
- [ ] Expose `/healthz` returning HTTP 200 OK with process uptime
- [ ] Respond within 50ms under standard local load

## Handoff Trail

### Analysis Handoff (BA)
- Plan: Standalone probe endpoint
- Notes: Orthogonal to queue transport.

### Implementation Handoff (Employee)
- Files modified:
  - `src/health.py`
- Decisions: Standard HTTP endpoint handler using existing web server routing.
- Self-verification:
  - Command: `python3 -m unittest tests/test_health.py`
  - Output: `Ran 2 tests in 0.01s: OK`
