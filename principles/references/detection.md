# Principle Detection

When an existing project is opened, principles already in use can be inferred
from the codebase before asking the user. Detected results are shown for
confirmation — never applied silently.

## What to look for

| Signal | Inferred principle |
|---|---|
| Test files present and test runner in manifest | TDD (candidate) |
| Layered directory structure (`domain/`, `application/`, `infrastructure/`) | Clean Architecture (candidate) |
| A linter or formatter in the manifest | Clean Code (candidate) |
| Accessibility audit script or `axe` in manifest | Accessibility / WCAG (candidate) |
| A design-tokens file (`tokens.json`, `tokens.css`, or similar) | Design Tokens (candidate) |
| A snapshot or screenshot test suite | Visual Hierarchy (candidate) |
| Coverage threshold in the test config | Test Pyramid (candidate) |
| A `CONTRIBUTING.md` that names a story format | User Story (candidate) |

Marking a principle as a candidate does not select it. The agent presents each
candidate to the user: "I found these signals — confirm, adjust, or discard."

## What to record

After confirmation, record selected principles and their modes in
`documentation/principles.md`:

```markdown
# Active Principles

| Principle | Family | Mode |
|---|---|---|
| TDD | Coding | Prescriptive |
| Clean Code | Coding | Advisory |
| Accessibility (WCAG) | Design | Prescriptive |
```

This file is the single source of truth. Roles read it; no principle is
repeated under a role node.

## Detection for this repository

This repository (`agent-assemble`) can be used as a detection target. Run:

```sh
scripts/check-principles.sh --detect .
```

Expected output: signals for TDD (test scripts present), Clean Code (formatting
conventions in CONTRIBUTING.md), and Accessibility are absent. The CONTRIBUTING
and AGENTS conventions map to advisory process hygiene, not to a design
principle.
