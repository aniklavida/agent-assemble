# Agent Assemble — specification

**Status:** planned. Nothing in this document is implemented.
**Updated:** 2026-09-18

## What it is

A skill — plain Markdown, no server and no runtime — that gives a coding agent a
role, a place in a process, and a memory.

Not a methodology collection. Other projects teach an agent *how* to work, and
teach it well. This answers what they cannot: **who is doing this, where does the
work stand, and what has already happened.**

## The seven parts

| Part | What it holds |
|---|---|
| **Employees** | Role knowledge, with inheritance |
| **Principles** | The craft — chosen per project |
| **Tools** | What this project uses, what it rejected, the constraints |
| **Documentation** | Plans and decisions — durable, edited |
| **Workflow** | How work changes hands |
| **Board** | Cards — the handoff vehicle |
| **Log** | What happened — append-only |

## 1 · Employees

Each level inherits its parent. A Next.js developer is a Frontend Developer is a
Software Engineer, and receives all three.

```
Software Engineer
  ├─ Frontend Developer   → Next.js · Angular · React · Vue
  ├─ Backend Developer    → Node.js · .NET · Python · Go · Java
  ├─ Full-stack           → composes Frontend + Backend; adds only the seam
  ├─ Mobile               → iOS · Android · Flutter · React Native
  ├─ UI/UX Designer
  └─ DevOps / Platform

Business Analyst
Project Manager
SQA
Security
Performance
Researcher
```

**Full-stack is the test of the model.** If it restates Frontend and Backend
knowledge, the inheritance is decorative. It must compose both and add only the
seam between them.

**Generic default, project override.** The model is hybrid. A role node ships with a
small generic default so it functions on day one when downloaded into an unfamiliar
repository. Once a project's own documentation exists, that documentation
**overrides** the generic default rather than merely supplementing it.

A purely generic role never reflects a team's actual practice. A purely
project-specific role assumes documentation that may not exist on a fresh install.
The generic default serves everyone immediately; the project override keeps the
fit honest once real project documentation exists.

## 2 · Principles

Written once, referenced by many roles, never restated under a role.

| Family | Contents |
|---|---|
| **Coding** | TDD · Clean Architecture · Clean Code · SOLID · DRY · YAGNI · Design Patterns · Refactoring · Error Handling · Code Review |
| **Business Analysis** | Requirements Elicitation · User Story · INVEST · Acceptance Criteria · Process Mapping · MoSCoW |
| **Design** | Design System · Accessibility (WCAG) · Progressive Disclosure · Visual Hierarchy · Responsive · Design Tokens |
| **SQA** | Test Pyramid · Risk-based Testing · Exploratory Testing · Boundary Value · Equivalence Partitioning · Defect Lifecycle |

### Three modes, three places

| Mode | Where it applies | Behaviour |
|---|---|---|
| **Advisory** | while the employee works | reminds; never blocks |
| **Prescriptive** | at a handoff gate — SQA, Security, PM | blocks; the card goes back |
| **Perspective** | at review | asks a different question |

A developer may experiment freely; the gate is where the chosen principles bite.

### Choosing

Asked once per project. Three answer shapes: pick from the list, **keep what is
already here** (detected from the codebase and shown for confirmation), or none.

A prototype might choose Clean Code and nothing else. A banking system might make
TDD, Clean Architecture, SOLID, Security and Accessibility all mandatory. Same
skill, different severity.

## 3 · Tools

A model already knows what the popular libraries are. Listing them teaches it
nothing and costs context.

What it does not know:

```
What this project already uses      detected from manifests, confirmed once
What was rejected, and why
Licence policy                      compiled in → permissive only
                                    separate process → copyleft is fine
                                    never → revenue- or headcount-gated licences
Cost ceiling
What is already paid for
```

Suggestions are **filtered through those constraints** rather than listed
generically.

The licence rule matters in practice: a container image tag can resolve to a
version whose licence changed, with nothing in the tag to say so. Checking before
adoption catches that; reviewing after merge does not.

## 4 · Documentation

The project's durable knowledge. **Two-way:** the user supplies it, and the agent
writes to it as it works.

- Plans and requirements
- Decisions, and the reasoning behind them
- Conventions — what "done" means here
- What a previous agent learned, including what it got wrong

**Edited, not appended.** When the plan changes, this changes.

**And when it changes, cards may go stale.** The skill then asks *"which cards
does this invalidate?"* Without that step, board and plan drift apart — and the
drift is silent, because nobody re-reads a card that was correct when written.

## 5 · Workflow

```
a request arrives
      ↓
BA + PM          ask the user questions first
      ↓
BA               writes the plan into documentation
      ↓
BA               creates cards on the board
      ↓
the employee     the card names the role; that role's knowledge loads
      ↓
SQA              tests
      ↓
Security         tests
      ↓
PR opens
      ↓
PM               merges, moves the card to Done
      ↓
LOG              records what happened
```

**The chain scales to the request.** The PM sizes it first and chooses the path:
direct, short, or full. A six-role relay for a typo makes the tool unusable, and
being unusable once is enough.

## 6 · Board

Cards live with the project being worked on.

**Where they live is asked, never defaulted** — Markdown, Obsidian, SQLite, or an
external tracker. If something already exists, connect to it rather than creating
a second source of truth. Ask once; remember.

The card is not bookkeeping. **It is what one role hands to the next.**

Backends differ in what the agent needs:

| Backend | Requirement |
|---|---|
| Markdown | file tools only — works everywhere |
| Obsidian | file tools; a vault is Markdown |
| SQLite | a shell |
| External tracker | an API or MCP connection — **not available in every host** |

The last row is stated at the moment of choosing, not discovered later.

## 7 · Log

What was done, when, with what evidence. Append-only, file-based, diffable.

**A by-product of the work, never a separate step.** If writing it is its own
task the agent must remember, it rots exactly as a neglected ticket board does.

The distinction from documentation:

| | Holds | Changes |
|---|---|---|
| **Log** | "the tester sent it back once — no test for large files" | accumulates |
| **Documentation** | "TDD applies to new code only" | edited when the decision changes |

Read the log to learn *what happened*. Read the documentation to learn *how
things are done here*.

## Setup — what is asked, and when

A one-time interview, not a per-task interrogation.

### New project — three groups

**The project:** what is being built and for whom; the core problem; what is in
scope and what is explicitly out; what success looks like.

**The way of working:** stack; which principles apply; what "done" means here;
how much of the chain to run; which perspectives are active.

**The plumbing:** where cards live; what the board is called; branch and pull
request conventions; where the log goes.

### Existing project — read first, then confirm

Asking blind wastes the user's time when the answers are in the repository. The
agent reads, then presents what it found and asks only what it could not
determine. Ten questions become four.

### What cannot be settled up front

Some answers do not exist yet. Setup therefore ends by writing two lists into
documentation: what is decided, and what is deliberately deferred. The second
list is knowledge, not a gap.

## The founding incident

Perspectives exist because of a failure class neither an advisory reminder nor a
prescriptive gate can reach. A product premise was built on an unverified claim
about an upstream project and survived until someone finally opened the
repository. The claim was never a gate item, so nothing failed — nobody had asked
whether anyone had actually checked it. Security, Performance and Researcher are
the perspective roles built for that question; each asks and never blocks.

## The claim, and its limit

**What it provides:** a role, a place in a process, and a memory that survives
the session.

**What it cannot provide:** any guarantee the agent read the skill, followed it,
or did what it said. No host reports this. A skill that fires and is ignored is
indistinguishable from one that never fired.

Both sentences ship together.

## Version 1.0 scope

**In:** the workflow relay end to end; board adapters for Markdown, Obsidian and
one external tool; the log; documentation structure with the decided/deferred
split; the setup interview for new and existing projects; one complete vertical
slice of employee knowledge; Business Analyst, SQA and Project Manager; the three
principle modes; the tools registry with licence policy.

**Explicitly out:** every language and framework; non-software workflows; a
hosted anything; a server of any kind; generating procedure text — the skill
places and verifies what you wrote, it does not write it.
