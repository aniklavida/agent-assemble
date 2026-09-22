# Principles Fixtures

Four fixtures, one for each property the three-mode principle system must satisfy.
A fifth directory (`bad/`) holds deliberately broken versions that `check-principles.sh`
must reject.

## Good fixtures

| Directory | What it proves |
|---|---|
| `tdd-selected/` | TDD=Prescriptive selected; card without test evidence is blocked at the SQA gate. |
| `tdd-deselected/` | TDD not selected; same card without test evidence is not blocked. |
| `advisory-only/` | Only advisory principles selected; no gate blocking occurs. |
| `perspective/` | Perspective-mode principles produce questions (MAY ask), not verdicts. |

## Bad fixtures

The `bad/` directory contains four corresponding sub-fixtures, each with one
deliberate violation:

- `bad/advisory-only/` — `principles.md` contains a Prescriptive principle,
  making the advisory-only fixture misconfigured. The check must detect this.
- `bad/perspective/` — the card contains `BLOCKED:` (a verdict) instead of a
  `MAY ask` question. The check must detect a perspective producing a verdict.

Running `scripts/check-principles.sh fixtures/principles/bad` must exit non-zero.

## Usage

```sh
# Good sweep — must pass
scripts/check-principles.sh fixtures/principles

# Bad sweep — must exit non-zero
scripts/check-principles.sh fixtures/principles/bad

# Detection mode — scan a codebase for principle signals
scripts/check-principles.sh --detect .
```
