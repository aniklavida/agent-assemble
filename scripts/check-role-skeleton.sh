#!/bin/sh
# check-role-skeleton.sh — verify that role files contain all required sections.
#
# A role file is any SKILL.md found under employees/ or .agent-assemble/roles/.
# Required sections (checked by heading presence):
#   ## Purpose
#   ## Preconditions
#   ## Steps
#   ## Completion signal
#   ## Failure handling
#
# Usage:
#   scripts/check-role-skeleton.sh                    # sweeps employees/ and .agent-assemble/roles/
#   scripts/check-role-skeleton.sh <dir>              # sweeps the given directory
#
# Exit status:
#   0  all checked files pass
#   1  at least one file is missing a required section

set -eu

TARGET_DIR="${1:-}"
FAILED=0

check_file() {
  file="$1"

  missing=""
  while IFS= read -r section; do
    if ! grep -qF "$section" "$file"; then
      missing="${missing}  missing: ${section}\n"
    fi
  done <<SECTIONS
## Purpose
## Preconditions
## Steps
## Completion signal
## Failure handling
SECTIONS

  if [ -n "$missing" ]; then
    printf "FAIL: %s — required section(s) absent:\n%b" "$file" "$missing" >&2
    FAILED=1
  fi
}

if [ -n "$TARGET_DIR" ]; then
  FILES=$(find "$TARGET_DIR" -name "SKILL.md" ! -path "*/.git/*" | sort)
else
  # Default sweep: employees/ and .agent-assemble/roles/ if they exist
  FILES=""
  for dir in employees .agent-assemble/roles; do
    if [ -d "$dir" ]; then
      found=$(find "$dir" -name "SKILL.md" ! -path "*/.git/*" | sort)
      FILES="${FILES}${found}
"
    fi
  done
fi

if [ -z "$FILES" ]; then
  echo "PASS: No role files found to check."
  exit 0
fi

for file in $FILES; do
  [ -z "$file" ] && continue
  check_file "$file"
done

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: All role files contain the required skeleton sections."
