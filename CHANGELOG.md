# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses
[semantic versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added — written, not yet released

Everything below exists in the repository. None of it has been tagged or
published as a release, so it is listed here rather than under a version.

- **Specification** describing the seven parts: employees, principles, tools,
  documentation, workflow, board and log.
- **Architecture** covering the context budget, node splitting and role
  selection.
- **Roadmap** — skeleton before content.
- **Release checklist** for v1.0.
- **Board adapters** behind one thin contract — create a card, move a card, read
  a card, append to the log — with a page of instructions per backend: Markdown,
  Obsidian and Linear. Setup connects to an existing board rather than creating a
  second, and refuses a backend the host cannot reach, naming what is missing.
- **Verification scripts** proving the three backends produce equivalent state,
  that an existing board is connected to and not duplicated, and that an
  unreachable backend is refused at setup.
- **Tools registry** — detection of a repository's declared dependencies from its
  manifests, decision records for chosen and rejected tools, a fixed licence
  policy (compiled → permissive; separate process → copyleft allowed; never
  SSPL, BSL, RSAL, Elastic, RPL or gated licences), and suggestions filtered
  through the project's own constraints. Enforced by
  `scripts/check-tools-registry.sh`, which proves detection, filtering, refusal
  and the `redis:7-alpine` → RSALv2 container-tag case.

The repository is no longer specification-only: role, board, log, workflow and
setup instructions exist. None of it has been released, and no live external
board connection has been verified.

[Unreleased]: https://github.com/aniklavida/agent-assemble/commits/main
