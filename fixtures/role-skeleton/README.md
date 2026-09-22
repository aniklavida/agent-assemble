# Role-skeleton fixture

This fixture proves that `scripts/check-role-skeleton.sh` detects role files
missing required sections.

## What is here

```
good/
  SKILL.md    role file with all five required sections — passes the check
bad/
  SKILL.md    role file missing required sections — must fail the check
```

## What the check verifies

Every role SKILL.md under `employees/` or `.agent-assemble/roles/` must contain:
- `## Purpose`
- `## Preconditions`
- `## Steps`
- `## Completion signal`
- `## Failure handling`

A file missing any of these sections exits non-zero.
