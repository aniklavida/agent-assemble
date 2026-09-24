# Architecture

**Status:** planned. Nothing here is implemented.

## Form

Markdown files. No server, no runtime, no binary. Any agent that can read files
and run commands can use this, which is the only portability guarantee that
costs nothing to keep.

Adding a server would be a design change, not an implementation detail. It would
trade "works in every host" for "works where it is installed", and the whole
point is the former.

## The hard problem: context budget

This decides whether the project works.

A four-level role — Software Engineer → Frontend → React → Next.js — composed
with chosen principles and a workflow phase can run to many thousands of words
before any work begins. **An agent starved of context performs worse than one
with no skill at all**, so a skill that consumes the budget has made things
worse while appearing to help.

### Every node is split

```
employees/backend/dotnet/
├── SKILL.md          small, always loaded when this role is active
└── references/
    ├── ef-core.md                loaded only when the task touches it
    ├── async.md
    └── testing.md
```

`SKILL.md` carries only what changes behaviour every time. Everything else is a
reference the agent pulls when the task needs it.

### The budget is enforced, not encouraged

A word ceiling per always-loaded core, checked by a command, failing when
exceeded.

Without enforcement, every contributor adds a little more and the tree collapses
under its own weight within a year. A guideline in a contributing file does not
survive contact with a hundred well-meaning pull requests.

## Composition

A role receives its own core plus every ancestor's core. **No level restates
another.** If a child repeats its parent, the inheritance is decorative and the
structure is wrong — that is a design failure, not a style problem.

The test: remove a parent level and the child's behaviour must change. If it
does not, the parent was never load-bearing.

## Role selection

Three mechanisms, in order:

1. **Declared** — the user says so, or a project configuration file does.
2. **Detected** — a project manifest identifies the stack. Cheap and usually
   right.
3. **Derived** — "write acceptance criteria for this" implies an analyst
   regardless of repository.

**Detection is visible and overridable.** An agent silently deciding you are a
Python developer, and being wrong, is worse than asking.

## Multi-host

One source; thin per-host pointers where a host requires its own file.

**This is adopted prior art, not an innovation of this project.** Existing
skills projects already ship one source with thin per-host manifests, and the
pattern is well proven. It is used here because it works, and it is never
presented as a differentiator.

### The limit, stated rather than discovered

**No host reports whether a skill was loaded or followed.** Verifying a real pass
inside a vendor's application requires that application, which cannot be
automated.

The host matrix therefore distinguishes four states:

| State | Means |
|---|---|
| **Mechanically verified** | The pointer resolves to the source. Provable in CI. |
| **Config-shape verified** | The host's documented configuration was parsed and launched as specified. Proves the shape; not that the host reads it. |
| **Observed working** | A human ran the real application and the skill fired. Cannot be automated. |
| **Not verified** | Everything else. Says so. |

No cell claims more than was done.

### Host support matrix

| Host | Pointer file | Status | Substantiation |
|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | Mechanically verified | Thin pointer exists, imports `@AGENTS.md`, and path resolution passes in CI. Real vendor application execution is not automated. |
| **Codex** | `AGENTS.md` | Mechanically verified | Reads the canonical tool-neutral source `AGENTS.md` directly. Real vendor application execution is not automated. |
| **Gemini CLI** | `GEMINI.md` | Mechanically verified | Thin pointer exists, references `AGENTS.md`, and path resolution passes in CI. Real vendor application execution is not automated. |
| **Cursor** | `AGENTS.md` | Mechanically verified | Reads the canonical tool-neutral source `AGENTS.md` directly. Real vendor application execution is not automated. |
| **Kimi** | None | Not verified | Host tool is not currently configured or targeted in this repository. |
| **Windsurf** | None | Not verified | Host tool is not currently configured or targeted in this repository. |
| **GitHub Copilot** | None | Not verified | Host tool is not currently configured or targeted in this repository. |


## Board adapters

One thin contract — create a card, move a card, read a card, append to the log —
with instructions per backend. A new backend should be a page of instructions,
not a project.

Because this is a skill rather than a server, an adapter is *instructions for
what the agent does with its own tools*, not code. That is why backends differ in
what they require, and why the difference is stated at the moment of choosing.

## Directory shape

```
employees/        role knowledge, nested by inheritance
principles/       the craft, by family
tools/            registry, decisions, constraints
workflow/         the relay, and sizing
board/            the contract and its adapters
log/              format and rules
docs/             this specification and its siblings
```
