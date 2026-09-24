# Agent Assemble

**A company your agent can work inside.**

Agent Assemble is a skill — plain Markdown, no server and no runtime. **What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent actually read the skill, followed it, or did what it said — no host application reports this. Both statements belong together; neither is published without the other.

> **Status: experimental.** Core skills, role inheritance, board adapters, workflow relay, and verification harness are implemented and tested; v1.0 release packaging and cloud services are **Status: planned**.

---

## The Problem

An agent given a task today behaves like a capable generalist with no colleagues and no memory:

- **No role:** The same agent writes the API, the tests, and the UI, applying general knowledge to each.
- **No handoff:** It writes code and reviews its own code without an independent gate.
- **No memory:** The session ends and everything is lost — decisions, rejected options, and defect trails.
- **No organizational knowledge:** A model knows standard language syntax; it does not know what "done" means in your repository.

The model's general knowledge is already comprehensive. The knowledge that is missing is local: your team's conventions, your project's decisions, and your definition of done.

---

## What It Is Not

- **Not a methodology textbook:** Agent Assemble does not teach an agent basic engineering practices like TDD, SOLID, or debugging. Where established guides exist, it points to them.
- **Not a server or runtime:** It requires no daemon, database process, or background service. Any agent capable of reading files and executing shell commands can use it.
- **Not host-locked:** It uses canonical instructions in `AGENTS.md` and thin host pointers (`CLAUDE.md`, `GEMINI.md`) rather than vendor-specific walled gardens.

Agent Assemble answers what general prompts cannot: **who is doing this, where does the work stand, and what has already happened.**

---

## The Claim, and Its Limit

**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent actually read the skill, followed it, or did what it said — no host application reports this. A skill that fires and is ignored is indistinguishable from one that never fired.

---

## Five-Minute Start

Follow these steps to set up and complete one task item in under five minutes.

### 1. Connect Host Pointers

Ensure your host agent reads the canonical instructions in `AGENTS.md`. If using Claude Code or Gemini CLI, generate thin host pointers:

```bash
bash scripts/generate-host-pointers.sh .
```

This creates or updates `CLAUDE.md` and `GEMINI.md` pointing to `AGENTS.md`.

### 2. Run Setup

Run the setup interview described in `setup/SKILL.md`:

```bash
# In an existing repository, detection inspects manifests and structure:
mkdir -p .agent-assemble board/todo board/in-progress board/testing board/done log documentation/decisions
```

Write your initial configuration files:
- `.agent-assemble/project.md` (see `setup/references/project-config-template.md`)
- `.agent-assemble/board-config.md` (see `board/references/board-adapters.md`)
- `documentation/decisions/decided-deferred.md` (see `documentation/references/decided-deferred-template.md`)

### 3. Create a Task Item

Add a new task item into `board/todo/TASK-001.md` using the schema in `board/references/card-template.md`:

```markdown
---
id: "TASK-001"
title: "Add healthcheck endpoint"
size: "direct"
status: "todo"
assigned_role: "Employee"
created_at: "2026-09-25T00:00:00Z"
updated_at: "2026-09-25T00:00:00Z"
---

## Context & Request
Expose /health returning HTTP 200 JSON status.

## Acceptance Criteria
- [x] GET /health returns status ok
```

Log task creation in `log/LOG.md`:

```markdown
| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-09-25T00:00:00Z | TASK-001 | REQUEST_SIZED | PM | Evaluated as direct path | backlog (Employee) |
| 2026-09-25T00:01:00Z | TASK-001 | CARD_CREATED | BA | Created initial task item | todo (Employee) |
```

### 4. Move and Complete Work

Move the task item to `board/in-progress/TASK-001.md`, update `status: "in-progress"`, and log `WORK_STARTED`:

```markdown
| 2026-09-25T00:02:00Z | TASK-001 | WORK_STARTED | Employee | Began implementation | in-progress (Employee) |
```

Implement your change, verify it, update the task item to `status: "done"`, move it to `board/done/TASK-001.md`, and log completion:

```markdown
| 2026-09-25T00:05:00Z | TASK-001 | DIRECT_CLOSED | PM | Verified endpoint returns 200 OK | done |
```

### 5. Verify Invariants

Run verification scripts to ensure log and board consistency:

```bash
bash scripts/check-log-sequence.sh board
bash scripts/check-evidence.sh
```

---

## Host Support Matrix

Agent Assemble maintains a strict four-state matrix. No cell claims more than what was verified:

| Host | Pointer file | Status | Substantiation |
|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | Mechanically verified | Thin pointer exists, imports `@AGENTS.md`, and path resolution passes in CI. Real vendor application execution is not automated. |
| **Codex** | `AGENTS.md` | Mechanically verified | Reads the canonical tool-neutral source `AGENTS.md` directly. Real vendor application execution is not automated. |
| **Gemini CLI** | `GEMINI.md` | Mechanically verified | Thin pointer exists, references `AGENTS.md`, and path resolution passes in CI. Real vendor application execution is not automated. |
| **Cursor** | `AGENTS.md` | Mechanically verified | Reads the canonical tool-neutral source `AGENTS.md` directly. Real vendor application execution is not automated. |
| **Kimi** | None | Not verified | Host tool is not currently configured or targeted in this repository. |
| **Windsurf** | None | Not verified | Host tool is not currently configured or targeted in this repository. |
| **GitHub Copilot** | None | Not verified | Host tool is not currently configured or targeted in this repository. |

The four permitted states:
1. **Mechanically verified:** The pointer resolves to canonical source in CI.
2. **Config-shape verified:** Documented vendor configuration format parsed and validated.
3. **Observed working:** A human observed the skill firing in the live vendor app (requires dated substantiation).
4. **Not verified:** Untested or unconfigured hosts.

---

## Known Limitations

- **No verification of execution by host:** No host reports whether an agent loaded or followed a skill. A prompt that is ignored produces no warning.
- **Storage concurrency:** The default Markdown and Obsidian board adapters rely on filesystem directory structure. Concurrent multi-agent access without locking can cause race conditions.
- **External tracker availability:** Adapters like Linear require an active MCP server or API key and are not available in every host.
- **Context ceilings:** Roles are capped at 200 words for core files to preserve context space. Extensive tutorials belong in external documentation.

---

## Dogfooding Agent Assemble

This project uses its own skills, role structures, board adapters, and append-only log to build and maintain itself. See [docs/DOGFOOD.md](docs/DOGFOOD.md) for the full report of carrying work items through this relay, including observed friction points and failures.

---

## Documentation

- [Specification](docs/SPEC.md) — The seven parts and core invariants
- [Architecture](docs/ARCHITECTURE.md) — Context budgets, multi-host pointers, and adapters
- [Authoring Guide](docs/AUTHORING.md) — Authoring roles, principles, and board adapters
- [Dogfood Report](docs/DOGFOOD.md) — Honest records of running the tool on itself
- [Roadmap](docs/ROADMAP.md) — Milestones from skeleton to v1.0
- [Release Checklist](docs/RELEASE_CHECKLIST.md) — Verifiable criteria gating v1.0
- [Contributing](CONTRIBUTING.md) — Contribution process and word budgets
- [Security Policy](SECURITY.md) — Threat model and vulnerability reporting
- [Code of Conduct](CODE_OF_CONDUCT.md) — Standards and enforcement

---

## Licence

MIT. See [LICENSE](LICENSE).
