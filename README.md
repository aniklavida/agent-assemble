# Agent Assemble

**A company your agent can work inside.**

Agent Assemble is a skill — plain Markdown, no server and no runtime. **What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said — no host application reports this. The two sentences belong together; neither is published without the other.

> **Status: experimental.** The skill content, the board contract, the workflow relay and the verification harness exist in this repository and are exercised by the scripts in `scripts/` on every change. Release packaging and any hosted service are **planned**. What is mechanically verified, and what is not, is recorded in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## What it is

An agent given a task today is a capable generalist with no colleagues and no memory. It writes the API, the tests and the UI with the same general knowledge. It reviews its own code. The session ends and the decisions, the rejected options and the defect trail go with it.

Agent Assemble gives the work a shape that outlives the session:

| Part | What it holds |
|---|---|
| **Employees** | Role knowledge, with inheritance |
| **Principles** | The craft — chosen per project, never imposed |
| **Tools** | What this project uses, what it rejected, and the constraints |
| **Documentation** | Plans and decisions — durable, edited |
| **Workflow** | How work changes hands |
| **Board** | Cards — the handoff vehicle |
| **Log** | What happened — append-only |

The sharpest gap is not knowledge the model lacks in general. A model knows what .NET is. It does not know what "done" means in your team. **The knowledge that is missing is always local.**

## What it is not

- **Not a methodology library.** It does not teach test-driven development, systematic debugging or how to write a plan. Where a project already teaches a practice well, this one points at it rather than restating it.
- **Not a server, runtime or binary.** There is nothing to install and nothing to run in the background. An agent that can read files and run commands can use it.
- **Not host-locked.** Instructions live once in the tool-neutral [`AGENTS.md`](AGENTS.md), with thin per-host pointers where a host needs its own file. See the [host support matrix](docs/ARCHITECTURE.md#host-support-matrix).
- **Not a guarantee.** It cannot ensure it was read or followed. No host reports that.

It answers the questions a general prompt cannot: **who is doing this, where does the work stand, and what has already happened.**

## The claim, and its limit

**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said — no host application reports this. A skill that fires and is ignored is indistinguishable from one that never fired. Both sentences ship together, and this pairing is enforced by [`scripts/check-public-docs.sh`](scripts/check-public-docs.sh).

## Five-minute start

You need `git`, a shell, and an agent that can read files and run commands. There is no package to install: the skill *is* this Markdown tree.

```bash
# 1. Get the skill.
git clone https://github.com/aniklavida/agent-assemble.git
cd agent-assemble

# 2. Point the host at the canonical instructions, and check the pointers resolve.
bash scripts/check-host-pointers.sh

# 3. Make a scratch project, so the demonstration does not edit the clone.
demo="$(mktemp -d)"
mkdir -p "$demo/board/todo" "$demo/board/in-progress" "$demo/board/testing" "$demo/board/done" "$demo/log" "$demo/.agent-assemble"
printf 'backend: "markdown"\nroot: "board"\nexisting: false\n' > "$demo/.agent-assemble/board-config.md"

# 4. Create one card in the backlog.
cat > "$demo/board/todo/TASK-001.md" <<'CARD'
---
id: "TASK-001"
title: "Say hello in the scratch project"
size: "direct"
status: "todo"
assigned_role: "PM"
created_at: "2026-01-01T00:00:00Z"
updated_at: "2026-01-01T00:00:00Z"
---

## Context & Request
Create hello.md with a single greeting so a card carries a visible change.
CARD

# 5. Do the task, then carry the card: mark it done, move it, and log the closure.
printf '# Hello\n\nAgent Assemble carried this card.\n' > "$demo/hello.md"
cat > "$demo/board/done/TASK-001.md" <<'CARD'
---
id: "TASK-001"
title: "Say hello in the scratch project"
size: "direct"
status: "done"
assigned_role: "PM"
created_at: "2026-01-01T00:00:00Z"
updated_at: "2026-01-01T00:01:00Z"
---

## Context & Request
Create hello.md with a single greeting so a card carries a visible change.
CARD
rm "$demo/board/todo/TASK-001.md"
cat > "$demo/log/LOG.md" <<'LOG'
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-01-01T00:00:00Z | TASK-001 | REQUEST_SIZED | PM | Sized as Direct: one file, no verification gate | in-progress (PM) |
| 2026-01-01T00:01:00Z | TASK-001 | DIRECT_CLOSED | PM | Wrote hello.md; the file exists and renders as Markdown | done |
LOG

# 6. Check that the board and log tell the truth.
bash scripts/check-log-sequence.sh "$demo"
cat "$demo/hello.md"
```

Step 6 prints `PASS: ... (id: TASK-001, size: direct) - DIRECT_CLOSED logged by PM` and the greeting. The card, the log row and the change are now a handoff another session can read.

To use the skill in your own project, copy the skill directories (`board/`, `documentation/`, `employees/`, `log/`, `principles/`, `setup/`, `tools/`, `workflow/`) and [`AGENTS.md`](AGENTS.md) into it, then run the setup interview in [`setup/SKILL.md`](setup/SKILL.md). A larger worked relay — the card this project used on itself — is in [docs/DOGFOOD.md](docs/DOGFOOD.md).

## How work moves

A chain that scales to the request. A typo does not pass through six roles: the Project Manager sizes every request as Direct, Short or Full.

```
a request arrives
      ↓
PM sizes it, then BA + PM ask what is actually wanted
      ↓
BA writes the plan into documentation, then creates cards
      ↓
the employee the card names loads the role's knowledge
      ↓
SQA tests → Security tests → the pull request opens
      ↓
PM closes the card and the log records what happened
```

Principles run in three modes: **Advisory** (`SHOULD`, reminds while work happens), **Prescriptive** (`MUST`, blocks at a handoff gate), and **Perspective** (`MAY`, asks a different question at review and never blocks). See [principles/SKILL.md](principles/SKILL.md).

## Known limitations

- **No host reports whether a skill was followed.** A skill that fires and is ignored looks identical to one that never fired. The project records this limit wherever it states its value, and it is the reason every claim here is about what the repository *provides*, not about what an agent *did*.
- **File-based boards have no transaction.** Markdown and Obsidian boards move a card and append its log row as separate filesystem writes; an interruption between them leaves a handoff the next role must reject back.
- **External trackers are not universal.** The Linear adapter needs an MCP server or an API key and is refused at setup, by name, when the host cannot reach it.
- **The always-loaded core is capped at 200 words.** Extensive guidance belongs in a `references/` file, loaded only when needed. The cap is enforced by [`scripts/check-word-budget.sh`](scripts/check-word-budget.sh).
- **The mechanical checks are shallow.** `scripts/check-public-docs.sh` can prove that a document names an external repository, but it cannot detect a prior-art project named in prose with no URL. That gap is stated in [docs/DOGFOOD.md](docs/DOGFOOD.md).

## Dogfooding

This project uses its own board, log, roles and sabotage discipline to carry its own cards. The first full run — what worked and what did not — is published in [docs/DOGFOOD.md](docs/DOGFOOD.md). A tool for organising agent work that has never organised its own is making a claim it has not tested.

## Documentation

- [Specification](docs/SPEC.md) — the seven parts and their invariants
- [Architecture](docs/ARCHITECTURE.md) — context budget, composition, multi-host and the host support matrix
- [Authoring guide](docs/AUTHORING.md) — how to write a role, a principle and a board adapter
- [Dogfood report](docs/DOGFOOD.md) — running the tool on itself, including friction
- [Roadmap](docs/ROADMAP.md) and [release checklist](docs/RELEASE_CHECKLIST.md)
- [Contributing](CONTRIBUTING.md) · [Code of conduct](CODE_OF_CONDUCT.md) · [Security policy](SECURITY.md)

## Licence

MIT. See [LICENSE](LICENSE).
