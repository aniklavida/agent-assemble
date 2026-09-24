#!/usr/bin/env bash
# check-public-docs.sh — verify the public-documentation invariants.
#
# Three things are checked, each because a claim is otherwise unverifiable:
#
#   1. Claim and limit travel together.
#      The tool's value proposition ("a role, a place in a process, and a memory
#      that survives the session") must appear in the same paragraph as its limit
#      ("any guarantee the agent read the skill, followed it, or did what it
#      said"). A paragraph may not carry one without the other. This is the one
#      pairing the README may not split.
#
#   2. The README carries the sections a stranger needs.
#      What the tool is not, a five-minute start, the host matrix it points at,
#      and known limitations. The matrix itself lives once in docs/ARCHITECTURE.md;
#      the README must link to it rather than restate it.
#
#   3. Public documents do not name a reference project.
#      The only external repository URL permitted is this project's own. A named
#      prior-art project without a URL cannot be caught mechanically; that gap is
#      stated in docs/DOGFOOD.md rather than papered over.
#
# Usage:
#   scripts/check-public-docs.sh [TARGET_DIR]
#   scripts/check-public-docs.sh --self-test
#
# Exit status:
#   0  all invariants hold
#   1  an invariant is violated

set -euo pipefail

TARGET_DIR="${1:-.}"

# Public narrative documents. Board cards and process records are deliberately
# excluded: they are working state, not published guidance.
public_files() {
  local dir="$1"
  local f
  for f in "$dir/README.md" "$dir/CONTRIBUTING.md" "$dir/SECURITY.md" "$dir/CODE_OF_CONDUCT.md"; do
    [ -f "$f" ] && printf '%s\n' "$f"
  done
  if [ -d "$dir/docs" ]; then
    find "$dir/docs" -maxdepth 1 -name '*.md' | sort
  fi
}

check_pairing() {
  local file="$1"
  awk '
    BEGIN { RS = ""; FS = "\n" }
    {
      p = $0
      claim = (p ~ /What it provides:/ && p ~ /a role, a place in a process, and a memory/)
      limit = (p ~ /What it cannot provide:/ && p ~ /guarantee/ && (p ~ /read the skill/ || p ~ /followed it/))
      if (claim != limit) {
        if (claim)
          print "FAIL: " FILENAME " states the value proposition without its limit in the same paragraph." > "/dev/stderr"
        else
          print "FAIL: " FILENAME " states the limit without the value proposition in the same paragraph." > "/dev/stderr"
        bad = 1
      }
    }
    END { exit bad }
  ' "$file" || return 1
}

check_readme_sections() {
  local file="$1"
  local failed=0 s
  for s in "what it is not" "five-minute start" "known limitations"; do
    if ! grep -qi "$s" "$file"; then
      echo "FAIL: README.md has no \"$s\" section." >&2
      failed=1
    fi
  done
  if ! grep -q 'docs/ARCHITECTURE.md' "$file"; then
    echo "FAIL: README.md does not link to the host matrix in docs/ARCHITECTURE.md." >&2
    failed=1
  fi
  return "$failed"
}

check_authoring() {
  local file="$1"
  local failed=0 s
  if [ ! -f "$file" ]; then
    echo "FAIL: docs/AUTHORING.md is missing." >&2
    return 1
  fi
  for s in "Purpose" "Preconditions" "Steps" "Completion signal" "Failure handling"; do
    grep -qi "$s" "$file" || { echo "FAIL: docs/AUTHORING.md does not cover the role section \"$s\"." >&2; failed=1; }
  done
  for s in "Advisory" "Prescriptive" "Perspective"; do
    grep -qi "$s" "$file" || { echo "FAIL: docs/AUTHORING.md does not cover the principle mode \"$s\"." >&2; failed=1; }
  done
  for s in "Create Card" "Move Card" "Read Card" "Append Log"; do
    # The operation must be defined as a term (**Name**), not merely mentioned.
    # A plain substring appears in surrounding prose and proves nothing.
    grep -qF "**$s**" "$file" || { echo "FAIL: docs/AUTHORING.md does not define the board operation \"$s\"." >&2; failed=1; }
  done
  return "$failed"
}

check_dogfood() {
  local file="$1"
  if [ ! -f "$file" ]; then
    echo "FAIL: docs/DOGFOOD.md is missing." >&2
    return 1
  fi
  grep -qi 'went wrong\|friction' "$file" || { echo "FAIL: docs/DOGFOOD.md does not report what went wrong." >&2; return 1; }
}

check_single_matrix() {
  local dir="$1" hits
  hits="$(public_files "$dir" | xargs grep -lE '^\|[[:space:]]*\*{0,2}Host\*{0,2}[[:space:]]*\|' 2>/dev/null | wc -l | tr -d ' ')"
  if [ "$hits" != "1" ]; then
    echo "FAIL: the host-support matrix must be published in exactly one public document (found $hits)." >&2
    return 1
  fi
}

check_no_reference_names() {
  local dir="$1" failed=0 hit
  hit="$(public_files "$dir" | xargs grep -hoE 'https?://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+' 2>/dev/null \
    | grep -v 'github.com/aniklavida/agent-assemble' || true)"
  if [ -n "$hit" ]; then
    echo "FAIL: a public document names an external repository:" >&2
    printf '  %s\n' "$hit" >&2
    failed=1
  fi
  return "$failed"
}

run_checks() {
  local dir="$1" failed=0 f
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    check_pairing "$f" || failed=1
  done < <(public_files "$dir")

  [ -f "$dir/README.md" ] || { echo "FAIL: README.md is missing." >&2; failed=1; }
  [ -f "$dir/README.md" ] && { check_readme_sections "$dir/README.md" || failed=1; }
  check_authoring "$dir/docs/AUTHORING.md" || failed=1
  check_dogfood "$dir/docs/DOGFOOD.md" || failed=1
  check_single_matrix "$dir" || failed=1
  check_no_reference_names "$dir" || failed=1

  return "$failed"
}

run_self_tests() {
  echo "Running check-public-docs.sh self-tests..."
  local tmp script_path
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  script_path="$(cd "$(dirname "$0")" && pwd)/check-public-docs.sh"

  mkdir -p "$tmp/t1/docs"
  cat <<'EOF' > "$tmp/t1/README.md"
# T
**What it provides:** a role, a place in a process, and a memory that survives the session.
EOF
  if bash "$script_path" "$tmp/t1" >/dev/null 2>&1; then
    echo "FAIL: self-test 1 — uncoupled claim was accepted." >&2; exit 1
  fi
  echo "PASS: self-test 1 — a claim without its limit is refused."

  mkdir -p "$tmp/t2/docs"
  cat <<'EOF' > "$tmp/t2/README.md"
# T
**What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said.
EOF
  if bash "$script_path" "$tmp/t2" >/dev/null 2>&1; then
    echo "FAIL: self-test 2 — uncoupled limit was accepted." >&2; exit 1
  fi
  echo "PASS: self-test 2 — a limit without its claim is refused."

  mkdir -p "$tmp/t3/docs"
  cat <<'EOF' > "$tmp/t3/README.md"
# T
**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said.

## What it is not
## Five-minute start
## Known limitations
See docs/ARCHITECTURE.md for the host matrix.
EOF
  cat <<'EOF' > "$tmp/t3/docs/ARCHITECTURE.md"
# Architecture
| Host | Pointer file | Status | Substantiation |
|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | Mechanically verified | pointer resolves |
EOF
  cat <<'EOF' > "$tmp/t3/docs/AUTHORING.md"
Purpose Preconditions Steps Completion signal Failure handling Advisory Prescriptive Perspective **Create Card** **Move Card** **Read Card** **Append Log**
EOF
  cat <<'EOF' > "$tmp/t3/docs/DOGFOOD.md"
# Dogfood
What went wrong: nothing was recorded.
EOF
  if ! bash "$script_path" "$tmp/t3" >/dev/null 2>&1; then
    echo "FAIL: self-test 3 — a complete, paired document set was rejected." >&2; exit 1
  fi
  echo "PASS: self-test 3 — a complete, paired document set passes."

  mkdir -p "$tmp/t4/docs"
  cat <<'EOF' > "$tmp/t4/README.md"
# T
**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said.

## Five-minute start
## Known limitations
See docs/ARCHITECTURE.md.
EOF
  cat <<'EOF' > "$tmp/t4/docs/AUTHORING.md"
Purpose Preconditions Steps Completion signal Failure handling Advisory Prescriptive Perspective **Create Card** **Move Card** **Read Card** **Append Log**
EOF
  cat <<'EOF' > "$tmp/t4/docs/DOGFOOD.md"
What went wrong.
EOF
  if bash "$script_path" "$tmp/t4" >/dev/null 2>&1; then
    echo "FAIL: self-test 4 — a README missing \"what it is not\" was accepted." >&2; exit 1
  fi
  echo "PASS: self-test 4 — a README missing a required section is refused."

  mkdir -p "$tmp/t5/docs"
  cat <<'EOF' > "$tmp/t5/README.md"
# T
**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said.

## What it is not
## Five-minute start
## Known limitations
This borrows from https://github.com/example/prior-art-project wholesale.
See docs/ARCHITECTURE.md.
EOF
  cat <<'EOF' > "$tmp/t5/docs/AUTHORING.md"
Purpose Preconditions Steps Completion signal Failure handling Advisory Prescriptive Perspective **Create Card** **Move Card** **Read Card** **Append Log**
EOF
  cat <<'EOF' > "$tmp/t5/docs/DOGFOOD.md"
What went wrong.
EOF
  if bash "$script_path" "$tmp/t5" >/dev/null 2>&1; then
    echo "FAIL: self-test 5 — a named external repository was accepted." >&2; exit 1
  fi
  echo "PASS: self-test 5 — a named external repository is refused."

  mkdir -p "$tmp/t6/docs"
  cat <<'EOF' > "$tmp/t6/README.md"
# T
**What it provides:** a role, a place in a process, and a memory that survives the session. **What it cannot provide:** any guarantee the agent read the skill, followed it, or did what it said.

## What it is not
## Five-minute start
## Known limitations
| Host | Pointer file | Status | Substantiation |
|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | Mechanically verified | pointer resolves |
See docs/ARCHITECTURE.md.
EOF
  cat <<'EOF' > "$tmp/t6/docs/ARCHITECTURE.md"
# Architecture
| Host | Pointer file | Status | Substantiation |
|---|---|---|---|
| **Claude Code** | `CLAUDE.md` | Mechanically verified | pointer resolves |
EOF
  cat <<'EOF' > "$tmp/t6/docs/AUTHORING.md"
Purpose Preconditions Steps Completion signal Failure handling Advisory Prescriptive Perspective **Create Card** **Move Card** **Read Card** **Append Log**
EOF
  cat <<'EOF' > "$tmp/t6/docs/DOGFOOD.md"
What went wrong.
EOF
  if bash "$script_path" "$tmp/t6" >/dev/null 2>&1; then
    echo "FAIL: self-test 6 — a duplicated host matrix was accepted." >&2; exit 1
  fi
  echo "PASS: self-test 6 — a second host matrix is refused."

  echo "PASS: all check-public-docs.sh self-tests passed."
  exit 0
}

if [ "$TARGET_DIR" = "--self-test" ]; then
  run_self_tests
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "FAIL: target directory \"$TARGET_DIR\" does not exist." >&2
  exit 1
fi

if run_checks "$TARGET_DIR"; then
  echo "PASS: claim and limit are paired, README sections are present, authoring guide is complete, dogfood is reported, and no reference project is named."
else
  exit 1
fi
