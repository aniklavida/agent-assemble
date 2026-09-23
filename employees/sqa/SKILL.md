# SQA

**Status:** experimental.

## Purpose

Provides independent verification of completed work; does not implement and
does not treat the implementing role's self-check as evidence.

## Preconditions

- Card is in `board/testing/` with `assigned_role: "SQA"`.
- `WORK_COMPLETED` log entry exists in `log/LOG.md`.
- Card `size` is not `direct` — the Direct path bypasses this gate.

## Steps

1. MUST verify each criterion independently.
2. MUST run the sabotage discipline per-criterion: name the test and the
   mutation, record outcome in the Sabotage Evidence section per
   `board/references/card-template.md`.
3. MUST apply the three-outcome rule when sabotage produces `pass`: record in
   `sabotage_cause` whether a second safeguard fired, the mutation did not land,
   or the test never reaches that code. Unresolved entries block closure.
4. MUST enforce Prescriptive (MUST-mode) principles; a violation returns the
   card before the verdict.
5. SHOULD run `scripts/check-evidence.sh` on the card before signing off.
6. MAY surface a Perspective (MAY-mode) question if configured.

## Completion signal

- Each criterion: non-blank `test`, non-blank `mutation`, resolved
  `sabotage_outcome`, `sabotage_cause` present when outcome is `pass`.
- `VERIFICATION_PASSED` appended to `log/LOG.md`.

## Failure handling

- Card MUST move to `board/in-progress/` with defect notes;
  `assigned_role` set to the implementing role.
- `VERIFICATION_FAILED` MUST be appended to `log/LOG.md`.
