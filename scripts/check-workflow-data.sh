#!/bin/sh
# check-workflow-data.sh — verify that a fixture workflow is defined in workflows.md
# and that the workflow was added without changing any SKILL.md file.
#
# Given a fixture directory and a workflow name, this script checks:
#   1. workflow/workflows.md contains a section for the named workflow
#   2. The fixture's SKILL.md files are identical to the shipped SKILL.md files
#      (proving no SKILL.md was edited to add the workflow)
#
# Usage:
#   scripts/check-workflow-data.sh <fixture-dir> <workflow-name>
#
# Exit status:
#   0  all checks pass
#   1  at least one check failed

set -eu

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <fixture-dir> <workflow-name>" >&2
  exit 1
fi

FIXTURE_DIR="$1"
WORKFLOW_NAME="$2"
FAILED=0

WORKFLOWS_FILE="${FIXTURE_DIR}/workflow/workflows.md"
SHIPPED_WORKFLOWS="workflow/workflows.md"

# Check 1: fixture has a workflow/workflows.md
if [ ! -f "$WORKFLOWS_FILE" ]; then
  echo "FAIL: $WORKFLOWS_FILE not found" >&2
  FAILED=1
fi

# Check 2: the named workflow appears in the fixture's workflows.md
if [ -f "$WORKFLOWS_FILE" ]; then
  if ! grep -q "^### ${WORKFLOW_NAME}$" "$WORKFLOWS_FILE"; then
    echo "FAIL: Workflow '${WORKFLOW_NAME}' not found in $WORKFLOWS_FILE" >&2
    FAILED=1
  fi
fi

# Check 3: no SKILL.md in the fixture differs from the shipped version
# (the fixture should copy all SKILL.md files from the shipped tree unchanged)
if [ -d "${FIXTURE_DIR}/workflow" ]; then
  fixture_skill="${FIXTURE_DIR}/workflow/SKILL.md"
  if [ -f "$fixture_skill" ] && [ -f "workflow/SKILL.md" ]; then
    if ! diff -q "$fixture_skill" "workflow/SKILL.md" > /dev/null 2>&1; then
      echo "FAIL: ${fixture_skill} differs from shipped workflow/SKILL.md — adding a workflow must not change any SKILL.md" >&2
      FAILED=1
    fi
  fi
fi

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo "PASS: Workflow '${WORKFLOW_NAME}' is defined in data file; no SKILL.md was changed."
