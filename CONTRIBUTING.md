# Contributing

Thank you for considering a contribution.

**Current state:** this repository is a specification. There is no skill content
to extend yet. The most useful contribution today is telling us where the design
is wrong.

## The rule that governs everything here

**A node must justify itself against one question: would a good model have done
this anyway?**

A model already knows what Clean Code is, what SOLID stands for, and how
`async` works in your favourite language. Writing that down costs an agent
context it needs for the actual task, and gives nothing back. An agent starved
of context performs worse than one with no skill at all.

What a model does not know is local: what "done" means in this team, which
practices are mandatory here, what a business analyst is expected to hand a
tester. **That is what belongs in a node.**

A pull request that summarises public documentation will be declined, however
well written.

## The word budget

Every node has a small always-loaded core and unlimited references loaded on
demand.

**The ceiling is 200 words** for the always-loaded core of a node — its `SKILL.md`
file only, not its `references/` files, which remain unlimited.

This is enforced rather than encouraged, for a reason: without enforcement every
contributor adds a little more, and within a year the composed context exceeds
what any agent can hold. If your addition does not fit the core, it is a
reference.

The limit is enforced by `scripts/check-word-budget.sh`, which runs in CI on every
push and pull request.

Current always-loaded cores, measured with `wc -w`:

| Node | Words |
| --- | --- |
| `setup/SKILL.md` | 178 |
| `board/SKILL.md` | 166 |
| `workflow/SKILL.md` | 187 |
| `log/SKILL.md` | 187 |
| `documentation/SKILL.md` | 161 |

A reference file has no ceiling and is not counted here, because it is loaded
only when the node needs it.

## Instructions are reviewed as code

An agent reads these files and acts on them with a filesystem and a shell. A
pull request that adds an instruction is reviewed the way a build script is,
not the way prose is.

Specifically, an instruction must never:

- tell an agent to fetch and execute a remote document;
- ask an agent to handle a credential, token or password;
- assume a capability the agent may not have, without saying so.

## Before you open a pull request

- Say which of the seven parts your change belongs to, and why it belongs there
  rather than another.
- If it adds a node, state what a model would not already know.
- If it adds a host, say which of the four verification states it is in and what
  you actually ran.

## Claims

Every statement about what this project does is one of: **implemented and
tested**, **experimental**, **planned**, or **unsupported**. Nothing is
described as working until it has been run. A green test that proves nothing is
worse than no test, because it invites trust.
