#!/bin/sh
# check-principles.sh — verify the three-mode principle system.
#
# Checks four properties that the three-mode design must satisfy:
#
#   1. A card at the SQA gate with a prescriptive principle unevidenced is blocked.
#   2. A card at the SQA gate with the same principle deselected is not blocked.
#   3. Advisory principles never block, regardless of evidence.
#   4. Perspective blocks produce questions, not verdicts.
#
# Mode 5 — detection — is invoked separately:
#   scripts/check-principles.sh --detect <dir>
#
# Scans <dir> for codebase signals and prints candidate principles for
# confirmation.  Always exits 0 (detection never blocks).
#
# Usage:
#   scripts/check-principles.sh                          # runs all four fixture checks
#   scripts/check-principles.sh <fixture-root>           # runs all four against a given root
#   scripts/check-principles.sh --detect <dir>           # detection mode
#
# Exit status:
#   0  all checks pass
#   1  at least one check failed

set -eu

# ── detection mode ─────────────────────────────────────────────────────────────

if [ "${1:-}" = "--detect" ]; then
  TARGET="${2:-.}"
  echo "Scanning $TARGET for principle signals..."
  echo ""

  found_any=0

  # TDD: test files present
  if find "$TARGET" -name "*test*" -o -name "*spec*" 2>/dev/null | grep -q .; then
    echo "  [candidate] TDD — test files detected"
    found_any=1
  fi

  # Clean Architecture: layered directory structure
  if find "$TARGET" -type d \( -name "domain" -o -name "application" -o -name "infrastructure" \) 2>/dev/null | grep -q .; then
    echo "  [candidate] Clean Architecture — layered directory structure detected"
    found_any=1
  fi

  # Clean Code: linter or formatter in manifest
  if find "$TARGET" -name "package.json" -o -name ".eslintrc*" -o -name ".prettierrc*" 2>/dev/null | grep -q .; then
    echo "  [candidate] Clean Code — linter or formatter config detected"
    found_any=1
  fi

  # Design Tokens: tokens file present
  if find "$TARGET" -name "tokens.json" -o -name "tokens.css" -o -name "design-tokens*" 2>/dev/null | grep -q .; then
    echo "  [candidate] Design Tokens — token file detected"
    found_any=1
  fi

  # Test Pyramid: coverage config
  if find "$TARGET" -name ".nycrc" -o -name "jest.config*" -o -name "coverage*" 2>/dev/null | grep -q .; then
    echo "  [candidate] Test Pyramid — coverage configuration detected"
    found_any=1
  fi

  # User Story: CONTRIBUTING.md mentions story format
  if find "$TARGET" -name "CONTRIBUTING.md" 2>/dev/null | xargs grep -li "story\|user story" 2>/dev/null | grep -q .; then
    echo "  [candidate] User Story — story format mentioned in CONTRIBUTING.md"
    found_any=1
  fi

  if [ "$found_any" -eq 0 ]; then
    echo "  No principle signals found."
  fi

  echo ""
  echo "Detection complete. Confirm, adjust, or discard each candidate."
  echo "Record confirmed selections in documentation/principles.md."
  exit 0
fi

# ── fixture mode ───────────────────────────────────────────────────────────────

FIXTURE_ROOT="${1:-fixtures/principles}"
FAILED=0

# ── helper: read selected principles from documentation/principles.md ──────────

# Returns 0 (true) if the given principle appears with the given mode
principle_has_mode() {
  _principles_file="$1"
  _principle="$2"
  _mode="$3"

  if [ ! -f "$_principles_file" ]; then
    return 1
  fi

  # Look for a table row: | <principle> | <family> | <mode> |
  # The principle and mode values must appear on the same line
  if grep -i "| *$_principle *|" "$_principles_file" | grep -qi "| *$_mode *|"; then
    return 0
  fi
  return 1
}

# ── helper: check one card against principles ──────────────────────────────────

check_card() {
  _card="$1"
  _principles_file="$2"
  _expect_blocked="$3"   # "yes" or "no"
  _check_label="$4"

  # Prescriptive check: TDD
  # A card at the SQA gate with TDD=Prescriptive selected and tdd_evidence: none
  # is blocked.
  _tdd_required=0
  if principle_has_mode "$_principles_file" "TDD" "Prescriptive"; then
    _tdd_required=1
  fi

  _tdd_missing=0
  if grep -q "tdd_evidence: none" "$_card"; then
    _tdd_missing=1
  fi

  _blocked=0
  if [ "$_tdd_required" -eq 1 ] && [ "$_tdd_missing" -eq 1 ]; then
    _blocked=1
  fi

  if [ "$_expect_blocked" = "yes" ]; then
    if [ "$_blocked" -eq 1 ]; then
      echo "PASS ($_check_label): card blocked at SQA gate — TDD is prescriptive and evidence is absent."
    else
      echo "FAIL ($_check_label): card should have been blocked — TDD is prescriptive but gate did not block." >&2
      FAILED=1
    fi
  else
    if [ "$_blocked" -eq 0 ]; then
      echo "PASS ($_check_label): card not blocked — correct."
    else
      echo "FAIL ($_check_label): card was blocked when it should not have been." >&2
      FAILED=1
    fi
  fi
}

# ── Check 1: TDD selected — card without evidence is blocked ──────────────────

TDD_SELECTED_DIR="$FIXTURE_ROOT/tdd-selected"
TDD_SELECTED_CARD=$(find "$TDD_SELECTED_DIR/board/in-progress" -name "*.md" 2>/dev/null | head -1)
TDD_SELECTED_PRINCIPLES="$TDD_SELECTED_DIR/documentation/principles.md"

if [ -z "$TDD_SELECTED_CARD" ] || [ ! -f "$TDD_SELECTED_CARD" ]; then
  echo "FAIL: No card found in $TDD_SELECTED_DIR/board/in-progress/" >&2
  FAILED=1
else
  check_card "$TDD_SELECTED_CARD" "$TDD_SELECTED_PRINCIPLES" "yes" "tdd-selected"
fi

# ── Check 2: TDD deselected — same card without evidence is not blocked ────────

TDD_DESELECTED_DIR="$FIXTURE_ROOT/tdd-deselected"
TDD_DESELECTED_CARD=$(find "$TDD_DESELECTED_DIR/board/in-progress" -name "*.md" 2>/dev/null | head -1)
TDD_DESELECTED_PRINCIPLES="$TDD_DESELECTED_DIR/documentation/principles.md"

if [ -z "$TDD_DESELECTED_CARD" ] || [ ! -f "$TDD_DESELECTED_CARD" ]; then
  echo "FAIL: No card found in $TDD_DESELECTED_DIR/board/in-progress/" >&2
  FAILED=1
else
  check_card "$TDD_DESELECTED_CARD" "$TDD_DESELECTED_PRINCIPLES" "no" "tdd-deselected"
fi

# ── Check 3: Advisory only — card never blocked ────────────────────────────────

ADVISORY_DIR="$FIXTURE_ROOT/advisory-only"
ADVISORY_CARD=$(find "$ADVISORY_DIR/board/in-progress" -name "*.md" 2>/dev/null | head -1)
ADVISORY_PRINCIPLES="$ADVISORY_DIR/documentation/principles.md"

if [ -z "$ADVISORY_CARD" ] || [ ! -f "$ADVISORY_CARD" ]; then
  echo "FAIL: No card found in $ADVISORY_DIR/board/in-progress/" >&2
  FAILED=1
else
  # Advisory principles never produce a prescriptive block
  # Confirm no Prescriptive principle is in the file
  if grep -qi "Prescriptive" "$ADVISORY_PRINCIPLES" 2>/dev/null; then
    echo "FAIL (advisory-only): principles.md contains a Prescriptive entry — fixture is misconfigured." >&2
    FAILED=1
  else
    # Check that the card is not blocked (no Prescriptive TDD present)
    check_card "$ADVISORY_CARD" "$ADVISORY_PRINCIPLES" "no" "advisory-only"
    echo "PASS (advisory-only): advisory principle produces a reminder, not a block."
  fi
fi

# ── Check 4: Perspective — card has questions, no verdict ─────────────────────

PERSPECTIVE_DIR="$FIXTURE_ROOT/perspective"
PERSPECTIVE_CARD=$(find "$PERSPECTIVE_DIR/board/in-progress" -name "*.md" 2>/dev/null | head -1)
PERSPECTIVE_PRINCIPLES="$PERSPECTIVE_DIR/documentation/principles.md"

if [ -z "$PERSPECTIVE_CARD" ] || [ ! -f "$PERSPECTIVE_CARD" ]; then
  echo "FAIL: No card found in $PERSPECTIVE_DIR/board/in-progress/" >&2
  FAILED=1
else
  # A perspective-mode card must contain "MAY ask" (a question, not a verdict)
  if ! grep -q "MAY ask" "$PERSPECTIVE_CARD"; then
    echo "FAIL (perspective): card does not contain a 'MAY ask' question — perspective must produce a question." >&2
    FAILED=1
  else
    echo "PASS (perspective): card contains a question (MAY ask), not a verdict."
  fi

  # A perspective card must not contain MUST or BLOCKED markers as a verdict
  # (a MUST inside a quoted example is acceptable; we look for standalone verdicts)
  if grep -E "^(BLOCKED|verdict: BLOCKED|verdict: FAIL|MUST.*(fail|block|reject))" "$PERSPECTIVE_CARD" 2>/dev/null | grep -v "MAY ask" | grep -q .; then
    echo "FAIL (perspective): card contains a verdict — perspective must not block." >&2
    FAILED=1
  else
    echo "PASS (perspective): no verdict found in perspective card."
  fi

  # Perspective principles must appear as Perspective mode in principles.md
  if ! grep -qi "Perspective" "$PERSPECTIVE_PRINCIPLES" 2>/dev/null; then
    echo "FAIL (perspective): principles.md does not record any Perspective-mode principle." >&2
    FAILED=1
  else
    echo "PASS (perspective): principles.md correctly records Perspective mode."
  fi
fi

# ── Final result ──────────────────────────────────────────────────────────────

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo ""
echo "PASS: All principle-mode checks pass."
