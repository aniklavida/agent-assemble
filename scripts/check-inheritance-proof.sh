#!/bin/sh
# check-inheritance-proof.sh — prove that parent levels are load-bearing.
#
# For the three-level Software Engineer → Backend Developer → Node.js slice,
# this script demonstrates that:
#
#   1. The full composition (all three levels) contains a specific instruction
#      that originates in Backend Developer.
#   2. A composition that omits Backend Developer does NOT contain that
#      instruction.
#   3. The difference is therefore caused by the presence of Backend Developer,
#      not merely by the composition being shorter.
#
# The instruction tested is the licence-policy check: Backend Developer requires
# checking documentation/ for the licence policy before adding a compiled
# dependency. Node.js Developer does not restate this instruction; it inherits
# it. Removing Backend Developer from the composition removes the requirement.
#
# Usage:
#   scripts/check-inheritance-proof.sh
#
# The script composes two versions of the Node.js role:
#   full:    software-engineer + backend-developer + nodejs
#   partial: software-engineer + nodejs (backend-developer omitted)
#
# It then confirms the target instruction appears in full and not in partial.
#
# Exit status:
#   0  parent is load-bearing — instruction present in full, absent in partial
#   1  proof failed — instruction is either missing from full or present in
#      partial (meaning the parent is not the sole source)

set -eu

FULL_DIR="${1:-fixtures/inheritance-proof/full/backend/nodejs}"
PARTIAL_DIR="${2:-fixtures/inheritance-proof/partial/nodejs}"

LICENCE_PHRASE="licence policy before adding"

FAILED=0

# ── Step 1: compose the full three-level role ─────────────────────────────────
if [ ! -d "$FULL_DIR" ]; then
  echo "FAIL: Full composition fixture not found at $FULL_DIR" >&2
  exit 1
fi

FULL_TEXT=$(sh scripts/compose-role.sh "$FULL_DIR")

if ! printf '%s' "$FULL_TEXT" | grep -q "$LICENCE_PHRASE"; then
  echo "FAIL: Licence-policy instruction not found in the full composition." >&2
  echo "      Expected to find: '$LICENCE_PHRASE'" >&2
  echo "      Full composition came from: $FULL_DIR" >&2
  FAILED=1
fi

# ── Step 2: compose the partial role (backend-developer omitted) ──────────────
if [ ! -d "$PARTIAL_DIR" ]; then
  echo "FAIL: Partial composition fixture not found at $PARTIAL_DIR" >&2
  exit 1
fi

PARTIAL_TEXT=$(sh scripts/compose-role.sh "$PARTIAL_DIR")

if printf '%s' "$PARTIAL_TEXT" | grep -q "$LICENCE_PHRASE"; then
  echo "FAIL: Licence-policy instruction found in the partial composition." >&2
  echo "      This means the instruction is NOT removed when backend-developer" >&2
  echo "      is omitted — the parent is not load-bearing." >&2
  FAILED=1
fi

# ── Step 3: confirm the two compositions differ ───────────────────────────────
if [ "$FULL_TEXT" = "$PARTIAL_TEXT" ]; then
  echo "FAIL: Full and partial compositions are identical — no difference." >&2
  FAILED=1
fi

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: Backend Developer is load-bearing."
echo "  Full composition contains the licence-policy instruction."
echo "  Partial composition (backend-developer omitted) does not."
echo "  The composed output differs in a way that changes the role's behaviour."
