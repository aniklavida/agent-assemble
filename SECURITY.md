# Security Policy

## Supported Versions

| Version | Supported | Notes |
|---|---|---|
| `develop` / pre-release | Yes | Active development branch receiving security fixes. |
| Untagged past revisions | No | Users should track `develop` or the latest published release. |

---

## Scope

Agent Assemble is Markdown. It ships no executable binary, no server, and no background daemon. That removes typical binary and network daemon attack surfaces and leaves one primary concern.

---

## The Concern That Applies

**An agent reads these files and acts on them.** Instructions in a skill are executed by tools with access to a local filesystem, a shell, and often a network connection. A malicious or compromised instruction poses a real risk equivalent to a malicious build script.

Consequences of this threat model:
- Instructions in this repository must never tell an agent to fetch and execute a remote document (e.g., piping `curl` into `bash`).
- Instructions must never ask an agent to handle a credential, API key, token, or password.
- Pull requests that add or alter instructions are reviewed as executable code, not as descriptive prose.

---

## Reporting a Vulnerability

Report security issues through GitHub's private vulnerability reporting on this repository. Please do not open a public issue for an unpatched vulnerability.

When reporting, include:
- The specific instruction or file involved.
- What the instruction causes an agent to execute on the host machine.
- The host environment and agent application where the behavior was observed.

Maintainers will acknowledge receipt within 72 hours and provide a timeline for assessment and remediation.

---

## What Is Not a Vulnerability

- **An agent ignoring a skill:** No host application guarantees that a skill is loaded or followed. A skill that fires and is ignored is indistinguishable from one that never fired, and this limitation is explicitly published.
- **Uninstructed agent actions:** An agent performing unexpected or harmful actions that no instruction in this repository requested or encouraged.
