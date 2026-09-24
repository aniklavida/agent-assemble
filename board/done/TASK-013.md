---
id: "TASK-013"
title: "Public documentation and the dogfood run"
size: "full"
status: "done"
assigned_role: "PM"
created_at: "2026-09-24T22:52:00Z"
updated_at: "2026-09-25T00:30:00Z"
---

## Context & Request

Make Agent Assemble usable by a stranger from the README alone, and genuinely
use the tool on itself so the project's central claim is tested rather than
asserted. Publish the friction, not only the successes.

## Acceptance Criteria

- [x] A stranger following only the README can complete setup and one real task on a clean checkout
- [x] The README states what the tool is and explicitly what it is not
- [x] Every statement of the value proposition pairs it in the same paragraph with the host limitation
- [x] An authoring guide covers a role, a principle, and a board adapter
- [x] The four-state host-support matrix is published once, in docs/ARCHITECTURE.md
- [x] At least one card was carried end to end on this project using the tool's own mechanism, with friction published
- [x] Known limitations are published, including that no host reports whether a skill was followed
- [x] No public document names a reference or prior-art project, except for reuse attribution

## Sabotage Evidence

- criterion: A stranger following only the README can complete setup and one real task on a clean checkout
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Renamed the \"Five-minute start\" heading in README.md so the section is absent"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: The README states what the tool is and explicitly what it is not
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Renamed the \"What it is not\" heading in README.md"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Every statement of the value proposition pairs it in the same paragraph with the host limitation
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Inserted a blank line in README.md splitting the claim and the limit into separate paragraphs"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: An authoring guide covers a role, a principle, and a board adapter
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Renamed the \"Append Log\" operation in docs/AUTHORING.md"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: The four-state host-support matrix is published once, in docs/ARCHITECTURE.md
  test: "bash scripts/check-host-pointers.sh ."
  mutation: "Changed a matrix status in docs/ARCHITECTURE.md from \"Mechanically verified\" to \"Fully supported\""
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: At least one card was carried end to end on this project using the tool's own mechanism, with friction published
  test: "bash scripts/check-log-sequence.sh board"
  mutation: "Deleted the WORK_STARTED row for TASK-013 from log/LOG.md"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: Known limitations are published, including that no host reports whether a skill was followed
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Renamed the \"Known limitations\" heading in README.md"
  sabotage_outcome: "fail"
  sabotage_cause: ""

- criterion: No public document names a reference or prior-art project, except for reuse attribution
  test: "bash scripts/check-public-docs.sh ."
  mutation: "Appended an external repository URL to README.md"
  sabotage_outcome: "fail"
  sabotage_cause: ""

## Handoff Trail

### Analysis Handoff (BA)
- Plan: No separate plan document — the criteria above are the scope. Short-path criteria on a Full-sized item.
- Notes: The self-hosting run is the part that cannot be faked; the card records the states it actually passed through.

### Implementation Handoff (Employee)
- Files modified:
  - `README.md` — what it is and is not, five-minute start, claim and limit, known limitations
  - `docs/AUTHORING.md` — role, principle and board-adapter authoring
  - `docs/DOGFOOD.md` — the self-hosting report and friction
  - `docs/SPEC.md` — claim and limit brought into one paragraph
  - `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md` — gaps filled
  - `scripts/check-public-docs.sh` and `.github/workflows/validate.yml`
  - `.agent-assemble/`, `documentation/decisions/`, `log/LOG.md`, this card
- Decisions: A documentation requirement with no failing mutation is prose, so each new requirement was given a checker. The host matrix stays single-sourced in `docs/ARCHITECTURE.md`; the README links to it rather than restating it.
- Self-verification:
  - Command: `bash scripts/check-public-docs.sh . && bash scripts/check-word-budget.sh`
  - Output: PASS on both

### Verification Handoff (SQA)
- Verification check:
  - Command run: `bash scripts/check-public-docs.sh . && bash scripts/check-host-pointers.sh . && bash scripts/check-log-sequence.sh board && bash scripts/check-evidence.sh board`
  - Result: pass — every criterion's named test was run against a copy of the tree, a mutation was applied for each, the test failed for each mutation, and the mutation was reverted
- Sabotage check: see Sabotage Evidence section above
- Verdict: APPROVED

### Acceptance Sign-off (PM)
- Log audit: confirmed the unbroken sequence CARD_CREATED -> WORK_STARTED -> WORK_COMPLETED -> VERIFICATION_PASSED -> CARD_CLOSED in `log/LOG.md`, each owned by the expected role, with `scripts/check-log-sequence.sh board`.
- Sign-off note: accepted and closed.
