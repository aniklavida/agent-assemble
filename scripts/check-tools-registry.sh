#!/bin/sh
# check-tools-registry.sh — verify the tools registry, its licence policy and
# constraint-filtered suggestions.
#
# Checks five properties the tools registry must satisfy:
#
#   1. Detection reads a repository's root manifests (package.json, go.mod,
#      requirements.txt, Cargo.toml) and container image tags, and summarises
#      the declared inventory. Run against a manifest-bearing fixture it
#      produces the exact expected inventory; run against this repository it
#      reports the truth — no manifests, no declared dependencies.
#   2. A suggestion request returns only options that pass the project's own
#      constraints (licence policy, cost ceiling, vendor lock). A candidate
#      that violates the licence policy does not appear at all — not even
#      with a caveat.
#   3. A compiled dependency with a non-permissive licence is refused, naming
#      the licence and the rule it violates.
#   4. A container image tag that masks a licence change is caught before
#      adoption: redis:7-alpine resolves to Redis 7.4.0 under RSALv2 and is
#      refused, naming the tag, the resolved version, the licence and the rule.
#   5. Detection is a candidate list, not an adoption, so it never blocks:
#      detection mode exits 0 even when it finds something, and prints the
#      confirmation prompt.
#
# Detection mode is invoked separately:
#   scripts/check-tools-registry.sh --detect <dir>
#
# Usage:
#   scripts/check-tools-registry.sh                          # all fixture checks
#   scripts/check-tools-registry.sh <fixture-root>           # checks at a given root
#   scripts/check-tools-registry.sh --detect <dir>           # detection mode
#
# Exit status:
#   0  all fixture checks pass (or detection completed)
#   1  at least one fixture check failed

set -eu

# ── licence policy predicates ──────────────────────────────────────────────────

# always_denied <licence>
# 0 when the licence may never be adopted, regardless of process boundary.
always_denied() {
  _ad_lic=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  case "$_ad_lic" in
    sspl*|bsl*|busl*|rsal*|elastic*|rpl*|*gated*) return 0 ;;
  esac
  return 1
}

# permissive <licence>
# 0 when the licence may be compiled into user code.
permissive() {
  _perm_lic=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  case "$_perm_lic" in
    mit|apache-2.0|apache2|bsd|bsd-2-clause|bsd-3-clause) return 0 ;;
  esac
  return 1
}

# decide <name> <kind> <licence> [context]
# Prints an ALLOW or REFUSE line. A refusal names the component, the licence and
# the rule it breaks. Context, when given, leads the reason clause.
decide() {
  _name="$1"; _kind="$2"; _lic="$3"; _ctx="${4:-}"
  if always_denied "$_lic"; then
    printf 'REFUSE %s (%s; %s) — %slicence %s is on the never-adopt list (rule: never-adopt-gated-licences).\n' \
      "$_name" "$_kind" "$_lic" "$_ctx" "$_lic"
    return 1
  fi
  if [ "$_kind" = "compiled" ] && ! permissive "$_lic"; then
    printf 'REFUSE %s (%s; %s) — %s%s is not permissive and the component is compiled into user code (rule: compiled-requires-permissive).\n' \
      "$_name" "$_kind" "$_lic" "$_ctx" "$_lic"
    return 1
  fi
  printf 'ALLOW %s (%s; %s)\n' "$_name" "$_kind" "$_lic"
  return 0
}

# ── detection mode ─────────────────────────────────────────────────────────────

# detect_output <dir>
# Prints the declared inventory of a repository. Always succeeds. Detection is
# a candidate list for confirmation, never an adoption and never a block.
detect_output() {
  _target="$1"
  echo "Scanning $_target for root manifests and container image tags..." >&2

  _deps_pkg=$(mktemp)
  _deps_go=$(mktemp)
  _deps_req=$(mktemp)
  _deps_cargo=$(mktemp)
  _imgs=$(mktemp)
  _manifest_count=0

  if [ -f "$_target/package.json" ]; then
    _manifest_count=$((_manifest_count + 1))
    awk -F'"' '
      /^[[:space:]]*"dependencies"[[:space:]]*:/ { in_dep=1; next }
      /^[[:space:]]*"devDependencies"[[:space:]]*:/ { in_dep=1; next }
      in_dep && /^[[:space:]]*}/ { in_dep=0; next }
      in_dep && NF>=4 && $4 != "" { print $2 " " $4 }
    ' "$_target/package.json" >> "$_deps_pkg"
  fi

  if [ -f "$_target/go.mod" ]; then
    _manifest_count=$((_manifest_count + 1))
    awk '
      /^require[[:space:]]*\(/ { in_req=1; next }
      in_req && /^\)/ { in_req=0; next }
      /^require[[:space:]]+/ { print $2 " " $3; next }
      in_req && NF>=2 && $1 !~ /^\/\// { print $1 " " $2 }
    ' "$_target/go.mod" >> "$_deps_go"
  fi

  if [ -f "$_target/requirements.txt" ]; then
    _manifest_count=$((_manifest_count + 1))
    sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$_target/requirements.txt" \
      | sed -e 's/==/ /' -e 's/\([<>=!~]=\)/ \1/' >> "$_deps_req"
  fi

  if [ -f "$_target/Cargo.toml" ]; then
    _manifest_count=$((_manifest_count + 1))
    awk -F'=' '
      /^\[dependencies\]/ { in_dep=1; next }
      /^\[dev-dependencies\]/ { in_dep=1; next }
      /^\[/ { in_dep=0 }
      in_dep && NF>=2 {
        name=$1; gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
        ver=$2; gsub(/^[[:space:]]+|[[:space:]]+$/, "", ver); gsub(/"/, "", ver)
        if (name != "") print name " " ver
      }
    ' "$_target/Cargo.toml" >> "$_deps_cargo"
  fi

  for _f in "$_target"/docker-compose.yml "$_target"/docker-compose.yaml \
            "$_target"/compose.yml "$_target"/compose.yaml "$_target"/Dockerfile; do
    [ -f "$_f" ] || continue
    sed -n -e 's/^[[:space:]]*image:[[:space:]]*//p' "$_f" >> "$_imgs"
    sed -n -e 's/^FROM[[:space:]]\+\([^[:space:]]*\).*/\1/p' "$_f" >> "$_imgs"
  done
  sort -u "$_imgs" -o "$_imgs"

  _dep_count=$(( $(wc -l < "$_deps_pkg" | tr -d ' ') + $(wc -l < "$_deps_go" | tr -d ' ') \
    + $(wc -l < "$_deps_req" | tr -d ' ') + $(wc -l < "$_deps_cargo" | tr -d ' ') ))
  _img_count=$(wc -l < "$_imgs" | tr -d ' ')

  echo "Tool inventory:"
  echo "Manifests detected: $_manifest_count"
  echo "Declared dependencies: $_dep_count"
  echo "Container images: $_img_count"
  echo ""

  if [ "$_manifest_count" -eq 0 ]; then
    echo "No manifests found (package.json, go.mod, requirements.txt, Cargo.toml)."
  fi

  if [ -s "$_deps_pkg" ]; then
    echo "package.json:"
    sort -u "$_deps_pkg" | sed 's/^/  /'
    echo ""
  fi
  if [ -s "$_deps_go" ]; then
    echo "go.mod:"
    sort -u "$_deps_go" | sed 's/^/  /'
    echo ""
  fi
  if [ -s "$_deps_req" ]; then
    echo "requirements.txt:"
    sort -u "$_deps_req" | sed 's/^/  /'
    echo ""
  fi
  if [ -s "$_deps_cargo" ]; then
    echo "Cargo.toml:"
    sort -u "$_deps_cargo" | sed 's/^/  /'
    echo ""
  fi
  if [ -s "$_imgs" ]; then
    echo "container images:"
    sort -u "$_imgs" | sed 's/^/  /'
    echo ""
  fi

  echo "Detection is a candidate list, not an adoption. Confirm each before use."

  rm -f "$_deps_pkg" "$_deps_go" "$_deps_req" "$_deps_cargo" "$_imgs"
}

if [ "${1:-}" = "--detect" ]; then
  detect_output "${2:-.}"
  exit 0
fi

# ── fixture mode ───────────────────────────────────────────────────────────────

FIXTURE_ROOT="${1:-fixtures/tools-registry}"
FAILED=0

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

# filter_candidates <constraints> <candidates>
# Prints only the candidates that pass every constraint. Refused candidates are
# removed, not annotated.
filter_candidates() {
  _constraints="$1"
  _candidates="$2"

  _ceiling=$(awk -F'|' '/cost_ceiling_usd_month/ { gsub(/[^0-9]/, "", $3); print $3 }' "$_constraints")
  [ -n "$_ceiling" ] || _ceiling=0
  _paid=$(awk -F'|' '/already_paid_for/ { v=$3; gsub(/^[[:space:]]+|[[:space:]]+$/, "", v); print v }' "$_constraints")

  awk -F'|' '
    {
      name=$2; kind=$3; lic=$4; cost=$5; lock=$6
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", name)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", kind)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", lic)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", cost)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", lock)
      if (name == "" || name == "Candidate") next
      if (name ~ /^-+$/) next
      print name "|" kind "|" lic "|" cost "|" lock
    }
  ' "$_candidates" | while IFS='|' read -r _name _kind _lic _cost _lock; do
    _cost_num=$(printf '%s' "$_cost" | tr -cd '0-9')
    [ -n "$_cost_num" ] || _cost_num=0

    if always_denied "$_lic"; then
      continue
    fi
    if [ "$_kind" = "compiled" ] && ! permissive "$_lic"; then
      continue
    fi
    if [ "$_cost_num" -gt "$_ceiling" ]; then
      continue
    fi
    if [ "$_lock" = "yes" ]; then
      case ",$_paid," in
        *",$_name,"*) : ;;
        *) continue ;;
      esac
    fi

    decide "$_name" "$_kind" "$_lic"
  done
}

# ── Check 1: detect this repository and a manifest-bearing fixture ─────────────

DETECT_DIR="$FIXTURE_ROOT/detect"

if [ ! -d "$DETECT_DIR/repo" ]; then
  echo "FAIL (detect): fixture repository not found at $DETECT_DIR/repo." >&2
  FAILED=1
else
  detect_output "$DETECT_DIR/repo" > "$TMP/detect-repo.out" 2>/dev/null
  if diff -u "$DETECT_DIR/repo-expected.txt" "$TMP/detect-repo.out" > "$TMP/detect-repo.diff" 2>&1; then
    echo "PASS (detect/fixture): all four manifest types and the image tags were inventoried as expected."
  else
    echo "FAIL (detect/fixture): detected inventory does not match the expected inventory." >&2
    cat "$TMP/detect-repo.diff" >&2
    FAILED=1
  fi

  detect_output "$REPO_ROOT" > "$TMP/detect-self.out" 2>/dev/null
  if diff -u "$DETECT_DIR/self-expected.txt" "$TMP/detect-self.out" > "$TMP/detect-self.diff" 2>&1; then
    echo "PASS (detect/self): this repository reports no manifests and no declared dependencies."
  else
    echo "FAIL (detect/self): inventory of this repository does not match expectation." >&2
    cat "$TMP/detect-self.diff" >&2
    FAILED=1
  fi

  # Detection never blocks: finding manifests must still exit 0.
  if detect_output "$DETECT_DIR/repo" > /dev/null 2>&1; then
    echo "PASS (detect/non-blocking): detection exits 0 even when it finds manifests."
  else
    echo "FAIL (detect/non-blocking): detection exited non-zero — detection must never block." >&2
    FAILED=1
  fi
fi

# ── Check 2: suggestions are filtered by the project's own constraints ────────

SUGGEST_DIR="$FIXTURE_ROOT/suggestion"

if [ ! -s "$SUGGEST_DIR/request.md" ]; then
  echo "FAIL (suggest): no suggestion request at $SUGGEST_DIR/request.md." >&2
  FAILED=1
elif [ ! -s "$SUGGEST_DIR/constraints.md" ] || [ ! -s "$SUGGEST_DIR/candidates.md" ]; then
  echo "FAIL (suggest): constraints.md or candidates.md missing from $SUGGEST_DIR." >&2
  FAILED=1
else
  filter_candidates "$SUGGEST_DIR/constraints.md" "$SUGGEST_DIR/candidates.md" > "$TMP/suggest.out"
  if diff -u "$SUGGEST_DIR/expected-filtered.md" "$TMP/suggest.out" > "$TMP/suggest.diff" 2>&1; then
    echo "PASS (suggest): the returned options are exactly the candidates that pass every constraint."
  else
    echo "FAIL (suggest): filtered options do not match the expected short list." >&2
    cat "$TMP/suggest.diff" >&2
    FAILED=1
  fi

  # A refused candidate is absent entirely — no warning, no caveat.
  for _rejected in redis-server elasticsearch datadog-agent sentry-hosted; do
    if grep -q "$_rejected" "$TMP/suggest.out"; then
      echo "FAIL (suggest): refused candidate '$_rejected' was offered — a violation must not be offered at all." >&2
      FAILED=1
    fi
  done
  echo "PASS (suggest): refused candidates are absent from the returned list."
fi

# ── Check 3: a non-permissive compiled dependency is refused ──────────────────

VIOLATION_DIR="$FIXTURE_ROOT/licence-violation"

if [ ! -s "$VIOLATION_DIR/candidate.md" ]; then
  echo "FAIL (licence): no candidate at $VIOLATION_DIR/candidate.md." >&2
  FAILED=1
else
  _name=$(sed -n 's/^candidate:[[:space:]]*//p' "$VIOLATION_DIR/candidate.md")
  _kind=$(sed -n 's/^kind:[[:space:]]*//p' "$VIOLATION_DIR/candidate.md")
  _lic=$(sed -n 's/^licence:[[:space:]]*//p' "$VIOLATION_DIR/candidate.md")

  decide "$_name" "$_kind" "$_lic" > "$TMP/licence.out" 2>&1 || true

  if diff -u "$VIOLATION_DIR/expected-refusal.txt" "$TMP/licence.out" > "$TMP/licence.diff" 2>&1; then
    echo "PASS (licence): non-permissive compiled dependency refused, naming the licence and the rule."
  else
    echo "FAIL (licence): refusal does not match expectation." >&2
    cat "$TMP/licence.diff" >&2
    FAILED=1
  fi

  if grep -q "^REFUSE $_name " "$TMP/licence.out" \
     && grep -q "$_lic" "$TMP/licence.out" \
     && grep -q "compiled-requires-permissive" "$TMP/licence.out"; then
    echo "PASS (licence/rule): refusal names the component, the licence ($_lic) and the rule."
  else
    echo "FAIL (licence/rule): refusal did not name the component, licence and rule." >&2
    FAILED=1
  fi
fi

# ── Check 4: a container tag masking a licence change is caught ───────────────

CONTAINER_DIR="$FIXTURE_ROOT/container-tag"

if [ ! -s "$CONTAINER_DIR/docker-compose.yml" ] || [ ! -s "$CONTAINER_DIR/image-resolution.md" ]; then
  echo "FAIL (container-tag): docker-compose.yml or image-resolution.md missing from $CONTAINER_DIR." >&2
  FAILED=1
else
  _tags=$(sed -n 's/^[[:space:]]*image:[[:space:]]*//p' "$CONTAINER_DIR/docker-compose.yml")
  : > "$TMP/container.out"
  for _tag in $_tags; do
    _row=$(awk -F'|' -v t="$_tag" '
      { n=$2; gsub(/^[[:space:]]+|[[:space:]]+$/, "", n); if (n == t) print }
    ' "$CONTAINER_DIR/image-resolution.md")
    _product=$(printf '%s' "$_row" | awk -F'|' '{ v=$3; gsub(/^[[:space:]]+|[[:space:]]+$/, "", v); print v }')
    _version=$(printf '%s' "$_row" | awk -F'|' '{ v=$4; gsub(/^[[:space:]]+|[[:space:]]+$/, "", v); print v }')
    _reslic=$(printf '%s' "$_row" | awk -F'|' '{ v=$5; gsub(/^[[:space:]]+|[[:space:]]+$/, "", v); print v }')
    if [ -z "$_reslic" ]; then
      printf 'UNRESOLVED %s — no licence recorded for the tag.\n' "$_tag" >> "$TMP/container.out"
      continue
    fi
    decide "$_tag" "container image" "$_reslic" "tag resolves to $_product $_version; " \
      >> "$TMP/container.out" 2>&1 || true
  done

  if diff -u "$CONTAINER_DIR/expected-decisions.txt" "$TMP/container.out" > "$TMP/container.diff" 2>&1; then
    echo "PASS (container-tag): redis:7-alpine resolves to Redis 7.4.0/RSALv2 and is refused; the permissive tag is allowed."
  else
    echo "FAIL (container-tag): container decisions do not match expectation." >&2
    cat "$TMP/container.diff" >&2
    FAILED=1
  fi

  if grep -q 'REFUSE redis:7-alpine (container image; RSALv2)' "$TMP/container.out" \
     && grep -q 'Redis 7.4.0' "$TMP/container.out" \
     && grep -q 'never-adopt-gated-licences' "$TMP/container.out"; then
    echo "PASS (container-tag/redis): refusal names the tag, the resolved version, the licence and the rule."
  else
    echo "FAIL (container-tag/redis): the masked-licence refusal is incomplete." >&2
    FAILED=1
  fi
fi

# ── Final result ──────────────────────────────────────────────────────────────

if [ "$FAILED" -ne 0 ]; then
  exit 1
fi

echo ""
echo "PASS: All tools-registry checks pass."
