# Override-resolution fixture

This fixture demonstrates the project override mechanism.

## What is here

```
.agent-assemble/roles/BA/SKILL.md    project override (wins)
employees/BA/SKILL.md                built-in default (fallback)
log/LOG.md                           contains a ROLE_OVERRIDE entry
```

## Resolution order

```
1. .agent-assemble/roles/<role>/SKILL.md    ← project override (checked first)
2. employees/<role>/SKILL.md                ← built-in default (fallback)
```

The project override is loaded. The built-in is not loaded. The agent logs
`ROLE_OVERRIDE` before taking any action.

## What `scripts/check-workflow-override.sh` verifies

1. The project override exists at `.agent-assemble/roles/BA/SKILL.md`.
2. The built-in default exists at `employees/BA/SKILL.md`.
3. The log contains a `ROLE_OVERRIDE` entry.
4. The `ROLE_OVERRIDE` entry names the override path.
5. The override differs from the built-in (not decorative).

## The bad case

Running the script without the project override file present must fail. That is
how we know the check is load-bearing. The CI step for this fixture asserts both
pass and fail cases.
