# Workflows-as-data fixture

This fixture demonstrates that adding a new workflow requires editing
`workflow/workflows.md` only. No `SKILL.md` file changes.

## What is here

```
workflow/
  SKILL.md          copy of the shipped file — unchanged
  workflows.md      copy of the shipped file + one new project workflow (security-review)
```

## What `scripts/check-workflow-data.sh` verifies

1. The named workflow (`security-review`) appears in `workflow/workflows.md`.
2. `workflow/SKILL.md` in this fixture is identical to the shipped version,
   proving the addition required no `SKILL.md` edit.

Running the script with a non-existent workflow name must fail — that proves the
check is load-bearing.
