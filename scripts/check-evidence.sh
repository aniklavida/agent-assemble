#!/bin/sh
# check-evidence.sh — verify per-criterion sabotage evidence in completed task items.
#
# A completed item is any card with status: "done" and size other than "direct".
# Direct-path items bypass the SQA gate and carry no sabotage obligation.
# For each acceptance criterion in a checked card, the script requires:
#   - A named test (test: field not blank or only whitespace)
#   - A mutation (mutation: field not blank or only whitespace)
#   - No unresolved sabotage-passed entries (sabotage_passed: "unresolved")
#   - Every criterion in the Acceptance Criteria list has a matching evidence block
#   - Every evidence block names a criterion that appears in the Acceptance Criteria list
#
# Items in the fixture's "bad" directory are excluded from the normal sweep;
# they are only checked when this script is called with that directory explicitly.
#
# Usage:
#   scripts/check-evidence.sh                        # sweeps board/ and fixtures/
#   scripts/check-evidence.sh fixtures/sabotage-evidence/bad   # sweeps a bad-fixture dir

set -eu

TARGET_DIR="${1:-}"
FAILED=0

# ── helper: check one file ────────────────────────────────────────────────────

check_file() {
  file="$1"

  # Only check completed (done) items
  if ! grep -q 'status: "done"' "$file"; then
    return 0
  fi

  # Direct-path items bypass the SQA gate and have no sabotage obligation
  if grep -q 'size: "direct"' "$file"; then
    return 0
  fi

  # Parse criterion blocks. Each criterion block is expected to contain:
  #   criterion: "..."
  #   test: "..."       ← must be non-blank (after trimming whitespace)
  #   mutation: "..."   ← must be non-blank (after trimming whitespace)
  #   sabotage_outcome: "pass | fail | unresolved"
  #   sabotage_cause: "..."    ← required when sabotage_outcome is "pass"

  # ── Pass 1: collect acceptance criteria from "## Acceptance Criteria" ────────
  # Checked criteria are lines of the form: - [x] Some criterion text
  # We store each criterion text in a newline-separated variable.

  ac_criteria=""
  in_ac=0

  while IFS= read -r line; do
    case "$line" in
      "## Acceptance Criteria"*) in_ac=1; continue ;;
      "## "*) in_ac=0; continue ;;
    esac
    [ "$in_ac" -eq 0 ] && continue
    case "$line" in
      "- [x] "*)
        ctext=$(printf '%s' "$line" | sed 's/^- \[x\] //')
        ac_criteria="${ac_criteria}${ctext}
"
        ;;
    esac
  done < "$file"

  # ── Pass 2: parse evidence blocks ────────────────────────────────────────────

  in_evidence=0
  criterion_label=""
  test_val=""
  mutation_val=""
  outcome_val=""
  cause_val=""
  criterion_count=0
  pending_check=0

  # evidence_labels: newline-separated list of criterion names seen in evidence
  evidence_labels=""

  while IFS= read -r line; do

    # Detect entry into the Sabotage Evidence section
    case "$line" in
      "## Sabotage Evidence"*) in_evidence=1; continue ;;
      "## "*)
        if [ "$in_evidence" -eq 1 ]; then
          # Leaving the section — flush any pending criterion
          if [ "$pending_check" -eq 1 ]; then
            _flush_criterion "$file" "$criterion_label" "$test_val" "$mutation_val" "$outcome_val" "$cause_val" || FAILED=1
            pending_check=0
          fi
          in_evidence=0
        fi
        continue ;;
    esac

    [ "$in_evidence" -eq 0 ] && continue

    # Detect a new criterion entry (starts with "- criterion:")
    case "$line" in
      "- criterion:"*)
        # Flush the previous criterion if any
        if [ "$pending_check" -eq 1 ]; then
          _flush_criterion "$file" "$criterion_label" "$test_val" "$mutation_val" "$outcome_val" "$cause_val" || FAILED=1
        fi
        criterion_label=$(printf '%s' "$line" | sed 's/^- criterion:[[:space:]]*//' | tr -d '"')
        test_val=""
        mutation_val=""
        outcome_val=""
        cause_val=""
        criterion_count=$((criterion_count + 1))
        pending_check=1
        evidence_labels="${evidence_labels}${criterion_label}
"
        ;;
      "  test:"*)
        test_val=$(printf '%s' "$line" | sed 's/^[[:space:]]*test:[[:space:]]*//' | tr -d '"')
        ;;
      "  mutation:"*)
        mutation_val=$(printf '%s' "$line" | sed 's/^[[:space:]]*mutation:[[:space:]]*//' | tr -d '"')
        ;;
      "  sabotage_outcome:"*)
        outcome_val=$(printf '%s' "$line" | sed 's/^[[:space:]]*sabotage_outcome:[[:space:]]*//' | tr -d '"')
        ;;
      "  sabotage_cause:"*)
        cause_val=$(printf '%s' "$line" | sed 's/^[[:space:]]*sabotage_cause:[[:space:]]*//' | tr -d '"')
        ;;
    esac

  done < "$file"

  # Flush last pending criterion
  if [ "$pending_check" -eq 1 ]; then
    _flush_criterion "$file" "$criterion_label" "$test_val" "$mutation_val" "$outcome_val" "$cause_val" || FAILED=1
  fi

  # A done item with no Sabotage Evidence section at all also fails
  if [ "$criterion_count" -eq 0 ]; then
    echo "FAIL: $file — status is \"done\" but contains no Sabotage Evidence section" >&2
    FAILED=1
    return 0
  fi

  # ── Cross-check: every acceptance criterion must have an evidence block ───────
  # Iterate over each AC criterion and confirm it appears in evidence_labels.
  # "appears" means an evidence block whose criterion: field exactly matches.

  IFS="
"
  for ac_line in $ac_criteria; do
    [ -z "$ac_line" ] && continue
    # Search evidence_labels line by line for an exact match
    found=0
    for ev_line in $evidence_labels; do
      [ -z "$ev_line" ] && continue
      if [ "$ev_line" = "$ac_line" ]; then
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      echo "FAIL: $file — acceptance criterion \"$ac_line\" has no matching sabotage evidence block" >&2
      FAILED=1
    fi
  done

  # ── Cross-check: every evidence block must name a criterion in the AC list ───
  for ev_line in $evidence_labels; do
    [ -z "$ev_line" ] && continue
    found=0
    for ac_line in $ac_criteria; do
      [ -z "$ac_line" ] && continue
      if [ "$ac_line" = "$ev_line" ]; then
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      echo "FAIL: $file — evidence block names \"$ev_line\" which is not in the Acceptance Criteria list (stale evidence)" >&2
      FAILED=1
    fi
  done
  unset IFS

  return 0
}

# ── helper: validate one criterion block ─────────────────────────────────────

_flush_criterion() {
  _file="$1"
  _label="$2"
  _test="$3"
  _mutation="$4"
  _outcome="$5"
  _cause="$6"

  _ok=0

  # Trim leading/trailing whitespace before checking for emptiness
  _test_trimmed=$(printf '%s' "$_test" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  _mutation_trimmed=$(printf '%s' "$_mutation" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  if [ -z "$_test_trimmed" ]; then
    echo "FAIL: $_file — criterion \"$_label\" has no named test (test: field is blank)" >&2
    _ok=1
  fi

  if [ -z "$_mutation_trimmed" ]; then
    echo "FAIL: $_file — criterion \"$_label\" has no mutation (mutation: field is blank)" >&2
    _ok=1
  fi

  # sabotage_outcome must not be "unresolved" or blank for a done item
  if [ -z "$_outcome" ]; then
    echo "FAIL: $_file — criterion \"$_label\" has no sabotage_outcome recorded" >&2
    _ok=1
  elif [ "$_outcome" = "unresolved" ]; then
    echo "FAIL: $_file — criterion \"$_label\" has sabotage_outcome: \"unresolved\" — item may not close until this is resolved" >&2
    _ok=1
  elif [ "$_outcome" = "pass" ]; then
    # A passing sabotage must name its cause
    _cause_trimmed=$(printf '%s' "$_cause" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [ -z "$_cause_trimmed" ]; then
      echo "FAIL: $_file — criterion \"$_label\" sabotage passed but sabotage_cause is blank — must name the independent safeguard, explain the build-failure status, or state the test never reached that code" >&2
      _ok=1
    fi
  fi

  return "$_ok"
}

# ── main sweep ────────────────────────────────────────────────────────────────

if [ -n "$TARGET_DIR" ]; then
  # Explicit target — scan every .md file in that directory tree
  FILES=$(find "$TARGET_DIR" -name "*.md" | sort)
else
  # Default sweep: board/ and fixtures/ excluding the bad-fixture directory
  FILES=$(find board fixtures -name "*.md" \
    ! -path "fixtures/sabotage-evidence/bad/*" \
    ! -path "./.git/*" 2>/dev/null | sort || true)
fi

for file in $FILES; do
  check_file "$file"
done

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: All completed task items carry per-criterion sabotage evidence."
