# Principle Modes

Three modes map directly onto the RFC 2119 keywords used throughout this
project. The keyword in an instruction *is* the mode — no separate label is
needed.

## Advisory — SHOULD

**Where:** while the employee works, before any gate.

**Behaviour:** reminds and guides; never stops work or returns a card. An
advisory principle that is skipped produces no gate failure. Its value is that
an agent reminded at the desk is less likely to need correction at the gate.

**Example:** `SHOULD write a test before implementation.` The agent is reminded.
If the test is absent at the desk, work continues. The gate decides what to do
with the result.

## Prescriptive — MUST

**Where:** at a handoff gate — SQA, Security, or PM review.

**Behaviour:** blocks. A card that arrives at a gate without satisfying a
prescriptive principle is returned to the prior column with an explicit defect
note. The principle must be satisfied before the card advances.

**Example:** `MUST have a failing test before the implementation that makes it
pass.` If SQA finds no such evidence, the card goes back.

The distinction matters in practice: every real defect found in this workspace
that required the sabotage step to surface came from a prescriptive check at a
gate. An advisory version of the same instruction would not have blocked the
defective card.

## Perspective — MAY

**Where:** at review, after the gate.

**Behaviour:** asks a question; produces no verdict. A perspective does not
block and does not approve. Its purpose is to surface a different angle —
typically "has anyone actually verified this claim?" — that neither an advisory
reminder nor a prescriptive gate can ask, because both require a known answer
to compare against.

**Example:** `MAY ask: is there evidence this acceptance criterion was verified
against real storage, not a mock?` The reviewer decides what to do with the
answer.
