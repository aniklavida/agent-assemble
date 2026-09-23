#!/usr/bin/env bash
# check-sizing-gate.sh  FIXTURE_DIR  LOG_FILE
#
# Mechanically verifies the structural consequence of a card's size field
# against the project log, for every card (.md with YAML frontmatter) found
# under FIXTURE_DIR.
#
# What is checked:
#   - size: "direct" → the card's id must NOT appear in any CARD_CREATED,
#     VERIFICATION_PASSED, or VERIFICATION_FAILED log entry.  Presence of such
#     an entry proves BA or SQA ran, contradicting the Direct bypass claim.
#   - size: "full"   → the card's id MUST appear in at least one CARD_CREATED
#     entry AND at least one VERIFICATION_PASSED entry.  Absence proves BA or
#     SQA did not actually run.
#
# What is NOT checked:
#   The sizing judgement itself — whether "direct" was the right call — is
#   inherently a human/agent decision that cannot be mechanised.  This script
#   only verifies the structural log consequence of whichever size was declared.
#
# Usage:
#   bash scripts/check-sizing-gate.sh fixtures/sizing-gate
#   bash scripts/check-sizing-gate.sh fixtures/sizing-gate path/to/LOG.md
#
# The log file defaults to the log/LOG.md that lives alongside FIXTURE_DIR's
# parent, then falls back to fixtures/sizing-gate/../../../log/LOG.md, and
# finally accepts an explicit second argument.

set -euo pipefail

FIXTURE_DIR="${1:?Usage: check-sizing-gate.sh FIXTURE_DIR [LOG_FILE]}"

# Resolve log path: explicit arg > sibling log/LOG.md > repo-root log/LOG.md
if [ -n "${2:-}" ]; then
  LOG_FILE="$2"
else
  # Try a log/LOG.md adjacent to the fixture dir's parent tree
  CANDIDATE="$(cd "$FIXTURE_DIR" && git rev-parse --show-toplevel 2>/dev/null || true)/log/LOG.md"
  if [ -f "$CANDIDATE" ]; then
    LOG_FILE="$CANDIDATE"
  else
    # Fall back to a sibling log directory
    LOG_FILE="$(dirname "$FIXTURE_DIR")/log/LOG.md"
  fi
fi

# Allow per-fixture log override: a log/LOG.md inside the fixture dir itself
FIXTURE_LOG="$FIXTURE_DIR/log/LOG.md"
if [ -f "$FIXTURE_LOG" ]; then
  LOG_FILE="$FIXTURE_LOG"
fi

if [ ! -f "$LOG_FILE" ]; then
  echo "FAIL: log file not found: $LOG_FILE" >&2
  exit 1
fi

FAILED=0

check_card() {
  local file="$1"

  # Extract id and size from YAML frontmatter (between the first two --- lines)
  local id size
  id=$(awk '/^---/{f++} f==1 && /^id:/{gsub(/["'\'']|id:[[:space:]]*/,""); print; exit}' "$file")
  size=$(awk '/^---/{f++} f==1 && /^size:/{gsub(/["'\'']|size:[[:space:]]*/,""); print; exit}' "$file")

  [ -z "$id" ] && return 0    # no frontmatter id — skip
  [ -z "$size" ] && return 0  # no size field — skip

  case "$size" in
    direct)
      # Must NOT have CARD_CREATED, VERIFICATION_PASSED, or VERIFICATION_FAILED for this id
      local bad_events
      bad_events=$(grep -E "(CARD_CREATED|VERIFICATION_PASSED|VERIFICATION_FAILED)" "$LOG_FILE" \
                   | grep -F "$id" || true)
      if [ -n "$bad_events" ]; then
        echo "FAIL: $file (size: direct) — log contains BA/SQA entries for $id, contradicting the Direct bypass:" >&2
        echo "$bad_events" | sed 's/^/  /' >&2
        FAILED=1
      else
        echo "PASS: $file (size: direct) — no BA/SQA log entries for $id"
      fi
      ;;
    full)
      # Must have CARD_CREATED (BA ran) AND VERIFICATION_PASSED (SQA ran)
      local has_created has_verified
      has_created=$(grep -E "CARD_CREATED" "$LOG_FILE" | grep -cF "$id" || true)
      has_verified=$(grep -E "VERIFICATION_PASSED" "$LOG_FILE" | grep -cF "$id" || true)

      local ok=1
      if [ "$has_created" -eq 0 ]; then
        echo "FAIL: $file (size: full) — no CARD_CREATED entry for $id in log — BA did not run" >&2
        ok=0
      fi
      if [ "$has_verified" -eq 0 ]; then
        echo "FAIL: $file (size: full) — no VERIFICATION_PASSED entry for $id in log — SQA did not run" >&2
        ok=0
      fi
      if [ "$ok" -eq 1 ]; then
        echo "PASS: $file (size: full) — CARD_CREATED and VERIFICATION_PASSED found for $id"
      else
        FAILED=1
      fi
      ;;
    *)
      # Unknown size — not our concern
      ;;
  esac
}

# Scan all .md files in the fixture directory
while IFS= read -r -d '' file; do
  check_card "$file"
done < <(find "$FIXTURE_DIR" -maxdepth 1 -name "*.md" -print0 | sort -z)

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: All sizing-gate checks passed."
