# Security policy

## Scope

Agent Assemble is Markdown. It ships no executable code, no server and no
runtime. That removes most of the usual attack surface and leaves one real
concern.

## The concern that applies

**An agent reads these files and acts on them.** Instructions in a skill are
executed by something with access to a filesystem, a shell and often a network.
A malicious or altered instruction is therefore a real risk, in the same way a
malicious build script is.

Consequences of that:

- Instructions in this repository must never tell an agent to fetch and execute
  a remote document.
- Instructions must never ask an agent to handle a credential, a token or a
  password.
- A pull request that adds an instruction is reviewed as code, not as prose.

CI enforces two of those mechanically: it rejects any instruction that pipes a
download into a shell, and it rejects common credential patterns
(`ghp_…`, `github_pat_…`, `sk-…`, `ntn_…`). The third — reviewing an instruction
as code — is a human decision, and the reason this file exists.

## Supported versions

Nothing has been released. There are no supported version branches. The
`develop` branch is the only surface, and fixes land there first.

## Reporting

Report a security issue through GitHub's private vulnerability reporting on this
repository. Please do not open a public issue for something that could be
exploited before it is fixed.

Include what the instruction causes an agent to do, and which host you observed
it in if that matters.

## Our response

We aim to acknowledge a report within seven days and to agree a fix timeline
with the reporter. This is best effort, not a service-level guarantee: the
project has no funded response team, and saying otherwise would be a claim the
repository cannot support. We will credit a reporter who wants credit, and will
coordinate disclosure with them before publishing.

## What is not a vulnerability

- An agent ignoring a skill. No host guarantees a skill is read or followed, and
  this project says so plainly rather than claiming otherwise.
- An agent doing something harmful that no instruction here asked for.
