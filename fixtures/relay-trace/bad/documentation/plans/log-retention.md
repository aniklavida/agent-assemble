# Log Retention Plan

Updated: 2026-09-23

## Problem

Log entries in `log/LOG.md` accumulate indefinitely. On large projects the
file becomes unwieldy and diff output is noisy.

## Decided

| ID | Topic | Decision | Rationale |
|---|---|---|---|
| DEC-R-001 | Archive format | Append-only move | Preserves log integrity; no deletions |
| DEC-R-002 | Default retention | 90 days | Sufficient for most post-mortems |
| DEC-R-003 | Archive path | `log/archive/` | Co-located with the log for discoverability |

## Deferred

| ID | Topic | Rationale for Deferral | Revisit Trigger |
|---|---|---|---|
| DEF-R-001 | Per-project archive format | File-based is sufficient now | Revisit if SQLite backend is adopted |

## Acceptance criteria reference

1. Log entries older than the configured retention period are moved to `log/archive/`.
2. The retention period defaults to 90 days when not configured.
