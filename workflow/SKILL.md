# Workflow Relay

**Status:** experimental.

Governs how work changes hands across named placeholder roles coordinating without domain assumptions.

## Sizing Gate

The Project Manager (PM) evaluates every request before work begins:
- **Direct:** Trivial single-line fixes. Bypasses BA and SQA gates; PM or Employee executes and PM logs closure.
- **Short:** Bounded 1–2 file changes. BA records acceptance criteria directly into a task card without a separate plan.
- **Full:** New capabilities or cross-cutting changes. Requires BA elicitation, durable plans, and full SQA verification.

For scoring and skipping rules, see [references/sizing-rubric.md](references/sizing-rubric.md).

## The Relay Cycle

Four placeholder roles execute the relay:
1. **PM:** Intake, sizing evaluation, assigning, and closure audit.
2. **BA:** Requirements elicitation, durable plans, and card creation.
3. **Employee:** Implementation, diff summary, and self-verification.
4. **SQA:** Independent verification, sabotage testing, and sign-off.

For procedural instructions, see [references/relay-roles.md](references/relay-roles.md).

## Handoff Invariants

1. **Card as vehicle:** A role reads prior sections and records findings, diffs, or test evidence in its designated section before handoff.
2. **Atomic log by-product:** Moving a card without an accompanying entry in `log/LOG.md` invalidates the transition; receiving roles must reject it back immediately.
3. **Sabotage evidence:** Each criterion needs a test, mutation, resolved outcome. See `board/references/sabotage-evidence-guide.md`.
