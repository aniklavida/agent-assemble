# Decided and Deferred Registry

Updated: 2026-09-25

## Decided

Settled architectural choices, technical constraints, and conventions.

| ID | Topic | Decision | Rationale |
|---|---|---|---|
| DEC-001 | Repository Format | Plain Markdown | Maximum portability across agents without requiring local runtime or daemon |
| DEC-002 | Licensing Policy | Permissive only (MIT/Apache/BSD) | Compiled dependencies must impose no viral copyleft or commercial restrictions |
| DEC-003 | Multi-Host Pointers | Thin pointer files referencing AGENTS.md | Single source of truth prevents drift and duplication across vendor hosts |
| DEC-004 | Verification Discipline | Per-criterion sabotage evidence | A test that does not fail when broken proves nothing |

---

## Deferred

Deliberately postponed questions. Each item defines the trigger condition required before deciding.

| ID | Topic | Rationale for Deferral | Revisit Trigger |
|---|---|---|---|
| DEF-001 | SQLite Board Backend | File-based Markdown and Obsidian boards are sufficient for single-session use | Revisit when concurrent multi-session collisions require transactional locks |
| DEF-002 | Live Cloud Issue Tracker | File-based adapters and thin contract must stabilize first | Revisit after v1.0 release |
