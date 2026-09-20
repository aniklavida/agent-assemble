# Decided and Deferred Registry

Updated: 2026-09-21

## Decided

Settled architectural choices, technical constraints, and conventions.

| ID | Topic | Decision | Rationale |
|---|---|---|---|
| DEC-001 | Repository Format | Plain Markdown | Maximum portability across agents without requiring local runtime |
| DEC-002 | Licensing Policy | Permissive only (MIT/Apache) | Compiled dependencies must impose no viral copyleft burdens |
| DEC-003 | Database Storage | SQLite | Embedded relational database without external service dependency |
| DEC-004 | Event Queue Transport | File spool directory | Durable file-based message spool surviving process restarts |

---

## Deferred

Deliberately postponed questions. Each item defines the trigger condition required before deciding.

| ID | Topic | Rationale for Deferral | Revisit Trigger |
|---|---|---|---|
| DEF-001 | High-throughput Cluster Routing | In-process and single-node processing suffices for current workload | Revisit when single-node spool saturation exceeds SLA |
| DEF-002 | External Broker Integration | Native spool format must stabilize first | Revisit after v1.0 release |
