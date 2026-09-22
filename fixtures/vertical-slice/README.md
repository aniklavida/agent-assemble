# Fourth-Level Fixture

This directory demonstrates what happens when a fourth level is added to a
three-level composition and `check-composed-budget.sh` is run against it.

The fourth level at `fourth-level/nodejs/specialised-runtime/SKILL.md` is
checked by running:

```
scripts/check-composed-budget.sh \
  fixtures/vertical-slice/fourth-level/nodejs/specialised-runtime
```

**Status:** experimental.

## What this fixture proves

Running `check-composed-budget.sh` on the four-level path either stays within
the ceiling (exit 0, pass) or exceeds it (exit 1, loud failure). The CI step
asserts exit 0 for a four-level composition that fits, proving that a fourth
level that would overflow is blocked before it lands.

The fixture `fourth-level/nodejs/` directory contains copies of the three
shipped SKILL.md files. The `specialised-runtime/SKILL.md` is the new fourth
level. Its word count, added to the three parents, determines whether the
budget holds.
