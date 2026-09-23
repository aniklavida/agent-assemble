# Principles Fixtures

One fixture per property the three-mode principle system must satisfy.
A fifth directory (`bad/`) holds deliberately broken versions that `check-principles.sh`
must reject.

## Good fixtures

| Directory | What it proves |
|---|---|
| `tdd-selected/` | TDD=Prescriptive selected; card without test evidence is blocked at the SQA gate. |
| `tdd-deselected/` | TDD not selected; same card without test evidence is not blocked. |
| `advisory-only/` | Only advisory principles selected; no gate blocking occurs. |
| `perspective/` | Perspective-mode principles produce questions (MAY ask), not verdicts. The card carries a question from each shipped perspective: Security, Performance and Researcher. |

## Bad fixtures

The `bad/` directory contains deliberately broken sub-fixtures, each with one
violation:

- `bad/advisory-only/` — `principles.md` contains a Prescriptive principle,
  making the advisory-only fixture misconfigured. The check must detect this.
- `bad/perspective/` — the card contains `BLOCKED:` (a verdict) instead of a
  `MAY ask` question. The check must detect a perspective producing a verdict.
- `bad/perspective-security/` — a Security question is turned into a verdict
  with `BLOCKED:`. The check must reject it.
- `bad/perspective-performance/` — a Performance question is turned into a
  verdict with `MUST ... block`. The check must reject it.
- `bad/perspective-researcher/` — a Researcher question is turned into a verdict
  with `verdict: BLOCKED`. The check must reject it.

Each corrupted card keeps its `MAY ask` line, so rejection is caused by the
verdict and not by the question having been deleted.

Running `scripts/check-principles.sh fixtures/principles/bad` must exit non-zero.

The same script also verifies the shipped role files under
`employees/security/`, `employees/performance/` and `employees/researcher/`
contain a `MAY ask` question and no `MUST`/`BLOCKED` verdict.

## Usage

```sh
# Good sweep — must pass
scripts/check-principles.sh fixtures/principles

# Bad sweep — must exit non-zero
scripts/check-principles.sh fixtures/principles/bad

# Detection mode — scan a codebase for principle signals
scripts/check-principles.sh --detect .
```
