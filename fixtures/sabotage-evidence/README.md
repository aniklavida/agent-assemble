# Sabotage Evidence Fixtures

This directory contains fixture task cards used to verify `scripts/check-evidence.sh`.

## good/

Cards that must **pass** the check. Each has status `"done"` and every acceptance
criterion carries:

- a named test (`test:`)
- a named mutation (`mutation:`)
- a recorded `sabotage_outcome:` of `"fail"` or `"pass"` — never blank or `"unresolved"`
- when `sabotage_outcome: "pass"`, a non-blank `sabotage_cause:` naming the independent
  safeguard, explaining why the build result is non-informative, or stating that the
  test never reaches the mutated code

**TASK-200** — three criteria, two with `sabotage_outcome: fail`, one with
`sabotage_outcome: pass` resolved by naming a second independent safeguard.

## bad/

Cards that must **fail** the check. The script is never run against this directory
during a normal sweep; it is only invoked here explicitly during CI to prove that
violations are detected.

| File | What it tests |
|---|---|
| `TASK-BAD-201.md` | A criterion with a blank `test:` and blank `mutation:` fails |
| `TASK-BAD-202.md` | A criterion with `sabotage_outcome: "pass"` and blank `sabotage_cause:` fails |
| `TASK-BAD-203.md` | A criterion with `sabotage_outcome: "unresolved"` fails |

## How to run

```sh
# Normal sweep — must pass
bash scripts/check-evidence.sh

# Bad-fixture sweep — must fail (exit non-zero)
bash scripts/check-evidence.sh fixtures/sabotage-evidence/bad
```
