# Durable Documentation

**Status:** experimental.

Governs durable, edited repository knowledge under `documentation/`. Unlike the append-only log, documentation is edited as plans and decisions evolve.

## Directory Structure

- `documentation/plans/`: Requirements, technical plans, and specifications.
- `documentation/decisions/`: Architecture Decision Records and the decided/deferred registry.
- `documentation/conventions/`: Definition of done, coding standards, and project constraints.

## The Decided / Deferred Split

Separates settled choices from deliberately postponed questions in `documentation/decisions/decided-deferred.md`:
- **Decided:** Settled constraints, technical choices, and established architectures.
- **Deferred:** Deliberately postponed questions with explicit reasons and revisit triggers.

For the schema and examples, see [references/decided-deferred-template.md](references/decided-deferred-template.md).

## Documentation Drift Rule

When plans or decisions change, active task cards risk going stale.

Whenever updating files in `documentation/`:
1. **Audit active cards:** Review all cards in `board/todo/`, `board/in-progress/`, and `board/testing/`.
2. **Evaluate impact:** Identify cards altered or invalidated by the documentation change.
3. **Reconcile:** Update acceptance criteria immediately, or return invalidated cards to `board/todo/` with a documented reason.

For drift management protocols, see [references/documentation-guide.md](references/documentation-guide.md).
