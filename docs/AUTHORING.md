# Authoring Guide: Roles, Principles, and Board Adapters

Agent Assemble organizes agent collaboration through Markdown skills, explicit handoffs, and durable records. This guide explains how to author the three core building blocks: **Roles**, **Principles**, and **Board Adapters**.

Every component is governed by automated verification scripts in `scripts/`. Instructions are reviewed as code: what is written directly affects what an agent executes with filesystem and shell tools.

---

## 1 · Authoring a Role

A role provides a bounded identity, operational steps, and explicit boundaries. Roles are located under `employees/` and support inheritance through directory nesting (for example, `employees/software-engineer/backend-developer/nodejs/`).

### The Five Required Skeleton Sections

Every role's always-loaded core (`SKILL.md`) must contain exactly these five sections, enforced by `scripts/check-role-skeleton.sh`:

1. `### Purpose`
   One or two sentences explaining what the role does and what it explicitly does not do.
2. `### Preconditions`
   Measurable prerequisites that must hold before the role begins work (for example: a task item in the expected status column, an unbroken log entry in `log/LOG.md`, or a documented plan).
3. `### Steps`
   Ordered actions using RFC 2119 keywords matching the role's mode:
   - **MUST**: Prescriptive actions enforced at handoff gates. Skipping blocks the task.
   - **SHOULD**: Advisory actions guiding execution. Reminds without blocking.
   - **MAY**: Perspective actions used during review to ask questions without rendering verdicts.
4. `### Completion signal`
   Concrete, verifiable conditions indicating the role has finished its work (for example: tests passing, diff recorded, and handoff section populated).
5. `### Failure handling`
   Explicit instructions for handling blockers:
   - Return the task item to the prior column with defect notes.
   - Set `assigned_role: "user"` with `blocked_on: "<reason>"`.
   - Escalate to PM with the blocker identified.

### Context Budget Constraints

An agent overloaded with context performs worse than an agent with no skill. Roles enforce strict word budgets:
- **Core ceiling:** The always-loaded core `SKILL.md` must stay under 200 words, verified by `scripts/check-word-budget.sh`.
- **Composed ceiling:** A multi-level composed role (parent + child + grandchild) must stay within its composed ceiling (600 words for a three-level composition), verified by `scripts/check-composed-budget.sh`.
- **Unlimited references:** Detailed procedures, frameworks, and extended examples belong in `references/` files linked from the core, loaded only on demand.

### Inheritance and Non-Duplication Rules

- **Load-bearing inheritance:** A specialized role inherits its parent's instructions. A child must never restate its parent's text. Removing a parent level must provably change the child role's behaviour, verified by `scripts/check-inheritance-proof.sh`.
- **No duplicate sentences:** No sentence may appear verbatim across role cores, verified by `scripts/check-duplicate-sentences.sh`.
- **Project overrides:** A project can override any built-in role by placing an override file at `.agent-assemble/roles/<Role>/SKILL.md`. The project-specific override takes precedence over generic defaults, verified by `scripts/check-workflow-override.sh`.

---

## 2 · Authoring a Principle

Principles codify team craft and standards. Principles do not teach general knowledge (a good model already understands SOLID and clean code); they declare which practices apply to a project and at what severity.

Principles belong to families (Coding, Business Analysis, Design, SQA) in `principles/references/catalogue.md` and are selected in `documentation/principles.md`.

### The Three Principle Modes

Every principle operates in exactly one mode, matching RFC 2119 keywords:

| Mode | Keyword | Stage | Behaviour |
|---|---|---|---|
| **Advisory** | `SHOULD` | In-progress execution | Reminds and guides during implementation; never blocks handoff or returns a task item. |
| **Prescriptive** | `MUST` | Handoff gates (SQA, PM) | Enforces hard constraints; blocks transition and returns the task item if unsatisfied. |
| **Perspective** | `MAY` | Review | Asks an probing question (for example: "MAY ask: was this verified against real storage?"); never renders a pass/fail verdict or blocks. |

The keyword in the instruction is the mode. `scripts/check-principles.sh` verifies that prescriptive rules block defective items, advisory rules do not block, and perspective roles ask questions without issuing verdicts.

---

## 3 · Authoring a Board Adapter

A board adapter translates Agent Assemble's storage-agnostic board contract into concrete instructions for the agent's tools. Backends live in `board/references/adapters/<backend>.md`.

### The Four Contract Operations

Every backend must implement four operations producing equivalent observable state:

1. **Create Card:** Generates a task item with frontmatter (`id`, `title`, `size`, `status: "todo"`, `assigned_role`, `created_at`, `updated_at`) and body.
2. **Move Card:** Transitions a task item to a new status directory/state and updates `assigned_role` and `updated_at`.
3. **Read Card:** Reads and parses the tuple `(id, title, size, status, assigned_role, updated_at, body)`.
4. **Append Log:** Atomically records the handoff event row in `log/LOG.md` without modifying past entries.

### Board Invariants

- **Connect, never duplicate (Rule 1):** Before creating a new board, the adapter must check `.agent-assemble/board-config.md` or existing board paths. If an existing board is detected, connect to it with `existing: true` rather than creating a second source of truth. Verified by `scripts/check-board-connect-existing.sh`.
- **Reachability at selection (Rule 2):** If a backend requires external host capabilities (such as an MCP server or API token for Linear), this requirement must be declared and checked during setup. If unreachable on the host, the backend must be refused with the missing capability named. Verified by `scripts/check-board-reachability.sh`.
- **Backend equivalence:** The Markdown, Obsidian, and external tracker backends must produce equivalent contract state under the same operation sequences, verified by `scripts/check-board-adapters.sh`.
