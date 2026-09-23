#!/bin/sh
# check-principles.sh — verify the three-mode principle system.
#
# Checks six properties that the three-mode design must satisfy:
#
#   1. A card at the SQA gate with a prescriptive principle unevidenced is blocked.
#   2. A card at the SQA gate with the same principle deselected is not blocked.
#   3. Advisory principles never block, regardless of evidence.
#   4. Perspective blocks produce questions, not verdicts.
#   5. Each shipped perspective (Security, Performance, Researcher) contributes a
#      MAY ask question, and a corrupted card that adds a MUST/BLOCKED verdict is
#      rejected.
#   6. The shipped perspective role files ask and produce no verdict.
#
# Mode 5 — detection — is invoked separately:
#   scripts/check-principles.sh --detect <dir>
#
# Scans <dir> for codebase signals and prints candidate principles for
# confirmation.  Always exits 0 (detection never blocks).
#
# Usage:
#   scripts/check-principles.sh                          # runs all fixture checks
#   scripts/check-principles.sh <fixture-root>           # runs all checks against a given root
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

# ── helper: perspective predicates ────────────────────────────────────────────

# The three review perspectives this project ships, as
# <dir-slug>:<question-marker>:<principle-name>. Security, Performance and
# Researcher each ask; none of them blocks or produces a verdict.
PERSPECTIVE_SPECS="security:Security:Leak Scan
performance:Performance:Cost Scaling
researcher:Researcher:Claim Verification"

# perspective_card_has_question <card> <marker>
# 0 if the card contains a "MAY ask [<marker>]" question.
perspective_card_has_question() {
  _card="$1"
  _marker="$2"
  [ -f "$_card" ] || return 1
  grep -qF "MAY ask [$_marker]" "$_card"
}

# perspective_card_has_verdict <card>
# 0 if the card contains a standalone MUST/BLOCKED verdict marker. A "MAY ask"
# line is exempt: the marker must be a verdict, not a question.
perspective_card_has_verdict() {
  _card="$1"
  [ -f "$_card" ] || return 1
  if grep -E "^(BLOCKED|verdict: BLOCKED|verdict: FAIL|MUST.*(fail|block|reject))" "$_card" 2>/dev/null | grep -v "MAY ask" | grep -q .; then
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

  # Each shipped review perspective contributes its own MAY-mode question, and
  # its principle is recorded as Perspective mode.
  while IFS=: read -r _slug _marker _principle; do
    [ -z "$_slug" ] && continue
    if perspective_card_has_question "$PERSPECTIVE_CARD" "$_marker"; then
      echo "PASS (perspective/$_slug): card contains a 'MAY ask [$_marker]' question."
    else
      echo "FAIL (perspective/$_slug): card has no 'MAY ask [$_marker]' question." >&2
      FAILED=1
    fi
    if principle_has_mode "$PERSPECTIVE_PRINCIPLES" "$_principle" "Perspective"; then
      echo "PASS (perspective/$_slug): '$_principle' recorded as Perspective mode."
    else
      echo "FAIL (perspective/$_slug): principles.md does not record '$_principle' as Perspective." >&2
      FAILED=1
    fi
  done <<PERSPECTIVES
$PERSPECTIVE_SPECS
PERSPECTIVES

  # A perspective card must not contain MUST or BLOCKED markers as a verdict
  # (a MUST inside a quoted example is acceptable; we look for standalone verdicts)
  if perspective_card_has_verdict "$PERSPECTIVE_CARD"; then
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

# ── Check 5: each review perspective rejects a question turned into a verdict ─

# The bad fixtures corrupt one perspective card per role: the MAY ask question is
# still present, but a MUST or BLOCKED verdict was added. The same predicate that
# accepts the good card must reject each of these. Paths are relative to the
# repository root, so the check runs identically for both fixture roots.
while IFS=: read -r _slug _marker _principle; do
  [ -z "$_slug" ] && continue
  _bad_dir="fixtures/principles/bad/perspective-$_slug"
  _bad_card=$(find "$_bad_dir/board/in-progress" -name "*.md" 2>/dev/null | head -1)
  if [ -z "$_bad_card" ] || [ ! -f "$_bad_card" ]; then
    echo "FAIL (bad/perspective-$_slug): no corrupted card found in $_bad_dir." >&2
    FAILED=1
    continue
  fi
  # The corruption keeps its question, so rejection is caused by the verdict and
  # not by the question having been deleted.
  if ! perspective_card_has_question "$_bad_card" "$_marker"; then
    echo "FAIL (bad/perspective-$_slug): corrupted card no longer asks its question — fixture is not the intended shape." >&2
    FAILED=1
  elif perspective_card_has_verdict "$_bad_card"; then
    echo "PASS (bad/perspective-$_slug): verdict marker detected — corrupted question is rejected."
  else
    echo "FAIL (bad/perspective-$_slug): no MUST/BLOCKED verdict detected — corruption would pass the check." >&2
    FAILED=1
  fi
done <<PERSPECTIVES
$PERSPECTIVE_SPECS
PERSPECTIVES

# ── Check 6: the shipped perspective roles ask and never block ────────────────

# The employee role files themselves must obey the same property: each contains
# a MAY ask question and no MUST/BLOCKED verdict. File structure alone is not
# evidence that a perspective role is perspective-only.
while IFS=: read -r _slug _marker _principle; do
  [ -z "$_slug" ] && continue
  _role_file="employees/$_slug/SKILL.md"
  if [ ! -f "$_role_file" ]; then
    echo "FAIL (role/$_slug): role file not found at $_role_file." >&2
    FAILED=1
    continue
  fi
  if ! grep -q "MAY ask" "$_role_file"; then
    echo "FAIL (role/$_slug): role file contains no MAY ask question." >&2
    FAILED=1
  elif perspective_card_has_verdict "$_role_file"; then
    echo "FAIL (role/$_slug): role file contains a MUST/BLOCKED verdict — a perspective must not block." >&2
    FAILED=1
  else
    echo "PASS (role/$_slug): role file asks (MAY ask) and produces no verdict."
  fi
done <<PERSPECTIVES
$PERSPECTIVE_SPECS
PERSPECTIVES

# ── Final result ──────────────────────────────────────────────────────────────

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo ""
echo "PASS: All principle-mode checks pass."
