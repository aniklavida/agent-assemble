# Board Contract and Implementation

**Status:** experimental.

The board manages task cards as physical handoff vehicles. A task card carries all necessary context, requirements, decisions, and evidence so each role acts without re-asking.

## The Board Contract

Every board implementation must provide four operations:

1. **Create Card:**
   - Write a new markdown card file in `board/todo/` using a unique slug or identifier (e.g., `TASK-001.md`).
   - Populate frontmatter metadata and acceptance criteria.
   - Initial state is always `todo`.

2. **Read Card:**
   - Inspect a task card before taking action.
   - Extract requirements, acceptance criteria, and prior handoff sections left by preceding roles.

### `assigned_role` means who acts next, not who acted last

A card in `todo/` created by the BA does not say `assigned_role: "BA"` — the BA has finished with it. It says who is expected to pick it up.

This matters because the headline test for this project is that **a session with no memory can read the board and say what is done and what remains.** A column says where a card is; `assigned_role` says who it is waiting on. Without the second, "what remains" is answerable but "waiting on whom" is not, and those are different questions.

When a role finishes its part, it sets `assigned_role` to the next role before moving the card.

### Waiting on someone outside the relay

A card blocked on an answer from the user is not in progress and is not ready to pick up. It stays in its current column with:

```
assigned_role: "user"
blocked_on: "one sentence naming exactly what is needed"
```

Without this, a card waiting on a question sits in `todo/` or `in-progress/` looking like available work, and the next session picks it up and asks the same question again. That is the drift this project exists to prevent, reproduced inside the board itself.

3. **Move Card:**
   - Transition a task card between status columns: `todo` → `in-progress` → `testing` → `done`.
   - Update frontmatter `status:` and `updated_at:` to match the target column.
   - In filesystem backends, move the physical file to the target column directory.
   - Atomic requirement: moving a task card must coincide with appending the transition event to `log/LOG.md`.

4. **List Board:**
   - Enumerate all active and completed cards across columns to ascertain project standing.

## Card Shape

Every task card must include:

```markdown
---
id: "TASK-001"
title: "Imperative title under 72 chars"
size: "direct | short | full"
status: "todo | in-progress | testing | done"
assigned_role: "PM | BA | Employee | SQA"
created_at: "YYYY-MM-DDTHH:MM:SSZ"
updated_at: "YYYY-MM-DDTHH:MM:SSZ"
---

## Context & Request
Verbatim user request, originating issue, or problem statement.

## Acceptance Criteria
- [ ] Criterion 1 (verifiable and unambiguous)
- [ ] Criterion 2

## Handoff Trail

### Analysis Handoff (BA)
- Plan reference: path to durable plan (if Full) or inline summary (if Short)
- Context notes: scope boundaries and edge cases

### Implementation Handoff (Employee)
- Files modified: list of changed paths
- Implementation notes: technical choices and trade-offs
- Self-verification: command executed and output snippet

### Verification Handoff (SQA)
- Verification steps: tests run against criteria
- Sabotage check: description of how code or test was temporarily inverted to confirm failure, then restored
- Verdict: APPROVED or RETURNED

### Acceptance Sign-off (PM)
- Log check: confirmed unbroken log trail
- Final sign-off note
```

See [references/card-template.md](references/card-template.md) for the raw template.

## Storage and Existing Board Connection

### Default Markdown Implementation
In repositories without an existing board, cards live in:
```
board/
├── todo/
├── in-progress/
├── testing/
└── done/
```
Moving a card is a shell `mv` combined with frontmatter status synchronization.

### Connecting to Existing Boards
If a repository already possesses an issue tracker, Obsidian vault, SQLite database, or task folder, Agent Assemble connects to the existing location rather than duplicating it.

A configuration file at `.agent-assemble/board-config.md` defines the backend, root directory, and status mapping. See [references/board-adapters.md](references/board-adapters.md) for adapter specifications.
