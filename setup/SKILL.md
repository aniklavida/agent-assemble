# Setup Interview

**Status:** experimental.

A one-time interview collecting project decisions needed to run the relay. Run once; record answers in documentation; never ask again.

## When to Run

Run when `.agent-assemble/project.md` is absent or re-run is requested. If configured, print settings and stop without asking.

## Step 1 — Detect Before Asking

Inspect manifests, board directories, documentation, and git history. Present detection findings first. Manifests replace stack questions. Board location has no default: ask if none exists.

## Step 2 — Choose Path

- **New project:** Empty or unconfigured repositories run the three-group interview (scope, way of working, plumbing). See [references/new-project.md](references/new-project.md).
- **Existing project:** Repositories with manifests run confirmation; questions reduce to four (or five if no board found). See [references/existing-project.md](references/existing-project.md).

## Step 3 — Write Outputs

Record answers without further confirmation:
- `.agent-assemble/project.md`: See [references/project-config-template.md](references/project-config-template.md).
- `documentation/decisions/decided-deferred.md`: Settled choices and deferred triggers.
- `.agent-assemble/board-config.md` and required board or doc directories.

## Step 4 — Confirm

Print summary of written files, answered decisions, and deferred triggers. State: *"Setup is complete. I will not ask these questions again."*
