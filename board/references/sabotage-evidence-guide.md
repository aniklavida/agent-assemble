# Sabotage Evidence Guide

When SQA performs a sabotage test, it introduces a mutation and observes whether
the named test fails. Three outcomes are possible.

## Outcome: fail (expected)

The named test detected the mutation. Record `sabotage_outcome: "fail"` and leave
`sabotage_cause` blank. No further investigation is needed.

## Outcome: pass — three permitted causes

When the named test stays green after a mutation, one of three causes applies.
Identify which, and record it in `sabotage_cause`. An item may not close until
every unresolved entry has been resolved to one of these.

### 1. A second independent safeguard also enforces it

A different layer — middleware, platform adapter, a separate service — independently
enforces the same invariant. The named test stopped at that layer rather than at the
code that was mutated.

`sabotage_cause:` state which other safeguard enforces the invariant, and where it
lives.

**What this does not mean:** that the mutated code is dead. Two independent safeguards
are frequently intentional. Removing either silently leaves the other as the sole
line of defence, with no test to detect the gap.

### 2. The mutation did not land or did not compile

A build failure proves nothing. If the mutation caused a compile error, or the edited
file was not the file the running test exercised, the sabotage was not applied.

`sabotage_cause:` state that the build failed (or explain why the mutation did not
apply), and record what was confirmed in its place.

**What this does not mean:** that the test is good. A mutation that cannot land is
not evidence of anything.

### 3. The test never reaches that code

The test exercises a path that does not pass through the mutated code. The invariant
may or may not be enforced — the test simply has no opinion on it.

`sabotage_cause:` state that the test does not exercise that code path, and note
whether an alternative test would be needed to prove the criterion.

---

## The record states what happened, not what an agent did

Filling this record does not prove the agent followed the procedure. No host reports
that. The record makes the *evidence* checkable — a reviewer can see whether a test
name was given, whether a mutation was named, and whether a passing sabotage was
investigated. That is the limit of what the record can claim.
