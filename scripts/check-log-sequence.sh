#!/usr/bin/env bash
# check-log-sequence.sh  FIXTURE_DIR  [LOG_FILE]
#
# Verifies that every completed task card has an unbroken, correctly ordered
# trail in log/LOG.md.
#
# For a card with status: "done":
#   - size: "direct"  -> the log must contain DIRECT_CLOSED for the card's id,
#                        appended by PM.  Direct bypasses BA and SQA, so the
#                        five-event Full/Short sequence does not apply.
#   - any other size  -> the log entries for the card's id must contain, in
#                        order and with each owned by the right role:
#                          CARD_CREATED -> WORK_STARTED -> WORK_COMPLETED
#                          -> VERIFICATION_PASSED -> CARD_CLOSED
#                        (BA, Engineer, Engineer, SQA, PM respectively).
#
# A missing entry, a reordered entry, or an entry logged by the wrong role
# fails with a message naming the card id and the defect.
#
# The log file is taken from the explicit second argument when given, otherwise
# from the nearest log/LOG.md found by walking up from the card's directory.  A
# card with no discoverable log is skipped (documentation and plan files carry
# no frontmatter id at all).
#
# Usage:
#   bash scripts/check-log-sequence.sh fixtures/relay-trace
#   bash scripts/check-log-sequence.sh fixtures/relay-trace/bad
#   bash scripts/check-log-sequence.sh fixtures/relay-trace fixtures/relay-trace/log/LOG.md
#
# Exit status:
#   0  every checked card has a complete, correctly ordered log trail
#   1  at least one card's trail is missing, reordered, or role-mismatched

set -euo pipefail

TARGET_DIR="${1:-}"
EXPLICIT_LOG="${2:-}"
FAILED=0
CHECKED=0

find_log() {
  local card="$1"
  if [ -n "$EXPLICIT_LOG" ] && [ -f "$EXPLICIT_LOG" ]; then
    printf '%s\n' "$EXPLICIT_LOG"
    return 0
  fi
  local d
  d="$(cd "$(dirname "$card")" && pwd)"
  while [ "$d" != "/" ]; do
    if [ -f "$d/log/LOG.md" ]; then
      printf '%s\n' "$d/log/LOG.md"
      return 0
    fi
    d="$(dirname "$d")"
  done
  return 1
}

check_card() {
  local file="$1"

  local id size status
  id="$(grep -m1 '^id:' "$file" 2>/dev/null | sed 's/^id:[[:space:]]*//; s/["'"'"']//g; s/[[:space:]]*$//' || true)"
  size="$(grep -m1 '^size:' "$file" 2>/dev/null | sed 's/^size:[[:space:]]*//; s/["'"'"']//g; s/[[:space:]]*$//' || true)"
  status="$(grep -m1 '^status:' "$file" 2>/dev/null | sed 's/^status:[[:space:]]*//; s/["'"'"']//g; s/[[:space:]]*$//' || true)"

  if [ -z "$id" ]; then
    return 0
  fi
  if [ "$status" != "done" ]; then
    return 0
  fi

  local log
  if ! log="$(find_log "$file")"; then
    return 0
  fi

  CHECKED=$((CHECKED + 1))

  local direct=0
  if [ "$size" = "direct" ]; then
    direct=1
  fi

  local result
  if result="$(awk -v card="$id" -v cardfile="$file" -v logfile="$log" -v direct="$direct" '
    function trim(s) { gsub(/^[ \t]+|[ \t]+$/, "", s); return s }
    function roleok(ev, rl) {
      if (erole[ev] == "Engineer") return (rl == "Engineer" || rl == "Employee")
      return rl == erole[ev]
    }
    BEGIN {
      n = split("CARD_CREATED WORK_STARTED WORK_COMPLETED VERIFICATION_PASSED CARD_CLOSED", seq, " ")
      erole["CARD_CREATED"] = "BA"
      erole["WORK_STARTED"] = "Engineer"
      erole["WORK_COMPLETED"] = "Engineer"
      erole["VERIFICATION_PASSED"] = "SQA"
      erole["CARD_CLOSED"] = "PM"
      cnt = 0
    }
    {
      nf = split($0, f, "|")
      hasid = 0
      for (i = 1; i <= nf; i++) { f[i] = trim(f[i]); if (f[i] == card) hasid = 1 }
      if (!hasid) next
      ev = ""; rl = ""
      for (i = 1; i <= nf; i++) {
        if (f[i] ~ /^(REQUEST_SIZED|CARD_CREATED|WORK_STARTED|WORK_COMPLETED|VERIFICATION_STARTED|VERIFICATION_PASSED|VERIFICATION_FAILED|CARD_CLOSED|DIRECT_CLOSED|DRIFT_DETECTED|CARD_RECONCILED|ROLE_BLOCKED)$/ && ev == "") ev = f[i]
        if (f[i] ~ /^(PM|BA|Employee|Engineer|SQA)$/ && rl == "") rl = f[i]
      }
      if (ev != "") { cnt++; aev[cnt] = ev; arl[cnt] = rl }
    }
    END {
      if (direct) {
        found = 0; badrole = 0
        for (i = 1; i <= cnt; i++) {
          if (aev[i] == "DIRECT_CLOSED") { found = 1; if (arl[i] != "PM") badrole = 1 }
        }
        if (!found) {
          print "FAIL: " cardfile " (id: " card ") - no DIRECT_CLOSED entry found for a Direct-sized done card"
          exit 1
        }
        if (badrole) {
          print "FAIL: " cardfile " (id: " card ") - DIRECT_CLOSED must be logged by role PM"
          exit 1
        }
        print "PASS: " cardfile " (id: " card ", size: direct) - DIRECT_CLOSED logged by PM"
        exit 0
      }

      # Keep only the five sequence events, preserving their order in the log.
      m = 0
      for (i = 1; i <= cnt; i++)
        for (j = 1; j <= n; j++)
          if (aev[i] == seq[j]) { m++; sev[m] = aev[i]; srl[m] = arl[i]; break }

      ok = 1
      for (j = 1; j <= n; j++) if (m < j || sev[j] != seq[j]) ok = 0
      if (m != n) ok = 0
      for (j = 1; j <= m; j++) if (!roleok(sev[j], srl[j])) ok = 0

      if (ok) {
        print "PASS: " cardfile " (id: " card ") - trail is complete and in order"
        exit 0
      }

      print "FAIL: " cardfile " (id: " card ") - log trail in " logfile " is broken:"
      actual = ""
      for (i = 1; i <= m; i++) actual = actual (i > 1 ? " -> " : "") sev[i]
      if (actual == "") actual = "(none)"
      print "  expected: CARD_CREATED -> WORK_STARTED -> WORK_COMPLETED -> VERIFICATION_PASSED -> CARD_CLOSED"
      print "  found:    " actual
      for (j = 1; j <= n; j++) {
        present = 0; count = 0
        for (i = 1; i <= m; i++) { if (sev[i] == seq[j]) { present = 1; count++ } }
        if (!present) print "  - missing required entry: " seq[j]
        if (count > 1) print "  - duplicate entry: " seq[j]
      }
      if (m == n) {
        ordered = 1
        for (j = 1; j <= n; j++) if (sev[j] != seq[j]) ordered = 0
        if (!ordered) print "  - entries are out of order"
      }
      for (i = 1; i <= m; i++)
        if (!roleok(sev[i], srl[i]))
          print "  - " sev[i] " logged by wrong role: expected " erole[sev[i]] ", found " (srl[i] == "" ? "(none)" : srl[i])
      exit 1
    }
  ' "$log")"; then
    printf '%s\n' "$result"
  else
    printf '%s\n' "$result" >&2
    FAILED=1
  fi
}

if [ -n "$TARGET_DIR" ]; then
  case "$TARGET_DIR" in
    */bad|*/bad/) FILES="$(find "$TARGET_DIR" -name '*.md' | sort)" ;;
    *) FILES="$(find "$TARGET_DIR" -name '*.md' ! -path '*/bad/*' | sort)" ;;
  esac
else
  FILES="$(find board fixtures -name '*.md' ! -path '*/bad/*' ! -path './.git/*' 2>/dev/null | sort || true)"
fi

for file in $FILES; do
  if [ -z "$file" ]; then
    continue
  fi
  check_card "$file"
done

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

if [ "$CHECKED" -eq 0 ]; then
  echo "PASS: No completed cards with a discoverable log to check."
else
  echo "PASS: All completed cards have a complete, correctly ordered log trail."
fi
