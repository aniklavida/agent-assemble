# Dogfood run — Agent Assemble on Agent Assemble

A tool for organising agent work that has never organised its own is making an
untested claim about itself. This report covers the first genuine run: card
`TASK-013` carried through this repository's own board, log, roles and sabotage
discipline, with the friction published alongside the results.

The run used the mechanism that actually exists here — a file-based Markdown
board ([`board/`](../board/SKILL.md)), an append-only log
([`log/LOG.md`](../log/LOG.md)), the relay roles
([`workflow/references/relay-roles.md`](../workflow/references/relay-roles.md)),
and per-criterion sabotage evidence
([`board/references/sabotage-evidence-guide.md`](../board/references/sabotage-evidence-guide.md)).
There is no CLI, server or MCP process to drive, by design.

## What was actually done

The card is [`board/done/TASK-013.md`](../board/done/TASK-013.md). Its full trail
is in [`log/LOG.md`](../log/LOG.md), and `scripts/check-log-sequence.sh board`
verifies it on every change.

1. **Setup (PM/BA).** The existing-project path of
   [`setup/SKILL.md`](../setup/SKILL.md) was followed by hand: the stack and the
   existing board tree were read from the repository, `.agent-assemble/project.md`,
   `.agent-assemble/board-config.md` and
   `documentation/decisions/decided-deferred.md` were written once. The board was
   connected to, not recreated — `existing: true`.
2. **Sizing (PM).** The request was scored Full: public documentation is
   cross-cutting and the self-hosting run is a change in how the project carries
   its own work. `REQUEST_SIZED` was logged.
3. **Card creation (BA).** Eight acceptance criteria were written into
   `board/todo/TASK-013.md`; `CARD_CREATED` was logged.
4. **Implementation (Employee).** The card was moved to `board/in-progress/`, the
   documentation and the invariant check were written, and `WORK_STARTED` was
   logged.
5. **Verification (SQA).** Each criterion was tested, then sabotaged: the test was
   named, a mutation applied, the outcome recorded, and the mutation reverted.
   `VERIFICATION_PASSED` was logged.
6. **Closure (PM).** The trail was audited with the shipped check, the card moved
   to `board/done/`, and `CARD_CLOSED` was logged.

## What went right

- **The board is legible to a stranger.** Reading `board/done/TASK-013.md` and
  `log/LOG.md` alone gives what was requested, what was done, who did it, and what
  evidence was produced. No conversational context is needed.
- **The sabotage rule did real work.** Writing the acceptance criteria first, then
  having to name a test and a mutation for each, is what forced
  `scripts/check-public-docs.sh` to exist. Without the rule the documentation
  requirements would have been assertions in prose.
- **The log is a by-product, not a step.** Appending a row takes seconds and is
  the same action as the move; it was never a separate task to remember.

## What went wrong — observed friction

These are the findings, not the sales pitch.

1. **There is no transaction, and a real move proved it.** `Move Card` is a
   filesystem move plus a log row. In a Git repository the card is a new,
   untracked file, so `git mv` refuses it — the operator must fall back to a plain
   filesystem move and stage the result separately. The mechanism has no atomic
   boundary; a crash between the move and the log row leaves an invalid handoff
   that the next role is supposed to reject. The run did not crash, but nothing
   prevents it.

2. **The log check is blind while work is in progress.** `check-log-sequence.sh`
   only inspects cards whose `status` is `done`. During the entire run, a broken
   or missing trail would have gone unnoticed until closure. The check proves a
   finished trail; it cannot warn an in-flight one.

3. **A rule retroactively invalidated an existing document.** The claim-and-limit
   paragraph rule (enforced by `scripts/check-public-docs.sh`) caught
   `docs/SPEC.md`, which had stated the value proposition and its limit in
   separate paragraphs since before the rule existed. The rule was right; the
   document had to be corrected. This is documentation drift found by a check
   rather than by reading, which is the point — and also a reminder that adding a
   rule can break documents written under the old one.

4. **A sabotage run passed for the wrong reason, and the first one did.** The
   authoring-guide check originally searched for the words "Append Log" anywhere
   in `docs/AUTHORING.md`. The first mutation renamed one of two mentions and the
   test stayed green; the tempting reading was to record a pass. The correct
   reading was that the *mutation had not landed*, and on inspection the check was
   also too weak — a plain-text mention in surrounding prose satisfied it, so it
   proved nothing. The check was tightened to require the operation as a defined
   term, and the mutation was re-run until the named test failed. This is the
   three-cause rule from
   [`board/references/sabotage-evidence-guide.md`](../board/references/sabotage-evidence-guide.md)
   doing its job under real conditions, and it is the most useful thing the run
   produced: the discipline caught its own author.

5. **Sabotage evidence for prose is bespoke tooling.** For a code criterion a
   mutation is an inverted operator. For a documentation criterion there is
   nothing to invert, so proving the criterion can fail meant writing a structural
   checker. Where a documentation requirement has no checker, its "evidence"
   degrades to self-reporting. This run wrote one checker; it did not solve the
   general case.

6. **One agent played every role.** The relay's value is that SQA is a different
   party from the Employee. In this run the same session wrote the work and then
   verified it, changing hats between steps. The card records a clean separation
   of *steps*, and the evidence is real and checkable, but it is not an
   independent verifier. That is a limit of a single-session dogfood run and is
   not overcome anywhere in this repository.

7. **The mechanical no-reference check is shallow.** `scripts/check-public-docs.sh`
   can refuse an external repository URL in a public document. It cannot detect a
   prior-art project named in prose with no URL. The check reduces the risk; it
   does not close it. The honest statement is "no public document names a
   reference project, and a URL would be caught", not "the project is
   mechanically proven free of named prior art".

8. **The host stayed silent, exactly as documented.** Nothing in the run reported
   whether an agent host loaded or followed the instructions. The limit the
   README publishes is not a hedge; it was the observed condition. Nothing here
   can claim otherwise.

9. **A clean checkout had one board column and not the other three.** Git does
   not track empty directories, so the columns not needed for the committed card
   — `todo/`, `in-progress/` and `testing/` — did not exist on a fresh clone,
   even though the adapter page and the workflow describe a four-column tree. The
   next session to pick up a card would have had to recreate directories the
   project said already existed. It was fixed by committing the column skeleton
   (`.gitkeep` in each). This was found only because the five-minute start was run
   on a real clone instead of being assumed, which is the clearest argument in
   this run for doing that.

## What the run used, precisely

- Board: `board/done/TASK-013.md`, moved through
  `board/todo/` → `board/in-progress/` → `board/testing/` → `board/done/`.
- Log: seven events in `log/LOG.md`, verified by
  `scripts/check-log-sequence.sh board`.
- Evidence: eight criterion blocks, each with a named test and a mutation,
  verified by `scripts/check-evidence.sh board`.
- Setup: `.agent-assemble/project.md`, `.agent-assemble/board-config.md`,
  `documentation/decisions/decided-deferred.md`.
- Role instructions: [`employees/project-manager/SKILL.md`](../employees/project-manager/SKILL.md),
  [`employees/business-analyst/SKILL.md`](../employees/business-analyst/SKILL.md),
  [`employees/software-engineer/SKILL.md`](../employees/software-engineer/SKILL.md),
  [`employees/sqa/SKILL.md`](../employees/sqa/SKILL.md).
