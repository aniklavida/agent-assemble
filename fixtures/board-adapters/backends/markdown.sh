#!/usr/bin/env bash
# markdown.sh — executable test double for board/references/adapters/markdown.md.
#
# This is test infrastructure, not shipped content. It exists so
# scripts/check-board-adapters.sh can run the four contract operations against
# the same filesystem mechanics the adapter page prescribes. The shipped
# implementation is the page of instructions; this double is what proves two
# backends can be observably equivalent.

board_create() {
  local root="$1" id="$2" title="$3"
  local dir="$root/board/todo"
  mkdir -p "$dir"
  cat > "$dir/$id.md" <<CARD
---
id: "$id"
title: "$title"
size: "short"
status: "todo"
assigned_role: "BA"
created_at: "2026-01-01T00:00:00Z"
updated_at: "2026-01-01T00:00:00Z"
---

## Context & Request
Contract equivalence probe.

## Acceptance Criteria
- [ ] Probe completes
CARD
}

board_move() {
  local root="$1" id="$2" status="$3" role="$4"
  local src dst file
  file="$(find "$root/board" -name "$id.md" -print -quit 2>/dev/null || true)"
  [ -n "$file" ] || { echo "board_move: no card $id" >&2; return 1; }
  src="$file"
  dst="$root/board/$status/$id.md"
  mkdir -p "$root/board/$status"
  sed -e "s/^status: .*/status: \"$status\"/" \
      -e "s/^assigned_role: .*/assigned_role: \"$role\"/" \
      -e "s/^updated_at: .*/updated_at: \"2026-01-01T00:01:00Z\"/" \
      "$src" > "$dst"
  rm -f "$src"
}

board_read() {
  local root="$1" id="$2" file
  file="$(find "$root/board" -name "$id.md" -print -quit 2>/dev/null || true)"
  [ -n "$file" ] || { echo "board_read: no card $id" >&2; return 1; }
  awk -F': ' '/^(id|title|status|assigned_role):/ {gsub(/"/, "", $2); print $1 "=" $2}' "$file"
  if grep -q '^- \[ \] Probe completes' "$file"; then
    printf 'body=Probe completes\n'
  else
    printf 'body=MISSING\n'
  fi
}

board_append_log() {
  local root="$1" id="$2" event="$3" role="$4" summary="$5" next="$6"
  mkdir -p "$root/log"
  [ -f "$root/log/LOG.md" ] || printf '| Timestamp | Card ID | Event | Role | Summary / Evidence | Result / Next State |\n|---|---|---|---|---|---|\n' > "$root/log/LOG.md"
  printf '| %s | %s | %s | %s | %s | %s |\n' \
    "2026-01-01T00:02:00Z" "$id" "$event" "$role" "$summary" "$next" >> "$root/log/LOG.md"
}

board_read_log() {
  local root="$1" id="$2"
  awk -F'|' -v id="$id" 'index($0, "| " id " |") {gsub(/^ +| +$/, "", $4); print $4}' "$root/log/LOG.md"
}
