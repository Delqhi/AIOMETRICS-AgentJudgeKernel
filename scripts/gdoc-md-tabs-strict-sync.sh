#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${1:-.}"
DOC_ID="${PROJECT_GOOGLE_DOC_ID:-}"
MODE="${STRICT_MODE:-sync}"                  # sync|verify
VERIFY_PASSES="${VERIFY_PASSES:-3}"          # set 1000 for max paranoia
DELETE_LOCAL_MD="${DELETE_LOCAL_MD:-0}"      # 0|1
CONFIRM_DELETE="${CONFIRM_DELETE:-}"
NLM_NOTEBOOK_ID="${PROJECT_NOTEBOOK_ID:-}"
SYNC_NOTEBOOK="${SYNC_NOTEBOOK:-0}"          # 0|1
GOOGLE_OAUTH_ACCESS_TOKEN="${GOOGLE_OAUTH_ACCESS_TOKEN:-}"
GOOGLE_ACCESS_TOKEN_CMD="${GOOGLE_ACCESS_TOKEN_CMD:-}"
STRICT_FILE_EXTENSIONS="${STRICT_FILE_EXTENSIONS:-md}"   # comma-separated, e.g. md,txt
STRICT_INCLUDE_NOEXT="${STRICT_INCLUDE_NOEXT:-1}"        # 0|1 include files without extension

usage() {
  cat <<'USAGE'
Usage:
  ./shared/scripts/gdoc-md-tabs-strict-sync.sh [repo_dir]

Environment:
  PROJECT_GOOGLE_DOC_ID   required target Google Doc ID
  STRICT_MODE             sync|verify (default: sync)
  VERIFY_PASSES           verification passes (default: 3; can be 1000)
  STRICT_FILE_EXTENSIONS  comma-separated extensions (default: md)
  STRICT_INCLUDE_NOEXT    0|1 include files without extension (default: 1)
  DELETE_LOCAL_MD         0|1 (default: 0)
  CONFIRM_DELETE          must be YES_DELETE_AFTER_1000X_CHECKS when DELETE_LOCAL_MD=1
  PROJECT_NOTEBOOK_ID     optional NotebookLM ID for source sync
  SYNC_NOTEBOOK           0|1 (default: 0)
  GOOGLE_OAUTH_ACCESS_TOKEN or GOOGLE_ACCESS_TOKEN_CMD or gcloud auth token

Guarantees:
  - One tab per markdown file (tab title = relative file path).
  - Content inserted as exact markdown text (no metadata wrapper).
  - Deletion allowed only after all verify passes succeed.
USAGE
}

if [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
  usage
  exit 0
fi

if [ -z "$DOC_ID" ]; then
  echo "ERROR: PROJECT_GOOGLE_DOC_ID is required" >&2
  exit 2
fi

if [ "$MODE" != "sync" ] && [ "$MODE" != "verify" ]; then
  echo "ERROR: STRICT_MODE must be sync or verify" >&2
  exit 2
fi

if ! [[ "$VERIFY_PASSES" =~ ^[0-9]+$ ]] || [ "$VERIFY_PASSES" -lt 1 ]; then
  echo "ERROR: VERIFY_PASSES must be >= 1" >&2
  exit 2
fi

if [ "$DELETE_LOCAL_MD" != "0" ] && [ "$DELETE_LOCAL_MD" != "1" ]; then
  echo "ERROR: DELETE_LOCAL_MD must be 0 or 1" >&2
  exit 2
fi

if [ "$DELETE_LOCAL_MD" = "1" ] && [ "$CONFIRM_DELETE" != "YES_DELETE_AFTER_1000X_CHECKS" ]; then
  echo "ERROR: deletion blocked; set CONFIRM_DELETE=YES_DELETE_AFTER_1000X_CHECKS" >&2
  exit 2
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq not found" >&2
  exit 2
fi
if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl not found" >&2
  exit 2
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 not found" >&2
  exit 2
fi

resolve_token() {
  if [ -n "$GOOGLE_OAUTH_ACCESS_TOKEN" ]; then
    printf '%s' "$GOOGLE_OAUTH_ACCESS_TOKEN"
    return 0
  fi
  if [ -n "$GOOGLE_ACCESS_TOKEN_CMD" ]; then
    eval "$GOOGLE_ACCESS_TOKEN_CMD"
    return 0
  fi
  if command -v gcloud >/dev/null 2>&1; then
    gcloud auth print-access-token
    return 0
  fi
  echo "ERROR: no OAuth token source available" >&2
  exit 3
}

api_doc_get() {
  local token="$1"
  local doc_id="$2"
  curl -fsSL \
    -H "Authorization: Bearer $token" \
    "https://docs.googleapis.com/v1/documents/$doc_id?includeTabsContent=true"
}

api_doc_batch_update() {
  local token="$1"
  local doc_id="$2"
  local requests_json="$3"
  curl -fsSL \
    -X POST \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    "https://docs.googleapis.com/v1/documents/$doc_id:batchUpdate" \
    -d "{\"requests\":$requests_json}" >/dev/null
}

tab_id_by_title() {
  local doc_json="$1"
  local title="$2"
  printf '%s' "$doc_json" | jq -r --arg title "$title" '
    def walk_tabs(tabs):
      [tabs[]? as $t | $t, (walk_tabs($t.childTabs // []))[]];
    walk_tabs(.tabs // [])[]
    | select((.tabProperties.title // "") == $title)
    | .tabProperties.tabId
  ' | head -n1
}

tab_end_index_by_id() {
  local doc_json="$1"
  local tab_id="$2"
  printf '%s' "$doc_json" | jq -r --arg tab_id "$tab_id" '
    def walk_tabs(tabs):
      [tabs[]? as $t | $t, (walk_tabs($t.childTabs // []))[]];
    walk_tabs(.tabs // [])[]
    | select(.tabProperties.tabId == $tab_id)
    | (((.documentTab.body.content // []) | last | .endIndex) // 1)
  ' | head -n1
}

tab_text_by_id() {
  local doc_json="$1"
  local tab_id="$2"
  printf '%s' "$doc_json" | jq -r --arg tab_id "$tab_id" '
    def walk_tabs(tabs):
      [tabs[]? as $t | $t, (walk_tabs($t.childTabs // []))[]];
    walk_tabs(.tabs // [])[]
    | select(.tabProperties.tabId == $tab_id)
    | [
        .documentTab.body.content[]?
        | .paragraph.elements[]?
        | .textRun.content?
      ]
    | join("")
  '
}

ensure_tab() {
  local token="$1"
  local doc_id="$2"
  local title="$3"
  local doc_json="$4"

  local existing
  existing="$(tab_id_by_title "$doc_json" "$title")"
  if [ -n "$existing" ]; then
    printf '%s' "$existing"
    return 0
  fi

  local req
  req="$(jq -c -n --arg title "$title" '[{addDocumentTab:{tabProperties:{title:$title}}}]')"
  api_doc_batch_update "$token" "$doc_id" "$req"

  local refreshed
  refreshed="$(api_doc_get "$token" "$doc_id")"
  tab_id_by_title "$refreshed" "$title"
}

clear_tab_text() {
  local token="$1"
  local doc_id="$2"
  local tab_id="$3"
  local end_index="$4"

  local delete_to="$((end_index - 1))"
  if [ "$delete_to" -le 1 ]; then
    return 0
  fi

  local req
  req="$(jq -c -n --arg tab_id "$tab_id" --argjson start 1 --argjson end "$delete_to" '[{deleteContentRange:{range:{startIndex:$start,endIndex:$end,tabId:$tab_id}}}]')"
  api_doc_batch_update "$token" "$doc_id" "$req"
}

insert_tab_text() {
  local token="$1"
  local doc_id="$2"
  local tab_id="$3"
  local text="$4"

  local req
  req="$(jq -c -n --arg tab_id "$tab_id" --arg text "$text" '[{insertText:{location:{index:1,tabId:$tab_id},text:$text}}]')"
  api_doc_batch_update "$token" "$doc_id" "$req"
}

insert_tab_text_from_file() {
  local token="$1"
  local doc_id="$2"
  local tab_id="$3"
  local src_file="$4"

  if [ "$MODE" = "dry-run" ]; then
    echo "DRY-RUN: would insert file into tab_id=$tab_id file=$src_file" >&2
    return 0
  fi

  local req
  req="$(jq -c -n \
    --arg tab_id "$tab_id" \
    --rawfile text "$src_file" \
    '[{insertText:{location:{index:1,tabId:$tab_id},text:$text}}]')"
  api_doc_batch_update "$token" "$doc_id" "$req"
}

normalize_file_to_tmp() {
  local src="$1"
  local out="$2"
  python3 - "$src" "$out" <<'PY'
import sys
src, out = sys.argv[1], sys.argv[2]
text = open(src, 'rb').read().decode('utf-8', errors='surrogatepass')
text = text.replace('\r\n', '\n').replace('\r', '\n')
# Google Docs tends to enforce a trailing paragraph newline. For stable
# roundtrip verification, normalize away trailing newlines on both sides.
text = text.rstrip('\n')
open(out, 'w', encoding='utf-8', newline='').write(text)
PY
}

# Build find filter from configured extensions.
build_find_extension_filter() {
  local input="$1"
  local include_noext="$2"
  if [ "$input" = "*" ]; then
    printf " -name '*' "
    return 0
  fi
  local first=1
  IFS=',' read -r -a exts <<< "$input"
  for raw in "${exts[@]}"; do
    ext="$(printf '%s' "$raw" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]' | sed 's/^\.//')"
    [ -n "$ext" ] || continue
    # Keep extension safe for shell/find usage.
    if ! printf '%s' "$ext" | rg -q '^[a-z0-9][a-z0-9._-]*$'; then
      continue
    fi
    if [ "$first" -eq 1 ]; then
      printf " -name '*.%s' " "$ext"
      first=0
    else
      printf " -o -name '*.%s' " "$ext"
    fi
  done

  if [ "$include_noext" = "1" ]; then
    if [ "$first" -eq 1 ]; then
      printf " ! -name '*.*' "
    else
      printf " -o ! -name '*.*' "
    fi
  fi
}

safe_tab_title() {
  local raw="$1"
  local digest
  digest="$(printf '%s' "$raw" | shasum -a 256 | awk '{print $1}' | cut -c1-12)"
  printf 'TAB_%s' "$digest"
}

sha256_file() {
  python3 - "$1" <<'PY'
import sys, hashlib
p=sys.argv[1]
b=open(p,'rb').read()
print(hashlib.sha256(b).hexdigest())
PY
}

# Collect documentation files (project-local, excluding dependencies/build artifacts)
if [ "$STRICT_INCLUDE_NOEXT" != "0" ] && [ "$STRICT_INCLUDE_NOEXT" != "1" ]; then
  echo "ERROR: STRICT_INCLUDE_NOEXT must be 0 or 1" >&2
  exit 2
fi

EXT_FILTER="$(build_find_extension_filter "$STRICT_FILE_EXTENSIONS" "$STRICT_INCLUDE_NOEXT")"
if [ -z "$EXT_FILTER" ]; then
  echo "ERROR: STRICT_FILE_EXTENSIONS yielded no valid extensions" >&2
  exit 2
fi

mapfile -t MD_FILES < <(
  cd "$REPO_DIR" && eval "find . -type f \\( $EXT_FILTER \\) \
    ! -path './.git/*' \
    ! -path './node_modules/*' \
    ! -path './dist/*' \
    ! -path './build/*' \
    ! -path './.next/*' \
    ! -path './coverage/*' \
    ! -path './venv/*' \
    ! -path './.venv/*' \
    | sed 's#^\./##' \
    | sort"
)

if [ "${#MD_FILES[@]}" -eq 0 ]; then
  echo "WARN: no matching files found for extensions: $STRICT_FILE_EXTENSIONS"
  exit 0
fi

TOKEN="$(resolve_token)"
DOC_JSON="$(api_doc_get "$TOKEN" "$DOC_ID")"

RUN_DIR="$(mktemp -d)"
trap 'rm -rf "$RUN_DIR"' EXIT
MANIFEST="$RUN_DIR/manifest.tsv"
MISMATCH="$RUN_DIR/mismatch.tsv"
VERIFY_RETRIES="${VERIFY_RETRIES:-12}"      # retry reads after write to avoid stale reads
VERIFY_RETRY_SLEEP="${VERIFY_RETRY_SLEEP:-1}"
echo -e "rel_path\ttab_id\torig_sha\tretrieved_sha" > "$MANIFEST"

echo "STRICT MD->Tab sync"
echo "repo_dir=$REPO_DIR"
echo "doc_id=$DOC_ID"
echo "mode=$MODE"
echo "verify_passes=$VERIFY_PASSES"
echo "extensions=$STRICT_FILE_EXTENSIONS"
echo "include_noext=$STRICT_INCLUDE_NOEXT"
echo "verify_retries=$VERIFY_RETRIES"
echo "delete_local_md=$DELETE_LOCAL_MD"
echo "files=${#MD_FILES[@]}"

if [ "$MODE" = "sync" ]; then
  for rel in "${MD_FILES[@]}"; do
    abs="$REPO_DIR/$rel"
    title="$(safe_tab_title "$rel")"

    DOC_JSON="$(api_doc_get "$TOKEN" "$DOC_ID")"
    tab_id="$(ensure_tab "$TOKEN" "$DOC_ID" "$title" "$DOC_JSON")"
    if [ -z "$tab_id" ]; then
      echo "ERROR: failed to ensure tab: $title" >&2
      exit 4
    fi

    DOC_JSON="$(api_doc_get "$TOKEN" "$DOC_ID")"
    end_idx="$(tab_end_index_by_id "$DOC_JSON" "$tab_id")"
    clear_tab_text "$TOKEN" "$DOC_ID" "$tab_id" "$end_idx"

    insert_tab_text_from_file "$TOKEN" "$DOC_ID" "$tab_id" "$abs"

    expn="$RUN_DIR/exp.norm"
    normalize_file_to_tmp "$abs" "$expn"
    sha_exp="$(sha256_file "$expn")"

    got="$RUN_DIR/got.txt"
    gotn="$RUN_DIR/got.norm"
    sha_got=""
    ok="0"
    attempt=1
    while [ "$attempt" -le "$VERIFY_RETRIES" ]; do
      DOC_JSON="$(api_doc_get "$TOKEN" "$DOC_ID")"
      tab_text_by_id "$DOC_JSON" "$tab_id" > "$got"
      normalize_file_to_tmp "$got" "$gotn"
      sha_got="$(sha256_file "$gotn")"
      if [ "$sha_exp" = "$sha_got" ]; then
        ok="1"
        break
      fi
      sleep "$VERIFY_RETRY_SLEEP"
      attempt=$((attempt + 1))
    done

    echo -e "$rel\t$tab_id\t$sha_exp\t$sha_got" >> "$MANIFEST"

    if [ "$ok" != "1" ]; then
      echo "ERROR: hash mismatch after sync: $rel" >&2
      exit 5
    fi
  done
fi

# Multi-pass verification
pass=1
while [ "$pass" -le "$VERIFY_PASSES" ]; do
  : > "$MISMATCH"
  DOC_JSON="$(api_doc_get "$TOKEN" "$DOC_ID")"
  for rel in "${MD_FILES[@]}"; do
    abs="$REPO_DIR/$rel"
    title="$(safe_tab_title "$rel")"
    tab_id="$(tab_id_by_title "$DOC_JSON" "$title")"
    if [ -z "$tab_id" ]; then
      echo -e "$pass\t$rel\tmissing_tab" >> "$MISMATCH"
      continue
    fi

    got="$RUN_DIR/got.txt"
    expn="$RUN_DIR/exp.norm"
    gotn="$RUN_DIR/got.norm"
    tab_text_by_id "$DOC_JSON" "$tab_id" > "$got"
    normalize_file_to_tmp "$abs" "$expn"
    normalize_file_to_tmp "$got" "$gotn"
    sha_exp="$(sha256_file "$expn")"
    sha_got="$(sha256_file "$gotn")"
    if [ "$sha_exp" != "$sha_got" ]; then
      echo -e "$pass\t$rel\tsha_mismatch" >> "$MISMATCH"
    fi
  done

  mismatches=$(wc -l < "$MISMATCH" | tr -d ' ')
  # account for empty-file no newline edge
  if [ "$mismatches" -gt 0 ]; then
    echo "Verification pass $pass: mismatches=$mismatches"
    cat "$MISMATCH"
    exit 6
  fi
  echo "Verification pass $pass: OK"
  pass=$((pass + 1))
done

# Optional notebook sync
if [ "$SYNC_NOTEBOOK" = "1" ] && [ -n "$NLM_NOTEBOOK_ID" ] && command -v nlm >/dev/null 2>&1; then
  nlm source sync "$NLM_NOTEBOOK_ID" --confirm >/dev/null || true
fi

# Delete local markdown only after successful verification passes
if [ "$DELETE_LOCAL_MD" = "1" ]; then
  DELETE_FILES=()
  for rel in "${MD_FILES[@]}"; do
    if [ "$rel" = "AGENTS.md" ] || [ "$(basename "$rel")" = "AGENTS.md" ]; then
      continue
    fi
    DELETE_FILES+=("$rel")
  done

  TS="$(date -u +%Y%m%dT%H%M%SZ)"
  BK="/Users/jeremyschulze/dev/AIOMETRICS/_governance/backups/strict-md-delete-$TS"
  mkdir -p "$BK"
  if [ "${#DELETE_FILES[@]}" -gt 0 ]; then
    tar -czf "$BK/md-backup.tgz" -C "$REPO_DIR" "${DELETE_FILES[@]}"
  else
    tar -czf "$BK/md-backup.tgz" --files-from /dev/null
  fi
  shasum -a 256 "$BK/md-backup.tgz" > "$BK/archive-sha256.txt"
  printf '%s\n' "${DELETE_FILES[@]}" > "$BK/files.txt"

  for rel in "${DELETE_FILES[@]}"; do
    rm -f "$REPO_DIR/$rel"
  done
  echo "Deleted ${#DELETE_FILES[@]} markdown files after strict verification (AGENTS.md preserved)."
  echo "Backup: $BK/md-backup.tgz"
fi

echo "SUCCESS: strict sync+verification completed"
echo "manifest=$MANIFEST"
