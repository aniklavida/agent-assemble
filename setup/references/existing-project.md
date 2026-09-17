# Existing Project Confirmation Flow

When a project manifest, meaningful file structure, or board directory is found, use this flow instead of the full new-project interview. The goal is: ten questions become four.

## What the agent reads first

Before presenting anything, read:

1. **Manifests** (`package.json`, `*.csproj`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc.) for stack, project name, and description.
2. **Board directory** (`board/`, `.agent-assemble/board-config.md`) for where cards live.
3. **`documentation/decisions/decided-deferred.md`** for prior decisions.
4. **`README.md`** or `docs/` for scope and intent.
5. **`CONTRIBUTING.md`** for branch and PR conventions.
6. **Recent git log** (up to 10 commits) for branch naming patterns, if a shell is available.

## What a good detection summary looks like

Present findings before asking anything:

```
I read the repository and found:

**Stack:** TypeScript, Node.js — detected from package.json (scripts: build, test)
**Project name:** task-runner — from package.json "name"
**Description:** "A lightweight CLI task runner" — from package.json "description"
**Board:** board/ directory exists with todo/, in-progress/, testing/, done/ — Markdown backend.
**Branch convention:** feature/* from main — inferred from last 8 commits.
**Log:** log/LOG.md exists.
**Prior decisions:** documentation/decisions/decided-deferred.md exists with 3 decided entries.

If any of this is wrong, tell me now and I will correct it before continuing.
```

**Correction handling:** If the user says something is wrong, update the relevant field in `.agent-assemble/project.md` and re-print the corrected line. Do not re-ask anything else. Record the correction in the decided list as the authoritative answer.

## What to ask — only what cannot be read

After presenting the detection summary, ask only the questions that genuinely could not be determined. This is typically four or fewer.

Mandatory questions if not determinable from files:

- **What is the core problem being solved?** (often not in a manifest)
- **What does "done" mean here?** (local convention, not detectable)
- **Which principles apply, and at what severity?** (project choice, not detectable)
- **How much of the relay should run by default?** (agent chain depth — not detectable)

Optional — ask only if genuinely ambiguous:

- **Who is the intended user?** (if README is absent or silent)
- **Which review perspectives are active?** (only if scope suggests safety-critical or accessibility concerns)

Do not ask about the stack, board location, log location, or branch convention if they were detected.

## After confirmation

Run Step 3 and Step 4 from `setup/SKILL.md` exactly as for a new project.

The decided list must include every detected value that the user confirmed (or did not contradict), marked with `(detected)`. The deferred list records everything genuinely not answerable now.
