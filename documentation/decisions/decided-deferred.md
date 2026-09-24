# Decided and Deferred Registry

Updated: 2026-09-24

## Decided

Settled architectural choices, technical constraints, and conventions.

| ID | Topic | Decision | Rationale |
|---|---|---|---|
| DEC-001 | Repository Format | Plain Markdown | Portable across hosts without a runtime; the product is the skill, not a service |
| DEC-002 | Licence Policy | Permissive only (MIT/Apache) for compiled dependencies | Compiled dependencies must impose no viral copyleft burden |
| DEC-003 | Board Backend | Connect to the existing `board/` tree | A second board for the same work is the failure this project exists to prevent |
| DEC-004 | Relay Depth | PM sizes every request; documentation and structure changes run Full | A six-role relay for a typo makes the tool unusable |
| DEC-005 | Active Perspective | Researcher | The founding incident was an unchecked premise, which only a perspective reaches |

---

## Deferred

Deliberately postponed questions. Each item defines the trigger condition required before deciding.

| ID | Topic | Rationale for Deferral | Revisit Trigger |
|---|---|---|---|
| DEF-001 | File locking for concurrent agents | File-based storage is sufficient for a single-session relay | Revisit when concurrent multi-agent access causes a collision |
| DEF-002 | A release tag | No v1.0 checklist run on a clean machine yet | Revisit when the release checklist passes end to end |
| DEF-003 | Vendored reference projects | The project's own mechanisms are documented directly | Revisit only if attribution is legally required for reused code |
