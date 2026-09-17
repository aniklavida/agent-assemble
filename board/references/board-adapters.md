# Board Adapters Specification

This reference describes how the board contract connects to different storage backends without duplicating existing work tracking systems.

## Configuration Pointer

When Agent Assemble initializes in a repository, it consults `.agent-assemble/board-config.md`. If absent, the default Markdown directory backend is assumed.

Example configuration:

```yaml
backend: "markdown"
root: "board"
status_mapping:
  todo: "todo"
  in-progress: "in-progress"
  testing: "testing"
  done: "done"
```

## Supported Adapters

### 1. Markdown Directory Adapter (Default)

Requires file tools only; zero external dependencies.

- **Layout:** Directory per status column (`board/todo/`, `board/in-progress/`, `board/testing/`, `board/done/`).
- **Create:** Write a new `.md` file in `board/todo/` using `TASK-XXX.md`.
- **Read:** Read file content using standard file tools.
- **Move:** Execute a file move (`mv board/todo/TASK-XXX.md board/in-progress/`) and synchronize frontmatter `status:` and `updated_at:`.
- **List:** Inspect column directories (`ls board/*/`).

### 2. Obsidian Vault Adapter

Operates across standard Markdown vaults.

- **Layout:** Vault folder specified by `root:` (e.g., `vault/tasks/`).
- **Create:** Create `.md` note inside the designated vault tasks directory.
- **Move:** Either move files between status folders or update frontmatter `status:` tags queried by Dataview/Kanban.
- **Requirements:** Filesystem tools only.

### 3. SQLite Adapter

Operates against a local SQLite database for projects preferring structured relational storage.

- **Schema:**
  ```sql
  CREATE TABLE IF NOT EXISTS board_cards (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    size TEXT NOT NULL,
    status TEXT NOT NULL,
    assigned_role TEXT NOT NULL,
    body TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  );
  ```
- **Operations:** Executed via `sqlite3` CLI commands.
- **Requirement:** A working shell with `sqlite3` binary available.

### 4. External Tracker Adapter (Issue Trackers)

Connects to existing external issue trackers (GitHub Issues, Linear, Jira).

- **Principle:** Agent Assemble maps its internal relay roles to tracker issue fields, labels, or projects rather than creating separate shadow files.
- **Operations:** Invoked via host MCP tools or platform CLI binaries (e.g., `gh issue create`, `gh issue edit`).
- **Host Availability Requirement:** If an external tracker is configured but the host agent lacks the necessary CLI or MCP tools, setup fails fast and falls back to the Markdown backend.
