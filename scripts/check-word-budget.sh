#!/bin/sh
set -eu

LIMIT=200
FAILED=0

# Core SKILL.md files are the always-loaded core in each node directory.
# Reference documents in references/ directories have no ceiling.
FILES=$(find . -name "SKILL.md" ! -path "*/references/*" ! -path "*/.git/*" | sort)

for file in $FILES; do
  words=$(wc -w < "$file" | tr -d '[:space:]')
  if [ "$words" -gt "$LIMIT" ]; then
    echo "FAIL: $file has $words words (ceiling: $LIMIT words)" >&2
    FAILED=1
  fi
done

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: All core SKILL.md files are within the $LIMIT-word budget."
