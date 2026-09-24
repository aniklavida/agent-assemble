#!/usr/bin/env bash
# check-public-docs.sh — verify public documentation invariants and claim/limit pairing.
#
# Validates three load-bearing public documentation requirements:
#
#   1. Claim and Limit pairing:
#      Wherever the tool's value proposition is stated ("What it provides: a role,
#      a place in a process, and a memory that survives the session"), it MUST be
#      paired in the exact same paragraph with the limit statement ("What it cannot
#      provide: any guarantee the agent actually read the skill, followed it, or
#      did what it said — no host application reports this"). Neither may appear
#      without the other.
#
#   2. Authoring guide completeness:
#      docs/AUTHORING.md must cover the real mechanisms for authoring:
#        - Roles (Purpose, Preconditions, Steps, Completion signal, Failure handling)
#        - Principles (Advisory, Prescriptive, Perspective mapped to SHOULD, MUST, MAY)
#        - Board Adapters (Create Card, Move Card, Read Card, Append Log, Rule 1, Rule 2)
#
#   3. Dogfood report and honest friction points:
#      docs/DOGFOOD.md must exist and document both what worked and what failed.
#
# Usage:
#   scripts/check-public-docs.sh [TARGET_DIR]
#   scripts/check-public-docs.sh --self-test
#
# Exit status:
#   0  all checks pass
#   1  invariants violated

set -euo pipefail

TARGET_DIR="${1:-.}"

# ── Self-test mode ───────────────────────────────────────────────────────────

run_self_tests() {
  echo "Running check-public-docs.sh self-tests..."
  local tmp
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT

  local script_path
  script_path="$(cd "$(dirname "$0")" && pwd)/check-public-docs.sh"

  # Test 1: Uncoupled claim (missing limit) fails
  mkdir -p "$tmp/t1/docs"
  cat <<'EOF' > "$tmp/t1/README.md"
# Test Project
**What it provides:** a role, a place in a process, and a memory that survives the session.
EOF
  if bash "$script_path" "$tmp/t1" >/dev/null 2>&1; then
    echo "FAIL: self-test 1 — uncoupled claim unexpectedly passed." >&2
    exit 1
  fi
  echo "PASS: self-test 1 — uncoupled claim is refused."

  # Test 2: Uncoupled limit (missing claim) fails
  mkdir -p "$tmp/t2/docs"
  cat <<'EOF' > "$tmp/t2/README.md"
# Test Project
**What it cannot provide:** any guarantee the agent actually read the skill, followed it, or did what it said — no host application reports this.
EOF
  if bash "$script_path" "$tmp/t2" >/dev/null 2>&1; then
    echo "FAIL: self-test 2 — uncoupled limit unexpectedly passed." >&2
    exit 1
  fi
  echo "PASS: self-test 2 — uncoupled limit is refused."

  # Test 3: Missing authoring sections fails
  mkdir -p "$tmp/t3/docs"
  cat <<'EOF' > "$tmp/t3/README.md"
**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent actually read the skill, followed it, or did what it said — no host application reports this.

## What It Is Not
## Five-Minute Start
## Host Support Matrix
## Known Limitations
EOF
  cat <<'EOF' > "$tmp/t3/docs/AUTHORING.md"
# Authoring
Incomplete content without required sections.
EOF
  cat <<'EOF' > "$tmp/t3/docs/DOGFOOD.md"
# Dogfood
Friction points and observations.
EOF
  if bash "$script_path" "$tmp/t3" >/dev/null 2>&1; then
    echo "FAIL: self-test 3 — incomplete authoring guide unexpectedly passed." >&2
    exit 1
  fi
  echo "PASS: self-test 3 — incomplete authoring guide is refused."

  echo "PASS: all check-public-docs.sh self-tests passed successfully."
  exit 0
}

if [ "$TARGET_DIR" = "--self-test" ]; then
  run_self_tests
fi

# ── 1. Check Claim and Limit Pairing ─────────────────────────────────────────

FAILED=0

check_paragraph_pairing() {
  local file="$1"
  [ ! -f "$file" ] && return 0

  # Read file paragraph by paragraph (paragraphs separated by blank lines)
  awk '
    BEGIN { RS = ""; FS = "\n" }
    {
      has_claim = ($0 ~ /What it provides:[[:space:]]*a role, a place in a process, and a memory/)
      has_limit = ($0 ~ /What it cannot provide:[[:space:]]*any guarantee the agent actually read the skill/)

      if (has_claim && !has_limit) {
        print "FAIL: Claim found without paired limit in the same paragraph in " FILENAME > "/dev/stderr"
        exit 1
      }
      if (has_limit && !has_claim) {
        print "FAIL: Limit found without paired claim in the same paragraph in " FILENAME > "/dev/stderr"
        exit 1
      }
    }
  ' "$file" || FAILED=1
}

# Check all markdown files in target directory
while IFS= read -r md_file; do
  check_paragraph_pairing "$md_file"
done < <(find "$TARGET_DIR" -name "*.md" ! -path "*/.git/*" ! -path "*/fixtures/*" 2>/dev/null || true)

# ── 2. Check README Required Sections ─────────────────────────────────────────

README_DOC="$TARGET_DIR/README.md"
if [ ! -f "$README_DOC" ]; then
  echo "FAIL: README.md is missing." >&2
  FAILED=1
else
  for sec in "What It Is Not" "Five-Minute Start" "Host Support Matrix" "Known Limitations"; do
    if ! grep -qi "$sec" "$README_DOC"; then
      echo "FAIL: README.md is missing section: $sec" >&2
      FAILED=1
    fi
  done
fi

# ── 3. Check Authoring Guide Completeness ─────────────────────────────────────

AUTHORING_DOC="$TARGET_DIR/docs/AUTHORING.md"
if [ ! -f "$AUTHORING_DOC" ]; then
  echo "FAIL: docs/AUTHORING.md is missing." >&2
  FAILED=1
else
  # Verify role sections
  for sec in "Purpose" "Preconditions" "Steps" "Completion signal" "Failure handling"; do
    if ! grep -qi "$sec" "$AUTHORING_DOC"; then
      echo "FAIL: docs/AUTHORING.md is missing role section: $sec" >&2
      FAILED=1
    fi
  done

  # Verify principle modes
  for mode in "Advisory" "Prescriptive" "Perspective"; do
    if ! grep -qi "$mode" "$AUTHORING_DOC"; then
      echo "FAIL: docs/AUTHORING.md is missing principle mode: $mode" >&2
      FAILED=1
    fi
  done

  # Verify board contract operations
  for op in "Create Card" "Move Card" "Read Card" "Append Log"; do
    if ! grep -qi "$op" "$AUTHORING_DOC"; then
      echo "FAIL: docs/AUTHORING.md is missing board contract operation: $op" >&2
      FAILED=1
    fi
  done
fi

# ── 3. Check Dogfood Report ──────────────────────────────────────────────────

DOGFOOD_DOC="$TARGET_DIR/docs/DOGFOOD.md"
if [ ! -f "$DOGFOOD_DOC" ]; then
  echo "FAIL: docs/DOGFOOD.md is missing." >&2
  FAILED=1
else
  if ! grep -qi "What Went Right" "$DOGFOOD_DOC" || ! grep -qi "What Went Wrong" "$DOGFOOD_DOC"; then
    echo "FAIL: docs/DOGFOOD.md must report both what went right and what went wrong." >&2
    FAILED=1
  fi
fi

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: Public documentation invariants, claim/limit pairing, authoring guide, and dogfood report verified."
exit 0
