# Licence Policy

The policy is fixed for this project. It applies before a tool is chosen, not
after it is merged.

## The three rules

| Boundary | Rule |
|---|---|
| **Compiled into user code** — a library linked into a binary or bundled into a shipped artifact | Permissive only: **MIT, Apache-2.0, BSD**. |
| **Run as a separate process** — a server, a CLI, a container, a daemon | Copyleft is acceptable: GPL, LGPL, AGPL and similar. |
| **Never** — any boundary | **SSPL, BSL, RSAL, Elastic, RPL**, or any licence gated on revenue, headcount, or a hosted-service carve-out. |

The first two rules decide a candidate. The third overrides both: a
revenue-gated licence is refused even when it arrives as a separate process.

## Scope: what counts

- **Transitive dependencies count.** A permissive direct dependency that pulls a
  non-permissive transitive dependency fails the same test as a direct one.
- **Container image tags count.** The tag is not the licence. `redis:7-alpine`
  reads as "Redis 7 on Alpine", and Alpine is fine — but the Redis **version**
  behind the tag is what changed licence. Redis 7.4 moved from BSD-3-Clause to
  RSALv2. Adopting `redis:7-alpine` without resolving the version adopts RSALv2.

An image tag with no digest or version pin can silently move to a new licence on
the next pull. Resolve the tag to a product **and version** before deciding.

## Refusing, and what a refusal must name

A refusal names the component, the licence, and the rule it breaks. It does not
name a "concern" or a "risk"; it states the clause.

```
REFUSE left-pad-plus (compiled; GPL-3.0) — GPL-3.0 is not permissive and the
component is compiled into user code (rule: compiled-requires-permissive).

REFUSE redis:7-alpine (container image; RSALv2) — tag resolves to Redis 7.4.0,
licence RSALv2 is on the never-adopt list (rule: never-adopt-gated-licences).
```

## Where the policy is enforced

The rules are read here, recorded as a decision (see
[registry.md](registry.md)), and enforced by
`scripts/check-tools-registry.sh`. The script carries the same allow and deny
lists so a candidate can be checked before it reaches a manifest.
