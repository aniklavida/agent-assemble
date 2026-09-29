# Release checklist — v1.0

Nothing may be ticked because it should work. Each line is ticked when it has
been run.

## Function

- [x] A fresh directory completes setup and carries one task through the full relay.
      *Verified 2026-09-29: mktemp scratch, card relay, `check-log-sequence.sh` PASS.*
- [ ] An existing repository is read, summarised accurately, and set up with four questions or fewer.
      *Gap: interview is instruction, not code. TASK-013 dogfood used the flow once; a second
      clean run in a vendor host was not performed. Experimental.*
- [ ] **A second agent session with no memory of the first reads the board and log and correctly states what is done and what remains.**
      *Gap: board and log are correct (`check-log-sequence.sh` PASS); whether a vendor-hosted
      agent with wiped context reports state accurately is not observable from a shell. Experimental.*
- [ ] A trivial request is sized down and provably skips most of the chain.
      *Partial: `check-sizing-gate.sh` confirms direct vs. full gate logic (PASS); end-to-end
      skip in a vendor host was not run. Experimental.*
- [ ] Deleting the log directory and re-running regenerates it; nothing depends on hidden state.
      *Gap: the log is append-only by design; there is no reconstruction path. Unsupported.*

## Structure

- [x] A word ceiling has been chosen and a command enforces it —
      `scripts/check-word-budget.sh` fails a core above 200 words on every push.
- [x] A composed multi-level role is measured against that ceiling rather than estimated.
      *Verified 2026-09-29: `check-composed-budget.sh employees/software-engineer/backend-developer/nodejs`
      → 591/600 words PASS. Three levels exist; the script handles four but no fourth level is present.*
- [x] No sentence appears at two levels — checked mechanically, not by reading.
      *Verified 2026-09-29: `check-duplicate-sentences.sh` → PASS.*
- [x] **Removing a parent level provably changes the child's behaviour.** If it does not, the inheritance is decorative and this line fails.
      *Verified 2026-09-29: `check-inheritance-proof.sh` → Backend Developer is load-bearing; PASS.*

## Principles

- [x] A project with a practice selected has a card returned by the gate for violating it.
      *Verified 2026-09-29: `check-principles.sh` → tdd-selected blocked at SQA gate; PASS.*
- [x] The same project without it selected does not, and the gate does not complain about it either.
      *Verified 2026-09-29: `check-principles.sh` → tdd-deselected not blocked; PASS.*
- [x] An advisory reminder never blocks.
      *Verified 2026-09-29: `check-principles.sh` → advisory-only not blocked; PASS.*
- [x] A perspective produces a question, never a verdict.
      *Verified 2026-09-29: `check-principles.sh` → MAY ask question confirmed, no verdict; PASS.*

## Board and drift

- [ ] The same task completes against every supported board backend.
      *Partial: `check-board-adapters.sh` confirms equivalent contract state for all three backends
      (PASS); end-to-end in a real Obsidian vault or Linear workspace was not run. Experimental.*
- [x] An existing board is connected to, not duplicated.
      *Verified 2026-09-29: `check-board-connect-existing.sh` → PASS for Markdown and Obsidian.*
- [x] Choosing a backend the host cannot reach is refused at setup, with the reason.
      *Verified 2026-09-29: `check-board-reachability.sh fixtures/board-adapters/reachability/bad`
      → REFUSED naming the reason; PASS.*
- [x] A documentation change surfaces the cards it invalidates, and leaves unaffected cards alone.
      *Verified 2026-09-29: `verify-drift-reconciliation.sh` → surfaced, flagged, logged,
      zero false positives; PASS.*

## Tools

- [x] A dependency violating the licence policy is refused, naming the licence and the rule.
      *Verified 2026-09-29: `check-tools-registry.sh` → GPL-3.0 refused, naming component,
      licence, and rule; PASS.*
- [x] A container tag masking a licence change is caught.
      *Verified 2026-09-29: `check-tools-registry.sh` → redis:7-alpine resolved to RSALv2,
      refused, naming tag, version, licence, and rule; PASS.*

## Honesty

- [x] Every host matrix cell is backed by what it claims; no cell reads "observed working" without a dated record of who ran it, on what.
- [x] The README carries the claim and its limit in the same paragraph, and
      `scripts/check-public-docs.sh` fails a public document that splits them.
- [x] Release notes state plainly what is unverified.
      *Verified 2026-09-29: `docs/RELEASE_NOTES_v1.0.md` written in this session, naming
      every gap and all open items.*
- [x] No public document names a reference project except where attribution is
      legally required; an external repository URL is refused by
      `scripts/check-public-docs.sh`.

## Dogfood

- [x] At least one card in this project was carried end to end by the tool
      itself, and what went wrong is published in
      [DOGFOOD.md](DOGFOOD.md).

A tool for organising agent work that was not used to organise its own is making
a claim it has not tested.
