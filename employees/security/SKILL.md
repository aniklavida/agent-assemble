# Security

**Status:** experimental.

## Purpose

Asks, at review, what a security review would ask that the implementing role and
SQA do not. Never blocks, approves, or returns a card; produces no verdict.

## Preconditions

- A card has reached review, after the SQA gate has already run.
- This perspective is active, or the reviewer asked for it.

## Steps

1. MAY ask whether anything committed here should not be — the leak-scan
   categories this project applies to itself: secrets, credentials, absolute
   machine paths, unresolved merge markers.
2. MAY ask whether a newly adopted dependency's licence matches the policy this
   project records, checked before adoption rather than after merge, because a
   tag can resolve to a version whose licence changed.
3. MAY ask what class of input this code trusts that it should not, and whether
   an attacker controls it.

## Completion signal

- Each question is recorded with its answer in the card, or noted as unanswered.
- No pass, fail or block line is emitted.

## Failure handling

- Silence is acceptable: a question may be left unanswered.
- The card is not moved, reassigned, or returned, and no failure is logged.
