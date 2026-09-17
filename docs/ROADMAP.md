# Roadmap

**Skeleton before content.** A tree of empty nodes that hands off correctly is
worth more than fifty well-written role files that never reach each other.

Nothing below is implemented.

## 1 · Skeleton

Workflow, board and log. **No role knowledge at all** — the roles are named
placeholders that do nothing but hand over.

*Done when:* one small task travels the full relay in a clean directory and
genuinely produces a card and a log entry, and a second agent session with no
memory of the first reads them and correctly states what is done and what
remains.

That last sentence is the product. Everything else is plumbing.

## 2 · Setup interview

New project and existing project. Detect before asking; ask once; write both the
decided and the deferred list into documentation.

*Done when:* a real existing repository is read and summarised accurately, and
re-running setup in a configured project asks nothing.

## 3 · Board adapters

Markdown, Obsidian and one external tool, behind one thin contract. Connect to an
existing board rather than creating a second.

*Done when:* the same task completes against each backend, and choosing a
backend the current host cannot reach is refused at setup with the reason.

## 4 · One employee, end to end

A single vertical slice of role knowledge, with enforced budget and real
inheritance.

*Done when:* the composed role loads within budget, no sentence appears at two
levels, and removing a parent level provably changes the child's behaviour.

## 5 · Principles

The three modes wired to their three places, chosen per project.

*Done when:* a project with a practice selected has a card returned by the gate;
the same project without it does not, and the gate does not complain either.

## 6 · The roles that make it a relay

Business Analyst, SQA and Project Manager. Until these exist, the workflow is one
agent talking to itself.

*Done when:* a vague request produces clarifying questions before any code, and
the tester returns a card for a real gap the developer's own tests missed.

## 7 · Perspectives

Security, Performance, Accessibility, Researcher. They ask; they never block.

## 8 · Tools

Registry, decision records, licence policy, constraint-filtered suggestions.

## 9 · Documentation drift

When the plan changes, find the cards that are now wrong. Surface them; never
rewrite silently.

## 10 · Depth

More languages and frameworks. This is contribution work rather than design work,
and it comes last on purpose.

## v1.0

When the acceptance criteria in the [release checklist](RELEASE_CHECKLIST.md)
pass on a clean machine, and the release notes state plainly what remains
unverified.
