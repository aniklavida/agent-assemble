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

## Documentation Drift Protocol

When plans or decisions change, active task cards risk going stale.

Whenever updating files in `documentation/`:
1. **Identify dependencies:** Audit open items in `board/todo/`, `board/in-progress/`, and `board/testing/`. Unaffected items remain untouched.
2. **Confirm, never rewrite silently:** Present candidate adjustments for user confirmation. A board that edits itself is a second source of truth in disguise.
3. **Reconcile or flag:** On confirmation, update criteria and append `CARD_RECONCILED` to `log/LOG.md`. If unreconciled, flag with what changed beneath it and append `DRIFT_DETECTED` to `log/LOG.md`. Never delete an invalidated item.

For protocols and limits, see [references/documentation-guide.md](references/documentation-guide.md).
