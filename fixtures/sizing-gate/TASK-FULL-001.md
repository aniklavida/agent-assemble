---
id: "TASK-FULL-001"
title: "Add webhook notification on card closure"
size: "full"
status: "done"
assigned_role: "PM"
created_at: "2026-09-23T09:30:00Z"
updated_at: "2026-09-23T16:00:00Z"
---

## Context & Request

When a task card moves to `done`, POST the card summary to a configurable
URL with retry logic on failure. Auth, payload schema, and retry count are
configurable per project.

PM sizing: Full (new module, 3+ files, high ambiguity, new architectural
pattern). BA ran elicitation first. Plan in `documentation/plans/webhook.md`.
All roles active; SQA ran per-criterion sabotage.

## Acceptance Criteria

- [x] A POST request is sent to the configured URL when a card moves to done
- [x] Failed POSTs are retried up to the configured retry count

## Sabotage Evidence

- criterion: A POST request is sent to the configured URL when a card moves to done
  test: test_webhook_fires_on_card_closure
  mutation: Removed the webhook.send() call from the card-close handler
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Failed POSTs are retried up to the configured retry count
  test: test_webhook_retries_on_failure
  mutation: Changed retry loop from range(retry_count) to range(0) to disable retries
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Analysis Handoff (BA)
- Plan: `documentation/plans/webhook.md`
- Notes: Elicitation surfaced that auth is a bearer token; retry count defaults
  to 3 if not configured. Payload is the card's frontmatter as JSON.

### Implementation Handoff (Employee)
- Files modified:
  - `board/hooks/webhook.py`
  - `board/card.py`
  - `setup/references/project-config-template.md`
- Decisions: Retry uses exponential backoff; final failure is logged but does not
  block the card move.
- Self-verification:
  - Command: `pytest tests/test_webhook.py`
  - Output: 2 passed

### Verification Handoff (SQA)
- Verification check:
  - Command run: `pytest tests/test_webhook.py`
  - Result: pass — 2 tests, 0 failures
- Sabotage check: see Sabotage Evidence section above
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Log audit: confirmed CARD_CREATED → WORK_STARTED → WORK_COMPLETED →
  VERIFICATION_PASSED in log/LOG.md; trail is unbroken.
- Sign-off note: accepted and closed
