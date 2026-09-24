# Release checklist — v1.0

Nothing may be ticked because it should work. Each line is ticked when it has
been run.

## Function

- [ ] A fresh directory completes setup and carries one task through the full relay.
- [ ] An existing repository is read, summarised accurately, and set up with four questions or fewer.
- [ ] **A second agent session with no memory of the first reads the board and log and correctly states what is done and what remains.**
- [ ] A trivial request is sized down and provably skips most of the chain.
- [ ] Deleting the log directory and re-running regenerates it; nothing depends on hidden state.

## Structure

- [ ] A word ceiling has been chosen and a command enforces it. Until then this
      item cannot be met, and the release it gates cannot be made.
- [ ] A composed multi-level role is measured against that ceiling rather than estimated.
- [ ] No sentence appears at two levels — checked mechanically, not by reading.
- [ ] **Removing a parent level provably changes the child's behaviour.** If it does not, the inheritance is decorative and this line fails.

## Principles

- [ ] A project with a practice selected has a card returned by the gate for violating it.
- [ ] The same project without it selected does not, and the gate does not complain about it either.
- [ ] An advisory reminder never blocks.
- [ ] A perspective produces a question, never a verdict.

## Board and drift

- [ ] The same task completes against every supported board backend.
- [ ] An existing board is connected to, not duplicated.
- [ ] Choosing a backend the host cannot reach is refused at setup, with the reason.
- [ ] A documentation change surfaces any cards it invalidates, and leaves unaffected cards alone.

## Tools

- [ ] A dependency violating the licence policy is refused, naming the licence and the rule.
- [ ] A container tag masking a licence change is caught.

## Honesty

- [x] Every host matrix cell is backed by what it claims; no cell reads "observed working" without a dated record of who ran it, on what.
- [x] The README carries the claim and its limit in the same paragraph.
- [ ] Release notes state plainly what is unverified.
- [x] No public document names a reference project except where attribution is legally required.

## Dogfood

- [x] At least one card in this project was carried end to end by the tool itself, and what went wrong is published.

A tool for organising agent work that was not used to organise its own is making
a claim it has not tested.
