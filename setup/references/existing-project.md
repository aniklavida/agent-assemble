# Existing Project Confirmation Flow

When a project manifest, meaningful file structure, or board directory is found, use this flow instead of the full new-project interview. The goal is: ten questions become four — five when the repository has no board, since that one question has no default and cannot be inferred.

## What the agent reads first

Before presenting anything, read:

1. **Manifests** (`package.json`, `*.csproj`, `pyproject.toml`, `Cargo.toml`, `go.mod`, etc.) for stack, project name, and description.
2. **Board** (`.agent-assemble/board-config.md`, a `board/` tree, an Obsidian vault containing `.obsidian/`, or a Linear team/project already in use) for where cards live. If any exists, the board is *connected to*, never recreated.
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
**Board:** board/ directory exists with todo/, in-progress/, testing/, done/ — Markdown backend, connected rather than created.
**Branch convention:** feature/* from main — inferred from last 8 commits.
**Log:** log/LOG.md exists.
**Prior decisions:** documentation/decisions/decided-deferred.md exists with 3 decided entries.

If any of this is wrong, tell me now and I will correct it before continuing.
```

**Correction handling:** If the user says something is wrong, update the relevant field in `.agent-assemble/project.md` and re-print the corrected line. Do not re-ask anything else. Record the correction in the decided list as the authoritative answer.

## What to ask — only what cannot be read

After presenting the detection summary, ask only the questions that genuinely could not be determined. This is four, or five when no board was found.

Mandatory questions if not determinable from files:

- **What is the core problem being solved?** (often not in a manifest)
- **What does "done" mean here?** (local convention, not detectable)
- **Which principles apply, and at what severity?** (project choice, not detectable)
- **How much of the relay should run by default?** (agent chain depth — not detectable)
- **Where do cards live?** — **only when detection found no board.** Ask it exactly as Group C question 10 in [new-project.md](new-project.md) words it; do not offer a default here or anywhere.

  Detection can legitimately find nothing. Without this line an existing project with no board answers four questions and is never asked the one question that has no default, which is the failure this flow is most likely to produce. When a board *was* detected, connect to it and do not ask. Because Group C question 10 now includes the reachability refusal, an unreachable Linear choice is refused here too, naming the missing capability.

Optional — ask only if genuinely ambiguous:

- **Who is the intended user?** (if README is absent or silent)
- **Which review perspectives are active?** (only if scope suggests safety-critical or accessibility concerns)

Do not ask about the stack, board location, log location, or branch convention if they were detected.

## After confirmation

Run Step 3 and Step 4 from `setup/SKILL.md` exactly as for a new project.

The decided list must include every detected value that the user confirmed (or did not contradict), marked with `(detected)`. The deferred list records everything genuinely not answerable now.
