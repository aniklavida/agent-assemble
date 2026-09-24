# Project Configuration

Updated: 2026-09-24

## The Project

**Name:** Agent Assemble
**What is being built:** A Markdown skill that gives a coding agent a role, a place in a process, and a memory that survives the session; for teams who want agent work to hand off and leave a trail instead of restarting each session.
**Core problem:** A capable model has no role, no handoff, and no memory, and none of the conventions that are local to a team.
**Out of scope:** a server, runtime or binary; every language and framework; non-software workflows; generating procedure text.
**Success looks like:** a stranger can install the skill from the README and carry one real card end to end, and the project has used the skill on itself with the results published.

## The Way of Working

**Stack:** Markdown · POSIX shell (bash) · GitHub Actions (detected)
**Principles:**
  - No sentence in two files — prescriptive
  - Every node must justify itself against "would a good model have done this anyway?" — prescriptive
  - Claims use one of implemented and tested / experimental / planned / unsupported — prescriptive
  - A test is only evidence if a sabotage run makes it fail — prescriptive
**Definition of done:** the card's acceptance criteria are met, each has a named test and a named mutation with a resolved sabotage outcome, and the validation scripts pass in CI.
**Default relay depth:** Full for documentation and structure changes; Direct for typos (confirmed)
**Active perspectives:** Researcher

## The Plumbing

**Board backend:** Markdown (existing: the `board/` tree already carried the contract and adapter pages)
**Board root:** board/
**Board connected to existing:** true — connected to the existing board tree, not a second one
**Board name:** Agent Assemble
**Branch base:** develop
**Branch prefix:** none
**PR target:** develop
**Log path:** log/LOG.md

## Detection Notes

Stack detected from `.github/workflows/validate.yml`, `scripts/*.sh` and the Markdown tree (detected).
Board connected to the existing contract and adapter pages (detected).
Principles confirmed from `AGENTS.md` (confirmed).
Active perspective (Researcher) confirmed from `docs/SPEC.md` founding incident (confirmed).
