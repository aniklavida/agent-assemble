# Board Adapters

This reference defines the storage-agnostic contract and the rules every backend
obeys. The operations themselves are specified once in
[`../SKILL.md`](../SKILL.md); this file gives the contract semantics, the
persistence file, and the two rules a setup must not break.

## Contract Semantics

A card is identified by `id`. Its contract state is the tuple:

```
(id, title, size, status, assigned_role, updated_at, body)
```

Every backend must make these four operations observably equivalent:

| Operation | Input | Observable result |
|---|---|---|
| **Create Card** | id, title, size, body | A readable card with `status: "todo"` |
| **Move Card** | id, target status, next `assigned_role` | `Read Card` reports the new status and role |
| **Read Card** | id | The tuple above, backend-independent |
| **Append Log** | id, event, role, summary, next state | One new row; prior rows unchanged |

Two backends are equivalent when the same operation sequence produces the same
tuple, regardless of how the bytes are stored. That is what
[`scripts/check-board-adapters.sh`](../../scripts/check-board-adapters.sh)
verifies.

**Atomic handoff.** `Move Card` and `Append Log` are called as one handoff, in
either order, but a card that moves without its log row is invalid: the receiving
role rejects it back. See [`log/references/log-schema.md`](../../log/references/log-schema.md).

## Persistence — `.agent-assemble/board-config.md`

The chosen backend is written once at setup and read on every later run. The
user is never asked twice.

```yaml
backend: "markdown"          # markdown | obsidian | linear
root: "board"                # location of the board (path or external target)
existing: true               # true = connected to a board already present
status_mapping:
  todo: "todo"
  in-progress: "in-progress"
  testing: "testing"
  done: "done"
```

If the file is absent, setup has not run. **Absence is not permission to default
to Markdown** — it means ask.

## Rule 1 — Connect, never create a second source of truth

Before writing any board, inspect in this order:

1. `.agent-assemble/board-config.md` — a backend was already chosen. Connect.
2. A card tree (`board/{todo,in-progress,testing,done}/` with cards). Connect as
   `backend: markdown`.
3. An Obsidian vault (a directory containing `.obsidian/`). Connect as
   `backend: obsidian`.
4. An existing external board (a Linear team/project already in use). Connect as
   `backend: linear`.

If any check matches, **connect to it and write `existing: true`**. Creating a
second board for the same work is the failure this project exists to prevent.
[`scripts/check-board-connect-existing.sh`](../../scripts/check-board-connect-existing.sh)
proves the connect path and that no duplicate appears.

## Rule 2 — State reachability at the moment of choosing

Backends differ in what the host must provide:

| Backend | What the agent needs |
|---|---|
| Markdown | file tools only — works in every host |
| Obsidian | file tools; a vault is Markdown |
| Linear | an MCP server or an API key — **not available in every host** |

The Linear row may be unreachable. Say so **when the backend is chosen**, never
later: if neither a Linear MCP server nor a configured API key is present, setup
refuses the choice, names the missing capability, and offers Markdown or Obsidian
instead. The agent never reads, prints, or stores the key; it checks only that
the capability exists. [`scripts/check-board-reachability.sh`](../../scripts/check-board-reachability.sh)
proves the refusal and its reason.

## Backend pages

Each backend is a page of instructions, not a project:

- [adapters/markdown.md](adapters/markdown.md) — file tools only.
- [adapters/obsidian.md](adapters/obsidian.md) — a vault is Markdown, with conventions.
- [adapters/linear.md](adapters/linear.md) — MCP or API key; not in every host.

SQLite was described in earlier drafts but is **planned, not implemented**; it is
not offered by setup.
