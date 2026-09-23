#!/usr/bin/env bash
# check-board-adapters.sh — Done-when #1.
#
# Runs the same operation sequence (Create Card -> Move Card -> Read Card ->
# Append Log) against each documented backend and asserts the resulting
# contract state is equivalent. Markdown and Obsidian run against real files;
# Linear runs against fixtures/board-adapters/backends/linear.sh, a local
# stand-in for the MCP/API transport, because CI has no network connection or
# API key. The stand-in implements the same four operations the Linear adapter
# page prescribes.
#
# It also asserts each adapter page ships and names all four operations, so a
# deleted or truncated page fails the check.
#
# Usage:
#   bash scripts/check-board-adapters.sh             # equivalence must hold
#   bash scripts/check-board-adapters.sh --self-test # broken double must be caught
#
# Exit 0 when every backend produces the expected state (or, under --self-test,
# when a deliberately broken backend is caught). Exit 1 otherwise.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BACKENDS_DIR="$REPO_ROOT/fixtures/board-adapters/backends"
ADAPTERS_DIR="$REPO_ROOT/board/references/adapters"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

expected() {
  cat <<'EOF'
id=TASK-ADP-001
title=Adapter equivalence probe
status=in-progress
assigned_role=Employee
body=Probe completes
log:
WORK_STARTED
EOF
}

# run_sequence BACKEND_FILE ROOT
# Sources one backend double and drives the contract sequence. Sourcing happens
# in a subshell at the call site so the doubles' identical function names do not
# collide.
run_sequence() {
  local backend_file="$1" root="$2"
  # shellcheck disable=SC1090
  . "$backend_file"
  board_create "$root" "TASK-ADP-001" "Adapter equivalence probe"
  board_move "$root" "TASK-ADP-001" "in-progress" "Employee"
  board_read "$root" "TASK-ADP-001"
  printf 'log:\n'
  board_append_log "$root" "TASK-ADP-001" "WORK_STARTED" "Employee" "Probe acquired" "in-progress (Employee)"
  board_read_log "$root" "TASK-ADP-001"
}

check_equivalent() {
  local backend_file="$1" label="$2" root
  root="$TMP/$label"
  mkdir -p "$root"
  ( run_sequence "$backend_file" "$root" ) > "$TMP/$label.out"
  if ! diff -u <(expected) "$TMP/$label.out" > "$TMP/$label.diff"; then
    echo "FAIL: $label backend state is not equivalent to the contract expectation." >&2
    cat "$TMP/$label.diff" >&2
    return 1
  fi
  echo "PASS: $label backend produced the expected contract state."
  return 0
}

if [ "${1:-}" = "--self-test" ]; then
  if check_equivalent "$BACKENDS_DIR/obsidian-broken.sh" "obsidian-broken" 2>/dev/null; then
    echo "FAIL: the broken Obsidian double was accepted; the equivalence check is not load-bearing." >&2
    exit 1
  fi
  echo "PASS: self-test — equivalence check detects a backend that leaves frontmatter stale on move."
  exit 0
fi

FAILED=0
check_equivalent "$BACKENDS_DIR/markdown.sh" "markdown" || FAILED=1
check_equivalent "$BACKENDS_DIR/obsidian.sh" "obsidian" || FAILED=1
check_equivalent "$BACKENDS_DIR/linear.sh" "linear" || FAILED=1

# Each adapter page must ship and name all four contract operations.
for page in markdown obsidian linear; do
  page_file="$ADAPTERS_DIR/$page.md"
  if [ ! -s "$page_file" ]; then
    echo "FAIL: missing or empty adapter page $page_file" >&2
    FAILED=1
    continue
  fi
  for op in "Create Card" "Move Card" "Read Card" "Append Log"; do
    if ! grep -q "$op" "$page_file"; then
      echo "FAIL: $page_file does not document the \"$op\" operation." >&2
      FAILED=1
    fi
  done
done

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: Markdown, Obsidian and Linear produce equivalent contract state."
