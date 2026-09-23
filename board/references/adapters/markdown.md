# Markdown Backend

**Requires:** file tools only. Works in every host, with no external dependency.

A card is a standalone `.md` file. The column is the directory it lives in.
This is the reference implementation of the board contract; the other file-based
backend follows it.

## Layout

```
board/
├── todo/
├── in-progress/
├── testing/
└── done/
```

One directory per status. The `root:` in `.agent-assemble/board-config.md`
defaults to `board`.

## Operations

### Create Card

1. Choose the next free id (`TASK-NNN`, scanning every column directory).
2. Write `board/todo/TASK-NNN.md` from
   [`card-template.md`](../card-template.md), with `status: "todo"`,
   `assigned_role` set to the first recipient, and `created_at` /
   `updated_at` set to the same UTC instant.

### Move Card

1. Read the card, confirm the source folder matches its `status`.
2. Set `status:` to the target column and `assigned_role:` to the next role,
   and bump `updated_at`.
3. Write the file into the target directory and remove the old one. A copy that
   leaves both files behind is a duplicate, not a move.

### Read Card

Read the file with standard file tools. The frontmatter is the contract state;
the body is the handoff payload.

### Append Log

Append one row to `log/LOG.md` using the schema in
[`log/references/log-schema.md`](../../log/references/log-schema.md). Never edit
or reorder a past row.

## Detecting an existing board

A `board/` tree containing any card file is an existing board. Connect to it and
record `existing: true`; do not scaffold a fresh one.

## Host differences

None. This backend is the baseline every host can run.
