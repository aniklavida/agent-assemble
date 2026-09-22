#!/bin/sh
# check-duplicate-sentences.sh — detect exact duplicate sentences across role cores.
#
# Scans the SKILL.md files under the given directories and reports any sentence
# that appears verbatim in more than one distinct file. An instruction that
# appears in two files simultaneously violates the "no instruction in two files"
# rule.
#
# A "sentence" is a non-blank line that is not a Markdown structural element
# (heading, horizontal rule, fenced code block opener, or status badge).
# This is exact string equality only — no semantic similarity.
#
# Usage:
#   scripts/check-duplicate-sentences.sh <dir> [<dir> ...]
#
#   Pass one or more directories. All SKILL.md files found under those
#   directories (excluding references/) are checked against each other.
#   With no arguments, defaults to employees/.
#
# Exit status:
#   0  no cross-file duplicates found
#   1  at least one sentence appears verbatim in two or more distinct files
#
# The fixture at fixtures/duplicate-sentences/bad contains a deliberate
# duplicate that must cause this script to exit 1.

set -eu

if [ "$#" -eq 0 ]; then
  set -- employees
fi

FILES=""
for dir in "$@"; do
  if [ -d "$dir" ]; then
    found=$(find "$dir" -name "SKILL.md" ! -path "*/references/*" ! -path "*/.git/*" | sort)
    FILES="${FILES}${found}
"
  fi
done

FILES_CLEAN=$(printf '%s' "$FILES" | grep -v '^$' || true)

if [ -z "$FILES_CLEAN" ]; then
  echo "PASS: No SKILL.md files found to check."
  exit 0
fi

# Build a temp directory
TMPDIR_WORK=$(mktemp -d)
SENTENCES_FILE="$TMPDIR_WORK/sentences.txt"
: > "$SENTENCES_FILE"

# Extract content lines from each file, write "sentence<TAB>filepath"
IFS="
"
for f in $FILES_CLEAN; do
  [ -z "$f" ] && continue
  [ ! -f "$f" ] && continue
  while IFS= read -r line; do
    # Skip blank lines
    [ -z "$line" ] && continue
    # Trim leading whitespace for comparison
    trimmed=$(printf '%s' "$line" | sed 's/^[[:space:]]*//')
    [ -z "$trimmed" ] && continue
    # Skip Markdown structural lines
    case "$trimmed" in
      "#"*) continue ;;        # headings
      "---"*) continue ;;      # horizontal rules
      "\`\`\`"*) continue ;;   # fenced code blocks
      "**Status:"*) continue ;; # status badge
      "| "*) continue ;;       # table rows
      "Inherits"*) continue ;; # inheritance markers (common intentional phrase)
    esac
    # Strip ordered-list prefixes ("1. ", "2. ") and unordered markers ("- ", "* ")
    # so the same sentence at different list positions is still detected.
    normalized=$(printf '%s' "$trimmed" | sed 's/^[0-9][0-9]*\.[[:space:]]*//' | sed 's/^[-*][[:space:]]*//')
    [ -z "$normalized" ] && continue
    # Only keep lines with at least 20 characters to avoid trivial fragments
    len=$(printf '%s' "$normalized" | wc -c | tr -d '[:space:]')
    if [ "$len" -lt 20 ]; then
      continue
    fi
    printf '%s\t%s\n' "$normalized" "$f" >> "$SENTENCES_FILE"
  done < "$f"
done
unset IFS

# Sort by sentence text, then use awk to detect the same sentence in two
# different files. We collect: for each unique sentence, the set of files.
# If a sentence appears in 2+ distinct files, it's a duplicate.

FAILED=0

# Group by sentence, collect unique files per sentence
awk -F'\t' '
{
  sentence = $1
  file = $2
  if (!(sentence in files)) {
    files[sentence] = file
    count[sentence] = 1
  } else if (index(files[sentence], file) == 0) {
    files[sentence] = files[sentence] "|" file
    count[sentence]++
  }
}
END {
  for (s in count) {
    if (count[s] > 1) {
      print s "\t" files[s]
    }
  }
}
' "$SENTENCES_FILE" | sort > "$TMPDIR_WORK/dupes.txt"

if [ -s "$TMPDIR_WORK/dupes.txt" ]; then
  FAILED=1
  echo "FAIL: The following sentences appear verbatim in more than one SKILL.md:" >&2
  while IFS='	' read -r sentence filelist; do
    echo "  \"$sentence\"" >&2
    IFS='|'
    for filepath in $filelist; do
      echo "    in: $filepath" >&2
    done
    IFS='	'
  done < "$TMPDIR_WORK/dupes.txt"
fi

rm -rf "$TMPDIR_WORK"

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: No duplicate sentences found across role cores."
