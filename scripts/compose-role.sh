#!/bin/sh
# compose-role.sh — concatenate all SKILL.md cores for a composed role.
#
# Walks from the given role directory upward to the repository root,
# collecting every SKILL.md file, and prints the composed result to stdout.
# The order is ancestor-first (top of tree to leaf), which is the order an
# agent reads the composed context.
#
# This is the same traversal as check-composed-budget.sh; compose-role.sh
# prints content rather than word counts.
#
# Usage:
#   scripts/compose-role.sh <role-dir>
#
# Example:
#   scripts/compose-role.sh \
#     employees/software-engineer/backend-developer/nodejs
#
# Exit status:
#   0  files found and printed
#   1  role-dir does not exist or no SKILL.md files were found

set -eu

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <role-dir>" >&2
  exit 1
fi

ROLE_DIR="$1"

if [ ! -d "$ROLE_DIR" ]; then
  echo "FAIL: $ROLE_DIR is not a directory." >&2
  exit 1
fi

ROLE_ABS=$(cd "$ROLE_DIR" && pwd)
REPO_ROOT=$(pwd)

# Collect SKILL.md paths deepest-first, then reverse for ancestor-first output.
FILES=""
DIR="$ROLE_ABS"
while true; do
  candidate="$DIR/SKILL.md"
  if [ -f "$candidate" ]; then
    FILES="${candidate}
${FILES}"
  fi
  if [ "$DIR" = "$REPO_ROOT" ] || [ "$DIR" = "/" ]; then
    break
  fi
  DIR=$(dirname "$DIR")
done

if [ -z "$FILES" ]; then
  echo "FAIL: No SKILL.md files found from $ROLE_DIR up to $REPO_ROOT." >&2
  exit 1
fi

# Print ancestor-first (FILES is already in that order due to prepend above)
IFS="
"
for f in $FILES; do
  [ -z "$f" ] && continue
  rel=$(printf '%s' "$f" | sed "s|^${REPO_ROOT}/||")
  printf '# === %s ===\n\n' "$rel"
  cat "$f"
  printf '\n'
done
unset IFS
