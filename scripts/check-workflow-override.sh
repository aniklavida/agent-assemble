#!/bin/sh
# check-workflow-override.sh — verify the project override mechanism.
#
# Given a fixture directory, this script checks:
#   1. A project override exists at <fixture>/.agent-assemble/roles/<role>/SKILL.md
#   2. The built-in default exists at <fixture>/employees/<role>/SKILL.md
#   3. The fixture log contains a ROLE_OVERRIDE entry for the overridden role
#   4. The ROLE_OVERRIDE entry names the project override path
#
# The resolution order is: project override wins over built-in default.
# A used override MUST appear in the log before the role's first action.
#
# Usage:
#   scripts/check-workflow-override.sh <fixture-dir> <role-name>
#
# Exit status:
#   0  all checks pass
#   1  at least one check failed

set -eu

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <fixture-dir> <role-name>" >&2
  exit 1
fi

FIXTURE_DIR="$1"
ROLE_NAME="$2"
FAILED=0

OVERRIDE_PATH="${FIXTURE_DIR}/.agent-assemble/roles/${ROLE_NAME}/SKILL.md"
BUILTIN_PATH="${FIXTURE_DIR}/employees/${ROLE_NAME}/SKILL.md"
LOG_PATH="${FIXTURE_DIR}/log/LOG.md"

# Check 1: override file exists
if [ ! -f "$OVERRIDE_PATH" ]; then
  echo "FAIL: Project override not found at $OVERRIDE_PATH" >&2
  FAILED=1
fi

# Check 2: built-in default exists (the thing being overridden must exist too)
if [ ! -f "$BUILTIN_PATH" ]; then
  echo "FAIL: Built-in default not found at $BUILTIN_PATH" >&2
  FAILED=1
fi

# Check 3: log exists
if [ ! -f "$LOG_PATH" ]; then
  echo "FAIL: Log file not found at $LOG_PATH" >&2
  FAILED=1
fi

# Only run log checks if all files exist
if [ "$FAILED" -eq 0 ]; then

  # Check 4: log contains a ROLE_OVERRIDE entry
  if ! grep -q "ROLE_OVERRIDE" "$LOG_PATH"; then
    echo "FAIL: Log at $LOG_PATH contains no ROLE_OVERRIDE entry" >&2
    FAILED=1
  fi

  # Check 5: ROLE_OVERRIDE entry names the project override path
  override_rel=".agent-assemble/roles/${ROLE_NAME}/SKILL.md"
  if ! grep "ROLE_OVERRIDE" "$LOG_PATH" | grep -q "$override_rel"; then
    echo "FAIL: ROLE_OVERRIDE entry does not name the override path ($override_rel)" >&2
    FAILED=1
  fi

  # Check 6: override file contains different content from built-in
  # (if they are identical the override is decorative)
  if diff -q "$OVERRIDE_PATH" "$BUILTIN_PATH" > /dev/null 2>&1; then
    echo "FAIL: Override $OVERRIDE_PATH is identical to built-in $BUILTIN_PATH — override is decorative" >&2
    FAILED=1
  fi

fi

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: Override resolution verified — project override wins, logged, and differs from built-in."
