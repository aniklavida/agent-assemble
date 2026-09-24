# Event Log

Append-only. Never edit or reorder a past row. Schema:
`log/references/log-schema.md`.

| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |
|---|---|---|---|---|---|
| 2026-09-24T22:50:00Z | TASK-013 | REQUEST_SIZED | PM | Documentation and structure change; four dimensions scored Full (cross-cutting public docs plus a self-hosting run) | backlog (BA) |
| 2026-09-24T22:52:00Z | TASK-013 | CARD_CREATED | BA | Elicited scope; created `board/todo/TASK-013.md` with eight criteria | todo (Employee) |
| 2026-09-24T22:53:00Z | TASK-013 | WORK_STARTED | Employee | Acquired card; moved to `board/in-progress/TASK-013.md`; began the documentation and self-hosting work | in-progress (Employee) |
| 2026-09-25T00:10:00Z | TASK-013 | WORK_COMPLETED | Employee | Wrote README, AUTHORING, DOGFOOD, policy gaps and check-public-docs.sh; self-checks pass; moved to `board/testing/TASK-013.md` | testing (SQA) |
| 2026-09-25T00:14:00Z | TASK-013 | VERIFICATION_STARTED | SQA | Read the card and handoff; began independent execution of the invariant checks | testing (SQA) |
| 2026-09-25T00:25:00Z | TASK-013 | VERIFICATION_PASSED | SQA | All eight criteria verified; each mutation made its named test fail; evidence recorded | review (PM) |
| 2026-09-25T00:30:00Z | TASK-013 | CARD_CLOSED | PM | Log trail audited with `scripts/check-log-sequence.sh board`; card moved to `board/done/TASK-013.md` | done |
