# Registry and Decision Records

The registry records two different things, and does not mix them: **what the
repository actually declares** and **what was chosen or rejected, and why**.

## The detected inventory

Detection reads the root manifests and container tags that are present:

| Manifest | What is read |
|---|---|
| `package.json` | `dependencies` and `devDependencies` |
| `go.mod` | `require` entries, block and single-line |
| `requirements.txt` | one requirement per line |
| `Cargo.toml` | `[dependencies]` and `[dev-dependencies]` |
| `docker-compose.yml`, `Dockerfile` | `image:` and `FROM` tags |

Run it with:

```sh
scripts/check-tools-registry.sh --detect .
```

Detection always exits 0. It prints a candidate inventory, and the last line is
the point: **"Detection is a candidate list, not an adoption. Confirm each
before use."** A manifest entry is a fact about the repository; it is not a
decision this project made.

The detected inventory is recorded in `documentation/`, beside the decisions it
informs. It carries the resolved licence, not just the name.

## Rejected and chosen tools

A tool decision is the same shape as every other decision in this project — the
decided / deferred table from
`documentation/references/decided-deferred-template.md`. It is not a notes
field. Each row is a complete sentence: **chose X over Y, because Z.**

```markdown
| ID | Topic | Decision | Rationale |
|---|---|---|---|
| TOOL-001 | HTTP client | Chose `undici` over `axios` | Node core team maintains `undici`; it has no transitive tree to audit; Apache-2.0 |
| TOOL-002 | Cache | Rejected `redis:7-alpine` | Tag resolves to Redis 7.4.0, relicensed RSALv2 — never-adopt licence |
```

The four columns are load-bearing:

- **ID** — stable reference from the card that made the decision.
- **Topic** — the slot being filled (HTTP client, cache, queue).
- **Decision** — the choice, including what it was chosen **over**.
- **Rationale** — the constraint that decided it: licence, cost, vendor lock,
  or a project-specific fact a model could not know.

A row without a rationale is not a decision record. "We use X" is inventory, not
a decision; it belongs in the detected table above.

## Constraints are records too

Licence policy, cost ceiling and vendor-lock rules live in one place —
[constraints.md](constraints.md) — and every suggestion is filtered through
them. They are the project's, not the model's, and are recorded rather than
assumed.
