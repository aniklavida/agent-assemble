#!/bin/sh
set -eu

FIXTURE_DIR="${1:-fixtures/drift-reconciliation}"

if [ ! -d "$FIXTURE_DIR" ]; then
  echo "FAIL: Fixture directory $FIXTURE_DIR does not exist." >&2
  exit 1
fi

DOC_DECISIONS="$FIXTURE_DIR/documentation/decisions/decided-deferred.md"
BOARD_TODO_101="$FIXTURE_DIR/board/todo/TASK-101.md"
BOARD_IN_PROG_102="$FIXTURE_DIR/board/in-progress/TASK-102.md"
BOARD_IN_PROG_103="$FIXTURE_DIR/board/in-progress/TASK-103.md"
BOARD_TODO_104="$FIXTURE_DIR/board/todo/TASK-104.md"
BOARD_DONE_100="$FIXTURE_DIR/board/done/TASK-100.md"
LOG_FILE="$FIXTURE_DIR/log/LOG.md"

# Invariant 1: Changing documentation surfaces and reconciles dependent item (TASK-101)
if ! grep -q "File spool directory" "$DOC_DECISIONS"; then
  echo "FAIL: Documentation edit DEC-004 (File spool directory) not found in $DOC_DECISIONS" >&2
  exit 1
fi

if [ ! -f "$BOARD_TODO_101" ]; then
  echo "FAIL: Reconciled item $BOARD_TODO_101 does not exist" >&2
  exit 1
fi

if ! grep -q "file spool directory" "$BOARD_TODO_101"; then
  echo "FAIL: TASK-101 acceptance criteria was not updated to file spool directory" >&2
  exit 1
fi

# Invariant 2: Stale item that cannot be reconciled is flagged with what changed beneath it, not deleted (TASK-102)
if [ ! -f "$BOARD_IN_PROG_102" ]; then
  echo "FAIL: TASK-102 was deleted instead of being flagged" >&2
  exit 1
fi

if ! grep -q 'drift_status: "flagged"' "$BOARD_IN_PROG_102"; then
  echo "FAIL: TASK-102 missing drift_status: \"flagged\"" >&2
  exit 1
fi

if ! grep -q 'assigned_role: "user"' "$BOARD_IN_PROG_102"; then
  echo "FAIL: TASK-102 assigned_role must be set to \"user\" when blocked" >&2
  exit 1
fi

if ! grep -q "blocked_on:" "$BOARD_IN_PROG_102"; then
  echo "FAIL: TASK-102 missing blocked_on explanation" >&2
  exit 1
fi

if ! grep -q '\[DRIFT_DETECTED\]' "$BOARD_IN_PROG_102"; then
  echo "FAIL: TASK-102 missing [DRIFT_DETECTED] status indicator" >&2
  exit 1
fi

if ! grep -q "What changed beneath it:" "$BOARD_IN_PROG_102"; then
  echo "FAIL: TASK-102 missing explicit 'What changed beneath it:' explanation" >&2
  exit 1
fi

# Invariant 3: Reconciliation and drift events appear in log
if [ ! -f "$LOG_FILE" ]; then
  echo "FAIL: Log file $LOG_FILE does not exist" >&2
  exit 1
fi

if ! grep -E 'TASK-101 \| CARD_RECONCILED' "$LOG_FILE" >/dev/null; then
  echo "FAIL: Missing CARD_RECONCILED log entry for TASK-101" >&2
  exit 1
fi

if ! grep -E 'TASK-102 \| DRIFT_DETECTED' "$LOG_FILE" >/dev/null; then
  echo "FAIL: Missing DRIFT_DETECTED log entry for TASK-102" >&2
  exit 1
fi

# Invariant 4: Cards unaffected by the change are left alone — zero false positives (TASK-103, TASK-104, TASK-100)
for unaffected in "$BOARD_IN_PROG_103" "$BOARD_TODO_104" "$BOARD_DONE_100"; do
  if [ ! -f "$unaffected" ]; then
    echo "FAIL: Unaffected item $unaffected missing" >&2
    exit 1
  fi
  if grep -qi "DRIFT_DETECTED" "$unaffected"; then
    echo "FAIL: False positive: unaffected item $unaffected contains DRIFT_DETECTED" >&2
    exit 1
  fi
  if grep -qi 'drift_status: "flagged"' "$unaffected"; then
    echo "FAIL: False positive: unaffected item $unaffected flagged with drift_status" >&2
    exit 1
  fi
done

# Verify log has no false positive drift entries for unaffected items
if grep -E 'TASK-10(0|3|4) \| (DRIFT_DETECTED|CARD_RECONCILED)' "$LOG_FILE" >/dev/null; then
  echo "FAIL: False positive drift log entry found for unaffected items" >&2
  exit 1
fi

echo "PASS: Documentation drift reconciliation fixture verified (surfaced, flagged, logged, zero false positives)."
