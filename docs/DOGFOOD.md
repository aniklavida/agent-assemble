# Dogfood Run Report: Agent Assemble on Agent Assemble

A tool for organizing agent collaboration that has never been used to organize its own work is making an untested claim about itself. This document reports the end-to-end execution of Agent Assemble on its own repository, tracking work item 13 (**Public documentation and the dogfood run**) as `TASK-013`.

Both what worked and what failed are published here honestly.

---

## 1 · The Relay Execution

The dogfood run exercised the complete five-stage relay lifecycle specified in `workflow/SKILL.md` using the Markdown board adapter (`board/`) and append-only event log (`log/LOG.md`):

### Stage 1: Setup and Sizing (PM)
- **Setup interview:** Ran the existing-project setup flow from `setup/SKILL.md`. Confirmed stack (Markdown, POSIX Shell), detected absence of pre-existing board, established `board/` with Markdown backend, and populated `.agent-assemble/project.md`, `.agent-assemble/board-config.md`, and `documentation/decisions/decided-deferred.md`.
- **Sizing:** The PM sized work item 13 as `size: "full"` due to cross-cutting documentation, authoring guides, multi-host matrix validation, and verification scripts.
- **Log event:** `REQUEST_SIZED` recorded in `log/LOG.md`.

### Stage 2: Scope and Criteria Elicitation (BA)
- **Task item creation:** The BA authored `board/todo/TASK-013.md` specifying eight testable acceptance criteria spanning README documentation, authoring guides, host matrix consistency, gap remediation, clean-checkout start verification, and sabotage evidence.
- **Handoff:** Set `assigned_role: "Employee"` and appended `CARD_CREATED` to `log/LOG.md`.

### Stage 3: Implementation and Self-Verification (Employee)
- **Task item transition:** Moved task item to `board/in-progress/TASK-013.md` and appended `WORK_STARTED` to `log/LOG.md`.
- **Artifacts produced:**
  - `README.md`: Overhauled with what the tool is and is not, honest status, five-minute start, four-state host support matrix, and known limitations.
  - `docs/AUTHORING.md`: Complete authoring guide for Roles, Principles, and Board Adapters.
  - `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`: Filled concrete gaps in guidelines, enforcement contacts, and security response SLAs.
  - `scripts/check-public-docs.sh`: Dedicated verification script enforcing the claim/limit pairing, authoring guide presence, and clean checkout validation.
- **Five-minute start verification:** Executed the exact quickstart instructions on an isolated, clean repository checkout in a temporary directory, confirming both `check-log-sequence.sh` and `check-evidence.sh` pass.
- **Handoff:** Moved task item to `board/testing/TASK-013.md`, set `assigned_role: "SQA"`, and appended `WORK_COMPLETED` to `log/LOG.md`.

### Stage 4: Independent Verification and Sabotage Testing (SQA)
- **Verification check:** Executed repository test suite and `scripts/check-public-docs.sh`.
- **Sabotage testing:** Applied intentional defects to test each acceptance criterion:
  - Removed the limit sentence from `README.md` — confirmed `check-public-docs.sh` failed.
  - Injected an invalid state into the host support matrix — confirmed `check-host-pointers.sh` failed.
  - Removed required sections from `docs/AUTHORING.md` — confirmed `check-public-docs.sh` failed.
  - Tested word budget overrun — confirmed `check-word-budget.sh` failed.
- **Evidence recording:** Populated the `## Sabotage Evidence` block in the task item with per-criterion test commands, mutations, and outcomes.
- **Handoff:** Appended `VERIFICATION_PASSED` to `log/LOG.md` and handed off to PM.

### Stage 5: Acceptance and Closure (PM)
- **Log audit:** Confirmed the unbroken sequence `CARD_CREATED` → `WORK_STARTED` → `WORK_COMPLETED` → `VERIFICATION_PASSED` in `log/LOG.md` with correct role ownership.
- **Closure:** Moved task item to `board/done/TASK-013.md`, set `status: "done"`, and appended `CARD_CLOSED` to `log/LOG.md`.

---

## 2 · What Went Right

- **Handoff context preservation:** Subsequent roles had full access to the originating requirements, decisions, and evidence without requiring conversational re-prompting.
- **Mechanical auditability:** The append-only log format and YAML frontmatter allowed shell scripts (`scripts/check-log-sequence.sh`, `scripts/check-evidence.sh`) to verify process compliance automatically in CI.
- **Sabotage discipline caught real gaps:** Requiring a failing mutation for every acceptance criterion forced the authoring of `scripts/check-public-docs.sh`, turning subjective documentation requirements into falsifiable, automated tests.

---

## 3 · What Went Wrong (Observed Friction Points)

The following friction points and failure modes were observed during the dogfood run:

### 1. Atomic handoff overhead in file-based Markdown
Transitioning a task item between columns requires three distinct actions: updating frontmatter fields (`status`, `assigned_role`, `updated_at`), physically moving the file (`mv board/todo/... board/in-progress/...`), and appending a row to `log/LOG.md`. Because Agent Assemble is purely Markdown without a local server daemon, there is no transactional boundary. If an agent experiences a timeout or crashes between moving the file and updating the log, the handoff becomes invalid and the receiving role must reject it.

### 2. Relative link brittleness across board moves
As a task item moves between directories (`board/todo/` → `board/in-progress/` → `board/testing/` → `board/done/`), relative markdown links pointing outside the board tree (such as links to `documentation/plans/` or `scripts/`) can break if authors use varying directory depths. All references should standardize on repository-root relative paths.

### 3. Falsifying documentation criteria requires bespoke tooling
For application code, writing a sabotage mutation (inverting an operator, deleting a null check) is straightforward. For documentation tasks, proving that an acceptance criterion fails requires writing explicit structural linting scripts (such as `scripts/check-public-docs.sh`) to detect missing sections, unlinked guides, or uncoupled value-proposition sentences. Without structural validation scripts, documentation sabotage risks devolving into narrative self-reporting.

### 4. The 200-word budget ceiling requires intense editing
Staying strictly under the 200-word ceiling for always-loaded `SKILL.md` files while retaining necessary RFC 2119 keywords and edge-case handling required multiple refactoring iterations. While this successfully protects the agent's context window, it demands significant compression discipline from authors.

### 5. Host opacity remains total
During the run, there was no feedback or telemetry from the host agent indicating whether instructions in `AGENTS.md` were ingested or if the agent operated purely from internal heuristics. This real-world observation confirms the fundamental limit stated across our documentation: **No host application reports whether a skill was read or followed.**
