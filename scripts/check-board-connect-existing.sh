#!/usr/bin/env bash
# check-board-connect-existing.sh — Done-when #2.
#
# Pre-seeds an existing board (a Markdown card tree and an Obsidian vault) and
# runs the setup detection/connection procedure. Asserts that setup connects to
# the board that is already there — recording existing: true and the right
# backend and root — and does not create a second board beside it.
#
# Usage:
#   bash scripts/check-board-connect-existing.sh             # connect path must hold
#   bash scripts/check-board-connect-existing.sh --self-test # single-board invariant must bite
#
# Exit 0 when both pre-seeded boards are connected to without duplication (or,
# under --self-test, when two board roots are detected). Exit 1 otherwise.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FIXTURES="$REPO_ROOT/fixtures/board-adapters/existing"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# detect_backend REPO
# Prints "<backend>\t<root>\t<existing>". Mirrors the detection order in
# board/references/board-adapters.md Rule 1: config, then Markdown tree, then
# Obsidian vault. Never defaults to Markdown when nothing is found.
detect_backend() {
  local repo="$1" vault rel
  if [ -f "$repo/.agent-assemble/board-config.md" ]; then
    printf 'configured\t.\ttrue\n'
    return 0
  fi
  if [ -d "$repo/board/todo" ] || [ -d "$repo/board/in-progress" ] \
     || [ -d "$repo/board/testing" ] || [ -d "$repo/board/done" ]; then
    printf 'markdown\tboard\ttrue\n'
    return 0
  fi
  vault="$(find "$repo" -maxdepth 3 -type d -name '.obsidian' -print -quit 2>/dev/null || true)"
  if [ -n "$vault" ]; then
    rel="${vault#"$repo"/}"
    printf 'obsidian\t%s\ttrue\n' "$(dirname "$rel")"
    return 0
  fi
  printf 'none\t\tfalse\n'
}

# connect_board REPO BACKEND ROOT — records the connection, creates nothing.
connect_board() {
  local repo="$1" backend="$2" root="$3"
  mkdir -p "$repo/.agent-assemble"
  cat > "$repo/.agent-assemble/board-config.md" <<CFG
backend: "$backend"
root: "$root"
existing: true
CFG
}

# assert_single_board REPO — fails if more than one board root exists, or a
# Markdown tree sits beside an Obsidian vault.
assert_single_board() {
  local repo="$1" markdown_roots vault_roots
  markdown_roots="$(find "$repo" -type d -name todo -path '*/board/*' 2>/dev/null | wc -l | tr -d ' ')"
  vault_roots="$(find "$repo" -maxdepth 3 -type d -name '.obsidian' 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$markdown_roots" -gt 1 ]; then
    echo "FAIL: $repo has $markdown_roots Markdown board roots; expected at most one." >&2
    return 1
  fi
  if [ "$markdown_roots" -ge 1 ] && [ "$vault_roots" -ge 1 ]; then
    echo "FAIL: $repo has both a Markdown board and an Obsidian vault; that is a second source of truth." >&2
    return 1
  fi
  return 0
}

if [ "${1:-}" = "--self-test" ]; then
  repo="$TMP/two-roots"
  mkdir -p "$repo/board/todo" "$repo/other/board/todo"
  if assert_single_board "$repo" 2>/dev/null; then
    echo "FAIL: two board roots were accepted; the single-board invariant is not load-bearing." >&2
    exit 1
  fi
  echo "PASS: self-test — two board roots are detected and refused."
  exit 0
fi

FAILED=0

run_case() {
  local src="$1" label="$2" expect_backend="$3" expect_root="$4"
  local repo="$TMP/$label" backend root existing
  cp -R "$src" "$repo"

  read -r backend root existing <<<"$(detect_backend "$repo")"

  if [ "$existing" != "true" ]; then
    echo "FAIL: [$label] setup did not detect the existing board (existing=$existing)." >&2
    return 1
  fi
  if [ "$backend" != "$expect_backend" ] || [ "$root" != "$expect_root" ]; then
    echo "FAIL: [$label] detected ${backend}/${root}, expected ${expect_backend}/${expect_root}." >&2
    return 1
  fi

  connect_board "$repo" "$backend" "$root"

  if ! grep -q 'existing: true' "$repo/.agent-assemble/board-config.md"; then
    echo "FAIL: [$label] connected config does not record existing: true." >&2
    return 1
  fi
  if ! grep -q "backend: \"$expect_backend\"" "$repo/.agent-assemble/board-config.md"; then
    echo "FAIL: [$label] connected config does not name backend $expect_backend." >&2
    return 1
  fi
  if ! assert_single_board "$repo"; then
    return 1
  fi

  if [ "$expect_backend" = "markdown" ]; then
    [ -f "$repo/board/todo/TASK-OLD-001.md" ] || { echo "FAIL: [$label] pre-seeded card disappeared." >&2; return 1; }
    [ ! -d "$repo/vault" ] || { echo "FAIL: [$label] a second board root appeared." >&2; return 1; }
  else
    [ -f "$repo/vault/Tasks/todo/TASK-VAULT-001.md" ] || { echo "FAIL: [$label] pre-seeded note disappeared." >&2; return 1; }
    [ ! -d "$repo/board" ] || { echo "FAIL: [$label] a parallel board/ tree was created beside the vault." >&2; return 1; }
  fi

  echo "PASS: [$label] connected to the existing $expect_backend board at \"$expect_root\" without duplicating it."
  return 0
}

run_case "$FIXTURES/markdown-board" "markdown-board" "markdown" "board" || FAILED=1
run_case "$FIXTURES/obsidian-vault" "obsidian-vault" "obsidian" "vault" || FAILED=1

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: existing boards are detected and connected to, not duplicated."
