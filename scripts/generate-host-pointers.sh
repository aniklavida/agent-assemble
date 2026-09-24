#!/usr/bin/env bash
# generate-host-pointers.sh — produce thin per-host pointer files from one source.
#
# Generates or verifies thin per-host pointer files that reference AGENTS.md,
# ensuring each supported agent tool receives only a thin pointer rather than
# a duplicated copy of instruction content.
#
# Usage:
#   scripts/generate-host-pointers.sh [TARGET_DIR]
#   scripts/generate-host-pointers.sh --check [TARGET_DIR]
#
# Arguments:
#   TARGET_DIR    Directory containing AGENTS.md (default: current working directory)
#   --check       Verify that existing pointer files match generated output without writing
#
# Exit status:
#   0  pointers generated (or verified under --check)
#   1  AGENTS.md missing, or pointers drift under --check

set -euo pipefail

CHECK_MODE=0
if [ "${1:-}" = "--check" ]; then
  CHECK_MODE=1
  shift
fi

TARGET_DIR="${1:-.}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "FAIL: Target directory \"$TARGET_DIR\" does not exist." >&2
  exit 1
fi

SOURCE_FILE="$TARGET_DIR/AGENTS.md"
if [ ! -f "$SOURCE_FILE" ]; then
  echo "FAIL: Canonical source file AGENTS.md missing in \"$TARGET_DIR\"." >&2
  exit 1
fi

claude_content() {
  cat <<'EOF'
# Claude Code

The canonical guide is **`AGENTS.md`** (tool-neutral). It is imported below; edit conventions there, not here.

@AGENTS.md
EOF
}

gemini_content() {
  cat <<'EOF'
# Gemini

The canonical guide is **`AGENTS.md`** (tool-neutral). Read it before making changes; edit conventions there, not here.
EOF
}

CLAUDE_FILE="$TARGET_DIR/CLAUDE.md"
GEMINI_FILE="$TARGET_DIR/GEMINI.md"

if [ "$CHECK_MODE" -eq 1 ]; then
  FAILED=0
  if [ ! -f "$CLAUDE_FILE" ]; then
    echo "FAIL: Missing pointer file: $CLAUDE_FILE" >&2
    FAILED=1
  elif ! diff -u "$CLAUDE_FILE" <(claude_content) >/dev/null 2>&1; then
    echo "FAIL: Pointer file $CLAUDE_FILE differs from generated output." >&2
    diff -u "$CLAUDE_FILE" <(claude_content) >&2 || true
    FAILED=1
  fi

  if [ ! -f "$GEMINI_FILE" ]; then
    echo "FAIL: Missing pointer file: $GEMINI_FILE" >&2
    FAILED=1
  elif ! diff -u "$GEMINI_FILE" <(gemini_content) >/dev/null 2>&1; then
    echo "FAIL: Pointer file $GEMINI_FILE differs from generated output." >&2
    diff -u "$GEMINI_FILE" <(gemini_content) >&2 || true
    FAILED=1
  fi

  if [ "$FAILED" -ne 0 ]; then
    exit 1
  fi
  echo "PASS: All host pointers match generated output from AGENTS.md."
  exit 0
fi

# Write pointers
claude_content > "$CLAUDE_FILE"
gemini_content > "$GEMINI_FILE"

echo "Generated thin host pointers in $TARGET_DIR:"
echo "  - $CLAUDE_FILE (Claude Code)"
echo "  - $GEMINI_FILE (Gemini CLI)"
