# New Project Interview Flow

This reference contains the full interview structure, output generation steps, and re-run safety rules for new or unconfigured projects.

## Three Groups of Questions

Ask these groups in order. Collect all answers before writing anything.

### Group A — The project

1. What is being built, and for whom? (one or two sentences)
2. What is the core problem it solves?
3. What is explicitly out of scope for now?
4. What does success look like at the end of the first version?

### Group B — The way of working

5. What is the stack? (language, framework, key libraries — list what detection missed or got wrong)
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

### Handling Unanswered Questions

Accept "not decided yet" for any question. Record it in the deferred list with a concrete revisit trigger. Do not block setup on unanswered questions.

## Writing Outputs

After collecting answers, write these files without asking for additional confirmation:

### Always write

- `.agent-assemble/project.md` — canonical project configuration. See [project-config-template.md](project-config-template.md).
- `documentation/decisions/decided-deferred.md` — decided constraints and deferred trigger lists. Use template at `documentation/references/decided-deferred-template.md`.

### If board config does not already exist

- `.agent-assemble/board-config.md` — backend and location. See `board/references/board-adapters.md`.

### If board directories do not already exist (Markdown backend)

- `board/todo/`, `board/in-progress/`, `board/testing/`, `board/done/` — empty directories with a `.keep` file in each.

### If documentation directories do not already exist

- `documentation/plans/`, `documentation/decisions/`, `documentation/conventions/` — created with a `.keep` file in each.

## Confirmation Summary

Print a single summary block listing:
- Every file written and what it contains.
- Every question that was answered.
- Every question that was deferred, and the trigger that will raise it.

Conclude with: *"Setup is complete. I will not ask these questions again."*

## Re-Run Safety

If setup runs on a project that is already configured:
1. Read `.agent-assemble/project.md`.
2. Print what is already configured.
3. State: *"Setup is complete. I will not ask these questions again."*
4. Stop. Ask nothing.

The only way to modify a decision after setup is to edit the relevant file directly or instruct an update to a specific field.
