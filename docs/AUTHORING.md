# Authoring Guide

How to add the three things a contributor to Agent Assemble actually adds: a
role, a principle, and a board adapter. Each has a place, a shape and a check
that runs in CI. This guide names the real files and the real commands; it does
not invent new concepts.

## The rule that governs all three

Before writing anything, answer one question: **would a good model have done
this anyway?**

A model already knows what SOLID means, how `async` works, and what a pull
request is. Restating that spends the context the agent needs for the task and
gives nothing back. An agent starved of context performs worse than one with no
skill at all. What a model does **not** know is local: what "done" means here,
which practices are mandatory, what one role must hand the next.

If the answer is "a good model would have done this anyway", the node does not
belong here.

## Authoring a role

A role is a directory under `employees/`, nested to express inheritance. The
authoritative shape is [`workflow/references/role-skeleton.md`](../workflow/references/role-skeleton.md).

### Where it lives

```
employees/
└── software-engineer/          SKILL.md  — the always-loaded core
    └── backend-developer/      SKILL.md  — inherits the parent, restates nothing
        └── nodejs/             SKILL.md
                                references/   — loaded on demand, no ceiling
```

### The five required sections

Every role `SKILL.md` opens with a `**Status:**` line using one of the four
permitted states, then carries exactly these sections:

1. **Purpose** — what the role is for, and what it is *not* for.
2. **Preconditions** — what MUST be true before it begins.
3. **Steps** — ordered actions, written with RFC 2119 keywords. `MUST` is
   prescriptive (blocks at a gate), `SHOULD` is advisory (reminds), `MAY` is a
   perspective (asks).
4. **Completion signal** — measurable conditions that do not require the next
   role to confirm.
5. **Failure handling** — return the card with defect notes, or block with
   `assigned_role: "user"` and `blocked_on`.

### Two rules that decide whether the structure is real

- **No level restates another.** If a child repeats its parent, the inheritance
  is decorative. Remove the parent and the child's behaviour must change.
- **The core stays under 200 words.** Detail belongs in `references/`, linked
  from the core.

### Checks

```bash
bash scripts/check-role-skeleton.sh fixtures/role-skeleton/good   # shape
bash scripts/check-word-budget.sh                                 # 200-word core
bash scripts/check-duplicate-sentences.sh employees               # no sentence at two levels
bash scripts/check-composed-budget.sh \
  employees/software-engineer/backend-developer/nodejs 600        # a three-level composition
bash scripts/check-inheritance-proof.sh                           # a parent is load-bearing
```

## Authoring a principle

A principle is written once and referenced by many roles, never restated under a
role. Add it to the family list in
[`principles/references/catalogue.md`](../principles/references/catalogue.md).

### One mode per principle, expressed by the keyword

The mode is not a separate label; it is the RFC 2119 word the agent reads. The
definitions and worked examples are in
[`principles/references/modes.md`](../principles/references/modes.md).

| Mode | Keyword | Where it applies | Behaviour |
|---|---|---|---|
| **Advisory** | `SHOULD` | while the employee works | reminds; never blocks |
| **Prescriptive** | `MUST` | at a handoff gate — SQA, Security, PM | blocks; the card goes back |
| **Perspective** | `MAY` | at review | asks a question; produces no verdict |

### Selection is per project, and recorded once

A principle is selected at setup with one of three answers — pick from the
catalogue, keep what the codebase already shows (detected and confirmed), or
none — and recorded in `documentation/principles.md`. A gate only enforces what
that project selected: the same card that fails a `MUST` under one project
passes under another that did not choose it.

### Checks

```bash
bash scripts/check-principles.sh fixtures/principles        # good fixtures pass
bash scripts/check-principles.sh fixtures/principles/bad    # violations are caught
```

## Authoring a board adapter

A board adapter is a page of instructions, not code. The contract is four
operations, specified once in [`board/SKILL.md`](../board/SKILL.md) and given
semantics in [`board/references/board-adapters.md`](../board/references/board-adapters.md):

- **Create Card** — write a card into the backlog column with the frontmatter
  schema in [`board/references/card-template.md`](../board/references/card-template.md).
- **Move Card** — transition a card between columns, updating `status` and
  `updated_at`, and set `assigned_role` to who acts next.
- **Read Card** — return the contract state `(id, title, size, status,
  assigned_role, updated_at, body)`.
- **Append Log** — append one row to `log/LOG.md`; never edit or reorder a past
  row. `Move Card` and `Append Log` are one handoff: a card that moves without
  its log row is rejected back.

Two rules a new backend must not break:

1. **Connect, never create a second source of truth.** Inspect
   `.agent-assemble/board-config.md`, then an existing card tree, then an
   Obsidian vault, then an external board. If any exists, connect to it and
   record `existing: true`.
2. **State reachability when the backend is chosen.** Say what the host must
   provide — Markdown and Obsidian need file tools only; an external tracker
   needs an MCP server or an API key and is **not available in every host**. If
   the capability is absent, refuse the choice, name what is missing, and offer
   a file-based backend instead.

### Where it lives

Add a page under `board/references/adapters/` and link it from
`board/references/board-adapters.md`. The backend is recorded once in
`.agent-assemble/board-config.md` and never asked again.

### Checks

```bash
bash scripts/check-board-adapters.sh              # backends produce equivalent state
bash scripts/check-board-connect-existing.sh      # an existing board is connected to
bash scripts/check-board-reachability.sh --docs   # the limit is stated where chosen
```

## Before you open a pull request

- Say which of the seven parts the change belongs to, and why there rather than
  another.
- If it adds a node, state what a good model would *not* already know.
- If it adds a host, say which of the four verification states it is in and what
  you actually ran.
- Run the check for the thing you changed. `CONTRIBUTING.md` lists the claim
  states and the review rules.
