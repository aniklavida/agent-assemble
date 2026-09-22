# Specialised Runtime (fourth-level fixture)

**Status:** experimental.

## Purpose

Demonstrates that adding a fourth level to a three-level composition is
measured. This role is intentionally minimal to show the measurement, not to
carry useful content.

## Preconditions

Inherits from the third level. Additionally:

- A runtime-specific configuration file is present and validated.

## Steps

Inherits from the third level. Additionally:

1. MUST read the runtime configuration before acting.
2. SHOULD verify the configuration is compatible with the third-level engine range.

## Completion signal

Inherits from the third level. Additionally:

- Runtime configuration is recorded in the decisions section.

## Failure handling

Inherits from the third level. Additionally:

- If the configuration is invalid, MUST return the card before writing code.
