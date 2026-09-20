---
id: "TASK-102"
title: "Implement message publisher retry mechanism"
size: "short"
status: "in-progress"
assigned_role: "user"
blocked_on: "Decision needed: DEC-004 switched transport to file spool; publisher retry semantics must be specified for disk write failures"
drift_status: "flagged"
created_at: "2026-09-21T09:15:00Z"
updated_at: "2026-09-21T10:30:00Z"
---

## Context & Request
Add retry handling when publishing event messages.

## Acceptance Criteria
- [ ] Retry transient publish failures with exponential backoff
- [ ] Emit warning log on retry exhaustion

## Handoff Trail

### Analysis Handoff (BA)
- Plan: Inline criteria
- Notes: Initial assumptions based on in-memory channel backpressure.

### Drift Warning
- Detected: 2026-09-21T10:30:00Z
- Status: [DRIFT_DETECTED]
- What changed beneath it: DEC-004 in `documentation/decisions/decided-deferred.md` changed event queue transport from in-memory channel to file spool directory.
- Impact: In-progress retry implementation assumed memory buffer overflow; file spool requires disk write and file lock retry handling. Work paused; awaiting user direction.

### Implementation Handoff (Employee)
- Files modified:
  - `src/publisher_retry.py` (paused)
- Decisions: Paused due to drift in DEC-004.
