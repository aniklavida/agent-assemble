#!/usr/bin/env bash
# linear.sh — local stand-in for the Linear MCP/API transport.
#
# Test infrastructure, not shipped content. CI has no network connection and no
# API key, so this double implements the same four operations
# board/references/adapters/linear.md prescribes — create an issue, move it
# between states, read it, comment on it — against local files. The card/state/
# comment mapping is the same one the adapter page describes.

_issue_file() {
  printf '%s/.linear-stub/%s.issue' "$1" "$2"
}

board_create() {
  local root="$1" id="$2" title="$3"
  mkdir -p "$root/.linear-stub"
  cat > "$(_issue_file "$root" "$id")" <<ISSUE
id $id
title $title
status todo
assigned_role BA
body Probe completes
ISSUE
}

board_move() {
  local root="$1" id="$2" status="$3" role="$4"
  local file tmp
  file="$(_issue_file "$root" "$id")"
  [ -f "$file" ] || { echo "board_move: no issue $id" >&2; return 1; }
  tmp="$file.tmp"
  awk -v st="$status" -v rl="$role" '
    /^status /{print "status " st; next}
    /^assigned_role /{print "assigned_role " rl; next}
    {print}' "$file" > "$tmp"
  mv "$tmp" "$file"
}

board_read() {
  local root="$1" id="$2" file
  file="$(_issue_file "$root" "$id")"
  [ -f "$file" ] || { echo "board_read: no issue $id" >&2; return 1; }
  awk '/^(id|title|status|assigned_role) /{print $1 "=" substr($0, index($0, $2))}' "$file"
  printf 'body=Probe completes\n'
}

board_append_log() {
  local root="$1" id="$2" event="$3" role="$4" summary="$5" next="$6"
  mkdir -p "$root/.linear-stub"
  printf '%s\t%s\t%s\t%s\n' "$event" "$role" "$summary" "$next" >> "$root/.linear-stub/$id.comments"
}

board_read_log() {
  local root="$1" id="$2"
  local file="$root/.linear-stub/$id.comments"
  [ -f "$file" ] || return 0
  awk -F'\t' '{print $1}' "$file"
}
