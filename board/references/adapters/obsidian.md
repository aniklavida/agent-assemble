# Obsidian Backend

**Requires:** file tools only. A vault is a directory of Markdown files, so this
backend shares the Markdown backend's mechanics; only the conventions below
differ.

## What makes a vault a vault

- A directory containing a `.obsidian/` folder is a vault.
- Cards live under a tasks folder inside it, e.g. `vault/Tasks/`.
- Obsidian queries frontmatter, so `status:` is the field Dataview and Kanban
  read. Moving the file is still the operation; the frontmatter keeps queries
  correct.

## Operations

Create, Move, Read and Append Log are exactly as specified in
[markdown.md](markdown.md), with the vault paths and the two conventions below.

### Create Card

Write `vault/Tasks/todo/TASK-NNN.md`. Frontmatter is unchanged from the Markdown
backend, and the card carries `status: "todo"`. Cards created by an agent are
indistinguishable from ones created by hand in the vault.

### Move Card

Move the file between `vault/Tasks/<status>/` directories **and** update
`status:` in frontmatter in the same step. If a status folder does not exist,
create it. Never leave the frontmatter and the folder disagreeing: Obsidian will
show the card in the wrong column.

### Read Card / Append Log

Read the note directly. Append the log row to the vault's log (default
`log/LOG.md` at the vault root, or `root:` in
`.agent-assemble/board-config.md`).

## Detecting an existing vault

A directory containing `.obsidian/` with a tasks folder already in use is an
existing board. Connect to it with `backend: obsidian` and `existing: true`. Do
not create a parallel `board/` tree beside the vault — that is the second source
of truth this contract forbids.

## Host differences

None beyond the Markdown backend. Works in every host that has file tools.
