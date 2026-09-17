# Decided and Deferred Registry Template

Use this template in `documentation/decisions/decided-deferred.md`.

```markdown
# Decided and Deferred Registry

Updated: YYYY-MM-DD

## Decided

Settled architectural choices, technical constraints, and conventions.

| ID | Topic | Decision | Rationale |
|---|---|---|---|
| DEC-001 | Repository Format | Plain Markdown | Maximum portability across agents without requiring local runtime |
| DEC-002 | Licensing Policy | Permissive only (MIT/Apache) | Compiled dependencies must impose no viral copyleft burdens |

---

## Deferred

Deliberately postponed questions. Each item defines the trigger condition required before deciding.

| ID | Topic | Rationale for Deferral | Revisit Trigger |
|---|---|---|---|
| DEF-001 | Persistent Storage Backend | File-based storage is sufficient for single-session prototypes | Revisit when concurrent multi-agent access causes file collisions |
| DEF-002 | External Issue Tracker Integration | Core markdown file adapters must stabilize first | Revisit after v1.0 release |
```
