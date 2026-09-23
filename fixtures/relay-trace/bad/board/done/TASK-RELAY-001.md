---
id: "TASK-RELAY-001"
title: "Add configurable log retention period"
size: "full"
status: "done"
assigned_role: "PM"
created_at: "2026-09-23T08:00:00Z"
updated_at: "2026-09-23T17:00:00Z"
---

## Context & Request

When log entries in `log/LOG.md` exceed a configurable age, they should be
archived to `log/archive/`. The retention period and archive path are
configurable per project.

## Acceptance Criteria

- [x] Log entries older than the configured retention period are moved to `log/archive/`
- [x] The retention period defaults to 90 days when not configured

## Sabotage Evidence

- criterion: Log entries older than the configured retention period are moved to `log/archive/`
  test: test_log_retention_archives_old_entries
  mutation: Changed the age comparison from > to < so no entries would be archived
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: The retention period defaults to 90 days when not configured
  test: test_log_retention_default_period
  mutation: Removed the default fallback so the config read would raise KeyError
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Analysis Handoff (BA)
- Plan: `documentation/plans/log-retention.md`
- Notes: Elicitation confirmed: entries are moved, not deleted; the archive
  path defaults to `log/archive/`; entries in-flight are not interrupted.

### Implementation Handoff (Employee)
- Files modified:
  - `log/retention.py`
  - `setup/references/project-config-template.md`
- Decisions: Archive uses append-only move (copy then delete) to preserve
  atomicity. Retention check runs at PM closure, not on every log write.
- Self-verification:
  - Command: `pytest tests/test_log_retention.py`
  - Output: 2 passed

### Verification Handoff (SQA)
- Verification check:
  - Command run: `pytest tests/test_log_retention.py`
  - Result: pass — 2 tests, 0 failures
- Sabotage check: see Sabotage Evidence section above
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Log audit: confirmed CARD_CREATED → WORK_STARTED → WORK_COMPLETED →
  VERIFICATION_PASSED sequence in log/LOG.md; trail is unbroken.
- Sign-off note: accepted and closed
