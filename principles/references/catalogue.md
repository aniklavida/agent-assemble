# Principle Catalogue

Principles are organised into four families. Selecting a principle means
choosing it *and* its mode. The mode fixes where the principle bites — see
`references/modes.md`.

No principle is taught here. A model that already knows TDD does not need a
tutorial; it needs to know whether TDD is selected, and what happens if it is
skipped at the gate.

## Coding

| Principle | Notes |
|---|---|
| TDD | Prescriptive at SQA gate: a test MUST exist and MUST have failed before the implementation that makes it pass. Advisory at desk: SHOULD write the test first. |
| Clean Architecture | Prescriptive: MUST not cross layer boundaries in the direction of the domain. |
| Clean Code | Advisory: SHOULD favour readability. |
| SOLID | Advisory: SHOULD apply single-responsibility and open/closed at the design step. |
| DRY | Advisory: SHOULD not duplicate logic. Perspective at review: MAY ask whether two identical blocks are incidentally or intentionally the same. |
| YAGNI | Advisory: SHOULD not add capability the current card does not require. |
| Design Patterns | Advisory: SHOULD name the pattern used and why in the decisions section. |
| Refactoring | Advisory: SHOULD leave the code cleaner than found. Prescriptive at gate if the card names a refactor target: MUST show a before/after. |
| Error Handling | Prescriptive: MUST not swallow an error silently. |
| Code Review | Perspective: MAY ask whether the review criteria were applied, not merely that review happened. |

## Business Analysis

| Principle | Notes |
|---|---|
| Requirements Elicitation | Advisory: SHOULD surface ambiguity before writing acceptance criteria. |
| User Story | Prescriptive at BA gate: MUST follow the agreed format. |
| INVEST | Advisory: SHOULD check each criterion independently before the card is created. |
| Acceptance Criteria | Prescriptive at SQA gate: MUST be specific enough to admit a mechanical test. |
| Process Mapping | Advisory: SHOULD map the current flow before proposing a change. |
| MoSCoW | Advisory: SHOULD label every requirement as Must/Should/Could/Won't at the plan step. |

## Design

| Principle | Notes |
|---|---|
| Design System | Prescriptive: MUST use the project's design tokens rather than raw values. |
| Accessibility (WCAG) | Prescriptive at review: MUST meet the agreed conformance level. |
| Progressive Disclosure | Advisory: SHOULD hide secondary controls until the primary action is taken. |
| Visual Hierarchy | Advisory: SHOULD confirm the reading order before shipping. |
| Responsive | Prescriptive: MUST test at the declared breakpoints. |
| Design Tokens | Prescriptive: MUST not hard-code a value that exists as a token. |

## SQA

| Principle | Notes |
|---|---|
| Test Pyramid | Advisory: SHOULD have more unit tests than integration tests, more integration than end-to-end. |
| Risk-based Testing | Advisory: SHOULD allocate effort to the highest-risk paths first. |
| Exploratory Testing | Perspective: MAY ask whether a session charter was written and the findings recorded. |
| Boundary Value | Prescriptive: MUST test one below and one above each boundary. |
| Equivalence Partitioning | Advisory: SHOULD group inputs and test one representative per group. |
| Defect Lifecycle | Prescriptive: MUST record every defect with repro steps before closing. |
