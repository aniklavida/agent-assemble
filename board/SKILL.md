# Board Contract and Implementation

**Status:** experimental.

Manages task cards as physical handoff vehicles carrying context, requirements, decisions, and evidence so each role acts without re-asking.

## The Board Contract

Every backend implements exactly four operations:

1. **Create Card:** Write a card into the backlog column with the frontmatter schema.
2. **Move Card:** Transition a card between columns, updating `status` and `updated_at`.
3. **Read Card:** Return a card's frontmatter and body.
4. **Append Log:** Append the transition event row to the log; never edit a past row.

`Move Card` and `Append Log` form one handoff: a card that moves without its log row is invalid and is rejected back.

## Assignment and Blocking

- **`assigned_role` means who acts next:** Set it to the recipient before moving.
- **Waiting on external input:** Set `assigned_role: "user"` and `blocked_on: "reason"` in place.

For card schema, see [references/card-template.md](references/card-template.md).

## Storage and Adapters

There is no default backend: setup asks, or connects to a board that already exists. Configure `.agent-assemble/board-config.md`. Backends differ in what the agent needs — Markdown and Obsidian need file tools only; Linear needs an MCP server or API key and **is not available in every host**. See [references/board-adapters.md](references/board-adapters.md).
