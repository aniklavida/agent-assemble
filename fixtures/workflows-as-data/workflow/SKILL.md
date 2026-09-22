# Workflow Relay

**Status:** experimental.

Governs how work changes hands across named roles. Two questions govern every
request: *how big is it?* (sizing) and *who runs it, in what order?* (workflow).
These are answered separately.

## Sizing Gate

The PM evaluates every request before work begins:
- **Direct:** Trivial single-line fixes. Bypasses BA and SQA.
- **Short:** Bounded 1–2 file changes. BA writes criteria into the card; no plan doc.
- **Full:** New capabilities or cross-cutting changes. All roles active.

For scoring and skipping rules, see [references/sizing-rubric.md](references/sizing-rubric.md).

## Workflow Selection

Sizing maps to a workflow name. The named workflow in
[workflows.md](workflows.md) defines the ordered role list for that path.
A project adds its own workflow by editing `workflows.md` alone — no `SKILL.md`
changes.

## Handoff Invariants

1. **Card as vehicle:** Each role records findings in its card section before handoff.
2. **Atomic log by-product:** Moving a card without a matching `log/LOG.md` entry
   is invalid; the receiving role rejects it back.
3. **Sabotage evidence:** Each criterion needs a test, mutation, and resolved
   outcome. See `board/references/sabotage-evidence-guide.md`.

For role procedure steps, see [references/relay-roles.md](references/relay-roles.md).
