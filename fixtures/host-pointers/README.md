# Multi-Host Pointer Fixtures

Fixtures for verifying thin multi-host pointer resolution, duplicate instruction guards, and host-support matrix honesty.

## Directory structure

```
fixtures/host-pointers/
├── good/                Valid canonical AGENTS.md, thin CLAUDE.md, GEMINI.md, CODEX.md symlink, and honest matrix
├── bad-duplicate/       CLAUDE.md contains verbatim instruction text duplicated from AGENTS.md
└── bad-broken/          CLAUDE.md references a non-existent file target (@NONEXISTENT.md)
```

## Assertions proven by these fixtures

1. **Good sweep (`fixtures/host-pointers/good`):**
   `scripts/check-host-pointers.sh fixtures/host-pointers/good` exits 0. Proves that valid thin pointers, resolved symlinks, and honest matrix states pass verification.

2. **Duplicate sweep (`fixtures/host-pointers/bad-duplicate`):**
   `scripts/check-host-pointers.sh fixtures/host-pointers/bad-duplicate` exits 1 and explicitly names both `AGENTS.md` and `CLAUDE.md`.

3. **Broken pointer sweep (`fixtures/host-pointers/bad-broken`):**
   `scripts/check-host-pointers.sh fixtures/host-pointers/bad-broken` exits 1 and explicitly names host `Claude Code`.
