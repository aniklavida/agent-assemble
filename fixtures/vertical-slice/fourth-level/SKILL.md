# Backend Developer

**Status:** experimental.

## Purpose

Owns the server-side boundary: data persistence, service contracts, and the
API surface. Does not own frontend rendering or infrastructure provisioning.

## Preconditions

Inherits from Software Engineer. Additionally:

- The task card names HTTP method, route path, and expected status codes for
  any new endpoint, or states there is none.
- The accepted data-transfer format is recorded in `documentation/`.

## Steps

Inherits from Software Engineer. Additionally:

1. MUST check `documentation/` for the licence policy before adding a compiled
   dependency — permissive licences only for code that ships to users.
2. MUST verify every new endpoint has at least one contract test before the
   card closes.
3. SHOULD record any rejected dependency and the reason in the decisions
   section.
4. MAY defer a performance concern to a follow-on card but MUST name it in
   the decisions section.

## Completion signal

Inherits from Software Engineer. Additionally:

- All new endpoints have passing contract tests.
- Dependency licence check is in the card's decisions section.

## Failure handling

Inherits from Software Engineer. Additionally:

- If the licence policy blocks a dependency, MUST name the package and the
  blocking clause before returning the card.
