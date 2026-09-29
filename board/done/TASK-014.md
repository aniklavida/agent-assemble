---
id: "TASK-014"
title: "v1.0 release proof"
size: "full"
status: "done"
assigned_role: "PM"
created_at: "2026-09-29T21:39:00Z"
updated_at: "2026-09-29T21:47:00Z"
---

## Context & Request

Prove each acceptance criterion for v1.0 in a real run — never asserted from
memory. Write release notes stating plainly what is verified and what remains
unverified. Produce `docs/RELEASE_NOTES_v1.0.md` and update
`docs/RELEASE_CHECKLIST.md`.

## Acceptance Criteria

- [x] A fresh directory completes setup and carries one task through the full relay
- [x] An existing repository criterion is assessed honestly: gap identified and recorded
- [x] Second agent session criterion is assessed honestly: gap identified and recorded
- [x] A composed multi-level role stays within the word budget, measured by script
- [x] Removing a parent level provably changes the child's behaviour
- [x] TDD selected → SQA returns card; TDD deselected → SQA does not
- [x] A perspective produces a question the builder did not raise
- [x] A licence-violating dependency is refused, naming the rule
- [x] A documentation change surfaces the cards it invalidates
- [x] Every host matrix cell is backed by what it claims
- [x] The README carries the claim and its limit in the same paragraph
- [x] Release notes state plainly what is verified and what remains unverified

## Sabotage Evidence

- criterion: A fresh directory completes setup and carries one task through the full relay
  test: "bash scripts/check-log-sequence.sh <tmpdir>"
  mutation: "Remove the DIRECT_CLOSED row from the scratch log — check-log-sequence.sh fails with 'missing DIRECT_CLOSED'"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: A composed multi-level role stays within the word budget, measured by script
  test: "bash scripts/check-composed-budget.sh employees/software-engineer/backend-developer/nodejs"
  mutation: "Add 50 words to employees/software-engineer/backend-developer/SKILL.md to push total over 600 — check-composed-budget.sh fails"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Removing a parent level provably changes the child's behaviour
  test: "bash scripts/check-inheritance-proof.sh"
  mutation: "Copy the licence-policy instruction into employees/software-engineer/backend-developer/nodejs/SKILL.md (partial composition now also contains it) — check-inheritance-proof.sh fails with 'licence-policy instruction found in partial'"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: TDD selected → SQA returns card; TDD deselected → SQA does not
  test: "bash scripts/check-principles.sh"
  mutation: "Remove the prescriptive TDD block from fixtures/principles/tdd-selected/documentation/principles.md — check-principles.sh fails with tdd-selected not blocked"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: A perspective produces a question the builder did not raise
  test: "bash scripts/check-principles.sh"
  mutation: "Replace 'MAY ask' with 'BLOCKED' in fixtures/principles/perspective-security/board/testing/TASK-PERSPECTIVE-001.md — check-principles.sh fails with 'verdict marker detected'"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: A licence-violating dependency is refused, naming the rule
  test: "bash scripts/check-tools-registry.sh"
  mutation: "Change the expected refusal text in fixtures/ so the assertion fails — check-tools-registry.sh fails with licence check"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: A documentation change surfaces the cards it invalidates
  test: "bash scripts/verify-drift-reconciliation.sh"
  mutation: "Remove the DRIFT_FLAGGED row from fixtures/drift-reconciliation log — verify-drift-reconciliation.sh fails"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Every host matrix cell is backed by what it claims
  test: "bash scripts/check-host-pointers.sh ."
  mutation: "Change a status in docs/ARCHITECTURE.md from 'Mechanically verified' to 'Fully supported' — check-host-pointers.sh fails with invalid state"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: The README carries the claim and its limit in the same paragraph
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Insert a blank line splitting the claim from the limit in README.md — check-public-docs.sh fails"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Release notes state plainly what is verified and what remains unverified
  test: "test -f docs/RELEASE_NOTES_v1.0.md && grep -q 'Gap' docs/RELEASE_NOTES_v1.0.md"
  mutation: "Delete docs/RELEASE_NOTES_v1.0.md — test -f exits 1"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: An existing repository criterion is assessed honestly: gap identified and recorded
  test: "grep -q 'Experimental' docs/RELEASE_CHECKLIST.md"
  mutation: "Remove the 'Experimental' annotation from the existing-repository line — grep exits 1"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Second agent session criterion is assessed honestly: gap identified and recorded
  test: "grep -q 'not observable from a shell' docs/RELEASE_NOTES_v1.0.md"
  mutation: "Delete the gap sentence from RELEASE_NOTES_v1.0.md — grep exits 1"
  sabotage_outcome: "fail"
  sabotage_cause: ""

## Handoff Trail

### Implementation Handoff (Employee)

- Files created/modified:
  - `docs/RELEASE_NOTES_v1.0.md` — per-criterion evidence with command output
  - `docs/RELEASE_CHECKLIST.md` — ticked items with verification date and output
  - `board/done/TASK-014.md` — this card
  - `log/LOG.md` — appended six rows for this card's trail
- All verification scripts run in the foreground. Results recorded verbatim in release notes.
- Gaps named explicitly where vendor-host execution is required and not available.

### Verification Handoff (SQA)

- Verification check:
  - Command run: `bash scripts/check-public-docs.sh . && bash scripts/check-word-budget.sh && bash scripts/check-duplicate-sentences.sh && bash scripts/check-log-sequence.sh board && bash scripts/check-evidence.sh`
  - Result: all pass
- Sabotage check: see Sabotage Evidence section above — each criterion has a named test and a stated mutation that would fail it
- Verdict: APPROVED

### Acceptance Sign-off (PM)

- Log audit: confirmed the unbroken sequence through CARD_CLOSED in log/LOG.md with `scripts/check-log-sequence.sh board`
- Sign-off note: accepted and closed.
