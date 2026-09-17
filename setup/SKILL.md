# Setup Interview

**Status:** experimental.

A one-time interview that collects every project decision needed to run the relay. Run it once; write every answer to documentation; never ask again.

## When to run

Run this skill when:
- `.agent-assemble/project.md` does not exist (new or unconfigured project), **or**
- The user explicitly asks to re-run setup.

If `.agent-assemble/project.md` exists and is non-empty, **do not ask anything.** Say what was found and stop.

## Step 1 — detect before asking

Before presenting any question, read the repository:

1. Look for project manifests: `package.json`, `*.csproj`, `*.sln`, `pyproject.toml`, `setup.py`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`, `Gemfile`, `pubspec.yaml`, `mix.exs`.
2. Look for an existing board: `board/`, a `.agent-assemble/board-config.md`, or any directory named `tasks/`, `issues/`, or `cards/`.
3. Look for existing documentation structure: `documentation/decisions/decided-deferred.md`.
4. Check for branch naming patterns in recent git history (if a shell is available).

Summarise what you found in a short paragraph before asking anything. The summary must say explicitly what was detected and from which file. If a detection could be wrong, say so and say how to correct it.

**What detection replaces:**
- Stack questions are replaced by manifest findings.
- Board location question is replaced if a board directory already exists.
- Branch conventions may be inferable from git log.

Detection is always shown to the user. A silently wrong detection is worse than asking.

## Step 2 — choose the path

**If the directory is empty or has no manifest:** run the new-project interview (three groups below).

**If a manifest or meaningful structure exists:** run the existing-project confirmation (see `references/existing-project.md`).

## New project — three groups

Ask these groups in order. Collect all answers before writing anything.

### Group A — The project

1. What is being built, and for whom? (one or two sentences)
2. What is the core problem it solves?
3. What is explicitly out of scope for now?
4. What does success look like at the end of the first version?

### Group B — The way of working

5. What is the stack? (language, framework, key libraries — list what the detection missed or got wrong)
6. Which principles apply, and at what severity? Choose from: TDD · Clean Architecture · Clean Code · SOLID · DRY · YAGNI · Design Patterns · Refactoring · Error Handling · Code Review · Requirements Elicitation · User Story · INVEST · Acceptance Criteria · MoSCoW · Design System · Accessibility (WCAG) · Test Pyramid · Risk-based Testing. Or say "none for now".
7. What does "done" mean here? (the minimum a task card must satisfy before it can be marked done)
8. How much of the relay should run by default? Direct only · Short · Full · PM decides per request.
9. Which review perspectives are active? Security · Performance · Accessibility · Researcher · None.

### Group C — The plumbing

10. Where do cards live? (Markdown files in this repository · Obsidian vault · SQLite · External tracker — name it). If something already exists, connect to it rather than starting fresh.
11. What is the board called? (default: the repository name)
12. Branch convention: feature branches from which base? What prefix, if any?
13. Pull request target: which branch receives PRs?
14. Where does the log go? (default: `log/LOG.md`)

### What to do if an answer cannot be given yet

Accept "not decided yet" for any question. Record it in the deferred list with a trigger condition. Do not block setup on unanswered questions.

## Step 3 — write the outputs

After collecting all answers, write these files. Do not ask for further confirmation; write and report what was written.

### Always write

- `.agent-assemble/project.md` — the canonical project configuration. See `references/project-config-template.md`.
- `documentation/decisions/decided-deferred.md` — two tables: decided and deferred. Use the template at `documentation/references/decided-deferred-template.md`.

### If board config does not already exist

- `.agent-assemble/board-config.md` — the board backend and location. See `board/references/board-adapters.md`.

### If board directories do not already exist (Markdown backend only)

- `board/todo/`, `board/in-progress/`, `board/testing/`, `board/done/` — empty directories (create a `.keep` file in each).

### If documentation directories do not already exist

- `documentation/plans/`, `documentation/decisions/`, `documentation/conventions/` — create each with a `.keep` file.

## Step 4 — confirm

Print a single summary block listing:
- Every file written and what it contains.
- Every question that was answered.
- Every question that was deferred, and the trigger that will raise it.

Say: "Setup is complete. I will not ask these questions again."

## What makes a re-run safe

If setup runs on a project that is already configured, it must:
1. Read `.agent-assemble/project.md`.
2. Print what is already configured.
3. Say "Setup is complete. I will not ask these questions again."
4. Stop. Ask nothing.

The only way to change a decision after setup is to edit the relevant file directly or ask the agent to update a specific field.

## For the full existing-project confirmation flow

See `references/existing-project.md`.

## For the project configuration file format

See `references/project-config-template.md`.
