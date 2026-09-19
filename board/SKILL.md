# Board Contract and Implementation

**Status:** experimental.

Manages task cards as physical handoff vehicles carrying context, requirements, decisions, and evidence so each role acts without re-asking.

## The Board Contract

Every board implementation provides four operations:
1. **Create Card:** Write a markdown card in `board/todo/` with metadata and acceptance criteria.
2. **Read Card:** Inspect card context, requirements, and preceding handoff payloads.
3. **Move Card:** Transition card (`todo` → `in-progress` → `testing` → `done`), synchronizing status and atomically appending an event to `log/LOG.md`.
4. **List Board:** Enumerate cards across columns to ascertain project status.

## Assignment and Blocking

- **`assigned_role` means who acts next:** Set to the recipient role before moving.
- **Waiting on external input:** When blocked on user input, set `assigned_role: "user"` and `blocked_on: "reason"` in place to prevent drift.

For card schema and assignment rules, see [references/card-template.md](references/card-template.md).

## Storage and Adapters

By default, cards live in `board/` subdirectories (`todo/`, `in-progress/`, `testing/`, `done/`). For existing trackers, Obsidian vaults, or SQLite databases, configure `.agent-assemble/board-config.md`. See [references/board-adapters.md](references/board-adapters.md).
