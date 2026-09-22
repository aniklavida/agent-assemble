#!/bin/sh
# check-composed-budget.sh — measure the total word count of a composed role.
#
# A composed role is all SKILL.md cores loaded together: the role itself and
# every ancestor up the directory tree. This script walks from the given
# role directory upward, collecting every SKILL.md it finds, and reports the
# sum. If the sum exceeds the ceiling it exits non-zero.
#
# Usage:
#   scripts/check-composed-budget.sh <role-dir> [ceiling]
#
#   role-dir  path to the deepest role in the composition
#             e.g. employees/software-engineer/backend-developer/nodejs
#   ceiling   optional word ceiling (default: 600)
#
# Exit status:
#   0  composed budget is within the ceiling
#   1  composed budget exceeds the ceiling, or role-dir does not exist
#
# Example — measure the three-level Node.js composition:
#   scripts/check-composed-budget.sh \
#     employees/software-engineer/backend-developer/nodejs
#
# The script prints each file it finds and the running total, then the
# final sum compared with the ceiling.

set -eu

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <role-dir> [ceiling]" >&2
  exit 1
fi

ROLE_DIR="$1"
CEILING="${2:-600}"

if [ ! -d "$ROLE_DIR" ]; then
  echo "FAIL: $ROLE_DIR is not a directory." >&2
  exit 1
fi

# Resolve to an absolute path so the upward walk terminates reliably.
ROLE_ABS=$(cd "$ROLE_DIR" && pwd)
REPO_ROOT=$(pwd)

# Walk upward from ROLE_ABS toward REPO_ROOT, collecting SKILL.md files.
# We stop when we reach the repository root (or the filesystem root).
# Files are collected in deepest-first order; we reverse for display.

FILES=""
DIR="$ROLE_ABS"
while true; do
  candidate="$DIR/SKILL.md"
  if [ -f "$candidate" ]; then
    FILES="${candidate}
${FILES}"
  fi
  # Stop if we have reached or passed the repository root.
  if [ "$DIR" = "$REPO_ROOT" ] || [ "$DIR" = "/" ]; then
    break
  fi
  DIR=$(dirname "$DIR")
done

if [ -z "$FILES" ]; then
  echo "FAIL: No SKILL.md files found from $ROLE_DIR up to $REPO_ROOT." >&2
  exit 1
fi

TOTAL=0
printf "Composed role: %s\n" "$ROLE_DIR"
printf "%-60s  %s\n" "File" "Words"
printf "%-60s  %s\n" "----" "-----"

IFS="
"
for f in $FILES; do
  [ -z "$f" ] && continue
  w=$(wc -w < "$f" | tr -d '[:space:]')
  TOTAL=$((TOTAL + w))
  # Print relative path for readability
  rel=$(printf '%s' "$f" | sed "s|^${REPO_ROOT}/||")
  printf "%-60s  %d\n" "$rel" "$w"
done
unset IFS

printf "%-60s  %s\n" "----" "-----"
printf "%-60s  %d\n" "TOTAL" "$TOTAL"
printf "Ceiling: %d\n" "$CEILING"

if [ "$TOTAL" -gt "$CEILING" ]; then
  echo "FAIL: Composed budget of $TOTAL words exceeds ceiling of $CEILING." >&2
  exit 1
fi

echo "PASS: Composed budget of $TOTAL words is within the ceiling of $CEILING."
