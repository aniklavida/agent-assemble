# Durable Documentation

**Status:** experimental.

Governs durable, edited repository knowledge. Unlike the append-only log, documentation is actively edited as plans and decisions evolve.

## Directory Structure

A project managed by Agent Assemble maintains documentation under `documentation/`:

```
documentation/
├── plans/          requirements, technical plans, and specifications
├── decisions/      durable decision records and the decided/deferred lists
└── conventions/    definition of done, coding standards, and project constraints
```

## The Decided / Deferred Split

Not all architectural or product questions can be settled at intake. Documentation separates settled choices from deliberately postponed choices in `documentation/decisions/decided-deferred.md`.

1. **Decided:**
   - Settled constraints, technical choices, and established architectures.
   - Example: Language, framework, repository layout, licensing rules.

2. **Deferred:**
   - Deliberately postponed questions. A deferred item is explicit knowledge, not an unacknowledged gap.
   - Each deferred item must specify:
     - **Question:** What remains open.
     - **Reason:** Why deciding now is premature.
     - **Trigger:** The exact milestone, metric, or event that will force the decision.

See [references/decided-deferred-template.md](references/decided-deferred-template.md) for the standard template.

## Documentation Drift Rule

When plans or decisions change, existing task cards risk going stale.

Whenever an agent updates any file in `documentation/`:
1. **Audit active cards:** Review all cards in `board/todo/`, `board/in-progress/`, and `board/testing/`.
2. **Evaluate impact:** Ask: *"Which cards does this update invalidate or alter?"*
3. **Reconcile:**
   - If acceptance criteria have changed, update the task card immediately.
   - If a work item in progress is invalidated, notify the assigned role and return the task card to `board/todo/` with a documented reason.

For drift management workflows, see [references/documentation-guide.md](references/documentation-guide.md).
