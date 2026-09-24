---
id: "TASK-013"
title: "Public documentation and the dogfood run"
size: "full"
status: "done"
assigned_role: "PM"
created_at: "2026-09-25T04:22:00Z"
updated_at: "2026-09-25T04:29:00Z"
---

## Context & Request

Make Agent Assemble accessible to a stranger so they can understand and use the tool from the documentation alone. Genuinely dogfood Agent Assemble on itself to carry a work item end-to-end, publishing honest friction points.

## Acceptance Criteria

- [x] README explains what the tool is and explicitly what it is not
- [x] The claim and its limit pairing appears in the same paragraph wherever the value proposition is stated
- [x] Five-minute start guide is documented and verified on a clean checkout
- [x] Authoring guide for a role, a principle, and a board adapter is documented in docs/AUTHORING.md
- [x] Host-support matrix with four honest states is published in documentation
- [x] Gaps in CONTRIBUTING.md, CODE_OF_CONDUCT.md, and SECURITY.md are filled
- [x] Dogfood run is executed end-to-end on this project, tracking this work item through the tool's own mechanism, with friction points published in docs/DOGFOOD.md
- [x] All validation scripts pass cleanly in CI and locally

## Sabotage Evidence

- criterion: README explains what the tool is and explicitly what it is not
  test: bash scripts/check-public-docs.sh .
  mutation: Removed What It Is Not section from README.md causing script check to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: The claim and its limit pairing appears in the same paragraph wherever the value proposition is stated
  test: bash scripts/check-public-docs.sh .
  mutation: Removed the limit sentence from the claim paragraph in README.md causing paragraph pairing check to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Five-minute start guide is documented and verified on a clean checkout
  test: bash scripts/check-public-docs.sh .
  mutation: Removed Five-Minute Start section from README.md causing section check to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Authoring guide for a role, a principle, and a board adapter is documented in docs/AUTHORING.md
  test: bash scripts/check-public-docs.sh .
  mutation: Removed docs/AUTHORING.md causing existence and section checks to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Host-support matrix with four honest states is published in documentation
  test: bash scripts/check-host-pointers.sh .
  mutation: Replaced Mechanically verified with an invalid status state in docs/ARCHITECTURE.md causing matrix check to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Gaps in CONTRIBUTING.md, CODE_OF_CONDUCT.md, and SECURITY.md are filled
  test: bash scripts/check-public-docs.sh .
  mutation: Truncated required authoring reference linked by CONTRIBUTING.md causing validation to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: Dogfood run is executed end-to-end on this project, tracking this work item through the tool's own mechanism, with friction points published in docs/DOGFOOD.md
  test: bash scripts/check-log-sequence.sh board
  mutation: Removed WORK_STARTED event for TASK-013 from log/LOG.md causing log sequence check to fail
  sabotage_outcome: fail
  sabotage_cause: ""

- criterion: All validation scripts pass cleanly in CI and locally
  test: bash scripts/check-word-budget.sh
  mutation: Injected 50 filler words into setup/SKILL.md causing word budget check to fail
  sabotage_outcome: fail
  sabotage_cause: ""

## Handoff Trail

### Analysis Handoff (BA)
- Plan: Defined eight criteria covering README, authoring, host matrix, quickstart, gap remediation, and dogfood documentation.
- Notes: Elicitation confirmed that honest friction points must be recorded alongside successful executions.

### Implementation Handoff (Employee)
- Files modified:
  - README.md
  - docs/AUTHORING.md
  - docs/DOGFOOD.md
  - CONTRIBUTING.md
  - CODE_OF_CONDUCT.md
  - SECURITY.md
  - docs/RELEASE_CHECKLIST.md
  - CHANGELOG.md
  - scripts/check-public-docs.sh
- Decisions: Paired the claim and limit in both intro and claim sections; verified five-minute start against clean checkout.
- Self-verification:
  - Command: bash scripts/check-public-docs.sh --self-test && bash scripts/check-public-docs.sh .
  - Output: PASS on all tests

### Verification Handoff (SQA)
- Verification check:
  - Command run: bash scripts/check-evidence.sh && bash scripts/check-log-sequence.sh board && bash scripts/check-public-docs.sh .
  - Result: pass — all checks clean
- Sabotage check: see Sabotage Evidence section above
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Log audit: confirmed unbroken CARD_CREATED → WORK_STARTED → WORK_COMPLETED → VERIFICATION_PASSED → CARD_CLOSED sequence in log/LOG.md.
- Sign-off note: accepted and closed
