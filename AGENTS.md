# Agent Assemble — contributor guidelines

These apply to any agent working in this repository, and to any human reviewing
what an agent produced.

## What this project is

A skill that gives an agent a role, a place in a process, and a memory. It is
Markdown. There is no server, no runtime and no binary, and adding one is a
design change rather than an implementation detail.

## The rule that governs content

**Would a good model have done this anyway?**

If yes, the node does not belong here. The model's general knowledge is already
excellent; what is missing is always local — this team's conventions, this
project's decisions, this organisation's definition of done.

## Writing a node

- A small always-loaded core and references for everything else. The ceiling
  is planned rather than enforced — see the word budget section of
  `CONTRIBUTING.md` for the measured counts and why there is no number yet.
- No instruction may appear in two files. If it seems to need to, one of them
  should point at the other.
- No node restates its parent. If it does, the inheritance is decorative and
  the structure is wrong.

## Claims

Use exactly one of: **implemented and tested**, **experimental**, **planned**,
**unsupported**. Never describe something as working because it should work.

If you write a test, break the code it protects and confirm that named test
fails. **If it still passes, that is a finding, not a success** — work out
which of three things happened:

1. a second, independent safeguard is also enforcing it;
2. your edit did not apply, or did not compile — a build failure proves nothing;
3. the test never reaches the code you broke, and is therefore worthless.

Do not report something as verified because a sabotage run passed.

## Worked examples

If an example is included to demonstrate a claim, check that it demonstrates
that claim. An example illustrating "these two things differ" with two identical
values proves the opposite of its point.

## Before committing

- No absolute machine paths, no credentials, no unresolved merge markers.
- Every required document present and non-empty.
- Commit messages describe what changed and why, in prose.
