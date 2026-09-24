# Contributing

Thank you for considering a contribution.

**Current state:** Core skill files, role inheritance, board adapters, workflow relay, and the verification harness are implemented and experimental. Contributions extending role definitions, authoring new board adapters, or improving verification coverage are welcome.

---

## The Rule That Governs Everything Here

**A node must justify itself against one question: would a good model have done this anyway?**

A model already knows what Clean Code is, what SOLID stands for, and how `async` works in your favourite language. Writing that down costs an agent context it needs for the actual task, and gives nothing back. An agent starved of context performs worse than one with no skill at all.

What a model does not know is local: what "done" means in this team, which practices are mandatory here, what a business analyst is expected to hand a tester. **That is what belongs in a node.**

A pull request that summarises public documentation will be declined, however well written.

---

## The Word Budget

Every node has a small always-loaded core and unlimited references loaded on demand.

**The ceiling is 200 words** for the always-loaded core of a node — its `SKILL.md` file only, not its `references/` files, which remain unlimited.

This is enforced rather than encouraged, for a reason: without enforcement every contributor adds a little more, and within a year the composed context exceeds what any agent can hold. If your addition does not fit the core, it is a reference.

The limit is enforced by `scripts/check-word-budget.sh`, which runs in CI on every push and pull request.

Current always-loaded cores, measured with `wc -w`:

| Node | Words | Ceiling |
|---|---|---|
| `setup/SKILL.md` | 178 | 200 |
| `board/SKILL.md` | 197 | 200 |
| `workflow/SKILL.md` | 180 | 200 |
| `log/SKILL.md` | 187 | 200 |
| `documentation/SKILL.md` | 191 | 200 |
| `principles/SKILL.md` | 165 | 200 |
| `tools/SKILL.md` | 177 | 200 |

Role cores under `employees/` also adhere to the 200-word ceiling per `SKILL.md` and a 600-word ceiling for a three-level composed role. A reference file in `references/` has no ceiling and is not counted here, because it is loaded only when the node needs it.

---

## Authoring Guides

Before adding or modifying components, consult [docs/AUTHORING.md](docs/AUTHORING.md):
- **Roles:** The five required sections (`Purpose`, `Preconditions`, `Steps`, `Completion signal`, `Failure handling`), inheritance rules, and duplicate sentence bans.
- **Principles:** The three modes (`Advisory`, `Prescriptive`, `Perspective`) mapped to RFC 2119 keywords (`SHOULD`, `MUST`, `MAY`).
- **Board Adapters:** The four contract operations (`Create Card`, `Move Card`, `Read Card`, `Append Log`), reachability declarations, and existing-board detection.

---

## Instructions Are Reviewed as Code

An agent reads these files and acts on them with a filesystem and a shell. A pull request that adds an instruction is reviewed the way a build script is, not the way prose is.

Specifically, an instruction must never:
- Tell an agent to fetch and execute a remote document;
- Ask an agent to handle a credential, token, or password;
- Assume a capability the agent may not have, without saying so.

---

## Pull Request and Branch Discipline

1. **Branching:** Create your feature branch off `develop`. Do not branch off `main`.
2. **Commit messages:** Use plain imperative English sentences in sentence case naming the outcome (e.g. `Add authoring guide for roles and adapters`). Do not use Conventional Commit prefixes (`feat:`, `fix:`, `chore:`).
3. **Verification:** Run all repository test scripts before opening a PR:
   ```bash
   bash scripts/check-word-budget.sh
   bash scripts/check-evidence.sh
   bash scripts/check-log-sequence.sh board
   bash scripts/check-host-pointers.sh
   ```
4. **Sabotage evidence:** Non-direct task items must carry per-criterion sabotage evidence (`test`, `mutation`, `sabotage_outcome`) per `board/references/sabotage-evidence-guide.md`.
5. **Target:** Open your pull request against `develop`. Never push directly to `main` or `develop`.

---

## Claims

Every statement about what this project does is one of: **implemented and tested**, **experimental**, **planned**, or **unsupported**. Nothing is described as working until it has been run. A green test that proves nothing is worse than no test, because it invites trust.
