# Board Adapter Fixtures

Fixtures and executable doubles for the three tests that prove the board
contract. The shipped implementation is Markdown instructions in
`board/references/adapters/`; the shell doubles here are test infrastructure that
lets the same operation sequence run against each backend without a network.

## Layout

```
backends/
  markdown.sh          double for adapters/markdown.md
  obsidian.sh          double for adapters/obsidian.md
  linear.sh            local stand-in for the Linear MCP/API transport
  obsidian-broken.sh   bad fixture: Move leaves frontmatter status stale
existing/
  markdown-board/      a card tree that predates setup
  obsidian-vault/      a vault (vault/.obsidian/) that predates setup
reachability/
  reachable-*.md       configs every host can run
  bad/unreachable-linear.md   a Linear choice with no MCP server or API key
```

## The tests

| Done-when | Test | What it proves |
|---|---|---|
| #1 same task, equivalent state | `scripts/check-board-adapters.sh` | Markdown, Obsidian and Linear produce identical contract state for create → move → read → append-log. `--self-test` proves a stale frontmatter move is caught. |
| #2 connect, do not duplicate | `scripts/check-board-connect-existing.sh` | A pre-seeded Markdown tree and Obsidian vault are connected to (`existing: true`); no second board root appears. `--self-test` proves two roots are refused. |
| #3 unreachable backend refused | `scripts/check-board-reachability.sh` | Markdown/Obsidian are always reachable; Linear with no MCP server or API key is refused, naming what is missing. A bad fixture directory must fail. |

## Run

```sh
bash scripts/check-board-adapters.sh
bash scripts/check-board-adapters.sh --self-test
bash scripts/check-board-connect-existing.sh
bash scripts/check-board-connect-existing.sh --self-test
bash scripts/check-board-reachability.sh fixtures/board-adapters/reachability
bash scripts/check-board-reachability.sh --docs
```

A green run means the contract holds for all three backends and the two setup
rules bite. It does not mean a real Linear workspace was contacted: CI has no
key or network, so the Linear double stands in for the transport. Connecting to
a live Linear workspace remains **not verified**.
