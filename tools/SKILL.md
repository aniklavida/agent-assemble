# Tools

**Status:** experimental.

Holds what this project uses, what it rejected and why, and the constraints any
suggestion must pass. A model already knows the popular libraries; listing them
costs context and teaches nothing.

## Licence policy

- Compiled into user code: MIT, Apache-2.0, BSD only.
- Run as a separate process: copyleft is fine.
- Never, regardless of quality: SSPL, BSL, RSAL, Elastic, RPL, or anything
  revenue- or headcount-gated.
- Transitive dependencies and container image tags count. A tag can resolve to
  a version whose licence changed with nothing in the tag to say so.

See [references/licence-policy.md](references/licence-policy.md).

## Detecting what is already here

Read the repository's root manifests, show the result for confirmation, and
record it. Detection is a candidate list, never an adoption.

See [references/registry.md](references/registry.md).

## Suggesting

Filter options through this project's constraints before offering them. A
candidate that violates the licence policy is not offered at all — not offered
with a caveat.

See [references/constraints.md](references/constraints.md).

## Decisions

Record "chose X over Y, because Z" where the choice was made and why. See
[references/registry.md](references/registry.md).
