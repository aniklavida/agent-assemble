# Override Resolution

**Status:** experimental.

Defines how a project's own role file replaces a built-in role, by path, with
no edit to the shipped tree.

---

## The problem this solves

`docs/SPEC.md` §1 states: *"Generic default, project override."* Without a
mechanism, that sentence describes intent but provides no path for an agent to
follow. This reference defines that path.

## Resolution order

When a role is about to be loaded, the agent checks these locations in order and
stops at the first match:

```
1. .agent-assemble/roles/<role-name>/SKILL.md   ← project override (wins)
2. employees/<role-path>/SKILL.md               ← built-in default (fallback)
```

The first file found is the one that loads. No other file changes.

**Why `.agent-assemble/`?** That directory is already where project
configuration lives (`project.md`, `board-config.md`). Role overrides belong
alongside those files rather than inside the shipped tree.

## Visibility requirement

An override that runs silently fails the same transparency test as a role that
runs without a name. When a project override loads, the agent MUST append an
entry to `log/LOG.md` using the event type `ROLE_OVERRIDE`:

```
| <timestamp> | <task-id> | ROLE_OVERRIDE | Override loaded: .agent-assemble/roles/<role-name>/SKILL.md |
```

The entry appears before the role's first action, not after.

## Demonstrating override resolution

The fixture at `fixtures/override-resolution/` proves the mechanism:

1. A built-in role file exists at a known path.
2. A project override exists at `.agent-assemble/roles/<role-name>/SKILL.md`.
3. `scripts/check-workflow-override.sh` verifies the override path wins,
   and that the log contains a `ROLE_OVERRIDE` entry for a used override.

Running the script without the project override file present must fail — this
proves the check is load-bearing, not decorative.

## Scope

Overrides apply to role behaviour only. Workflow order (who runs and when) is
data in `workflow/workflows.md` and is not overridable by this mechanism.
Sizing rules are not overridable by this mechanism.

## What is not an override

A project-specific reference document linked from a built-in role is a
supplement, not an override. It does not trigger a `ROLE_OVERRIDE` log entry.
The distinction: an override *replaces* a file; a supplement *extends* it.
