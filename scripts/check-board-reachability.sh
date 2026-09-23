#!/usr/bin/env bash
# check-board-reachability.sh — Done-when #3.
#
# Validates that every selected board backend is reachable on this host.
# Markdown and Obsidian need only file tools. Linear needs a Linear MCP server
# or a configured API key, and is refused with a reason naming the missing
# capability when neither is present.
#
# Usage:
#   bash scripts/check-board-reachability.sh FIXTURE_DIR
#   bash scripts/check-board-reachability.sh --docs   # shipped instructions state the rule
#
# A fixture directory holds configuration fragments with `backend:` and
# `available:` lines. Exit 0 when every config is reachable; exit 1 when any
# chosen backend is unreachable, printing the refusal and its reason.
#
# In CI the good directory must pass and a directory containing an unreachable
# Linear choice must fail — the inversion proves the refusal is real.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

reachable() {
  local backend="$1" available="$2"
  case "$backend" in
    markdown|obsidian)
      return 0 ;;
    linear)
      case "$available" in
        *mcp*|*key*) return 0 ;;
        *) return 1 ;;
      esac ;;
    *)
      return 1 ;;
  esac
}

# The shipped instructions must state the reachability limit where the backend
# is chosen, not only in this script.
check_docs() {
  local failed=0 f
  for f in \
    "$REPO_ROOT/board/references/board-adapters.md" \
    "$REPO_ROOT/board/references/adapters/linear.md" \
    "$REPO_ROOT/setup/references/new-project.md"; do
    if ! grep -q "not available in every host" "$f"; then
      echo "FAIL: $f does not state that the external backend is not available in every host." >&2
      failed=1
    fi
  done
  return "$failed"
}

if [ "${1:-}" = "--docs" ]; then
  if check_docs; then
    echo "PASS: shipped instructions state the external-backend reachability limit."
    exit 0
  fi
  exit 1
fi

DIR="${1:?Usage: check-board-reachability.sh FIXTURE_DIR|--docs}"

if [ ! -d "$DIR" ]; then
  echo "FAIL: fixture directory $DIR does not exist." >&2
  exit 1
fi

FAILED=0
for cfg in "$DIR"/*.md; do
  [ -f "$cfg" ] || continue
  backend="$(awk -F': *' '/^backend:/{gsub(/"/,"",$2); print $2; exit}' "$cfg")"
  available="$(awk -F': *' '/^available:/{gsub(/"/,"",$2); print $2; exit}' "$cfg")"
  if reachable "$backend" "$available"; then
    echo "PASS: backend \"$backend\" is reachable ($cfg)."
  else
    echo "REFUSED: backend \"$backend\" ($cfg) requires an MCP server or API key; this host has neither. Choose Markdown or Obsidian." >&2
    FAILED=1
  fi
done

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: every selected backend is reachable on this host."
