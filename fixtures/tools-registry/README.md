# Tools registry fixtures

These fixtures prove `scripts/check-tools-registry.sh` is load-bearing. Each
directory holds one scenario the script must get right.

## `detect/`

`repo/` is a repository that declares dependencies in all four manifest types
and two container image tags. `repo-expected.txt` is the exact inventory the
detector must produce from it. `self-expected.txt` is the inventory the detector
must produce when pointed at this repository — no manifests, no declared
dependencies, because Agent Assemble is Markdown-only.

## `suggestion/`

A request ([request.md](suggestion/request.md)), the project's own constraints
([constraints.md](suggestion/constraints.md)) and every candidate a generic
answer might list ([candidates.md](suggestion/candidates.md)). The script must
return exactly [expected-filtered.md](suggestion/expected-filtered.md): three
permissive compiled clients and one separate-process copyleft tool. The RSAL,
Elastic, over-ceiling and vendor-locked candidates are refused and must not
appear at all.

## `licence-violation/`

A compiled dependency under GPL-3.0. The script must refuse it in
[expected-refusal.txt](licence-violation/expected-refusal.txt), naming the
licence and the `compiled-requires-permissive` rule.

## `container-tag/`

The case this registry exists for. `redis:7-alpine` reads as Alpine, but resolves
to Redis 7.4.0 under RSALv2. The script resolves the tag through
[image-resolution.md](container-tag/image-resolution.md) and refuses it
([expected-decisions.txt](container-tag/expected-decisions.txt)), naming the tag,
the resolved version, the licence and the `never-adopt-gated-licences` rule. The
permissive `postgres:16-alpine` tag is allowed, so a blanket "refuse all alpine
tags" does not pass.
