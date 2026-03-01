#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
WORKSPACE_ROOT="$(cd "$REPO_ROOT/.." && pwd)"
CONFIG="${NLM_CONFIG:-$WORKSPACE_ROOT/shared/config/notebooklm-portfolio.json}"
REPO_KEY="10-agent-judge-kernel"
DEV_TITLE="AIOMETRICS 10 Agent Judge Kernel - DEV"
INFO_TITLE="AIOMETRICS 10 Agent Judge Kernel - INFO"

for cmd in nlm jq; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: missing command '$cmd'" >&2
    exit 1
  fi
done

if [ ! -f "$CONFIG" ]; then
  echo "ERROR: missing config file: $CONFIG" >&2
  exit 1
fi

if ! NB_JSON="$(nlm notebook list --json 2>/tmp/nlm-list-error.log)"; then
  echo "ERROR: nlm notebook list failed. Run 'nlm login' first." >&2
  sed -n '1,80p' /tmp/nlm-list-error.log >&2 || true
  exit 2
fi

DEV_ID="$(printf '%s' "$NB_JSON" | jq -r --arg t "$DEV_TITLE" '.[] | select(.title == $t) | .id' | head -n 1)"
INFO_ID="$(printf '%s' "$NB_JSON" | jq -r --arg t "$INFO_TITLE" '.[] | select(.title == $t) | .id' | head -n 1)"

if [ -z "$DEV_ID" ] || [ "$DEV_ID" = "null" ]; then
  DEV_ID="$(nlm notebook create "$DEV_TITLE" | sed -n 's/^  ID: //p' | tail -n 1)"
fi

if [ -z "$INFO_ID" ] || [ "$INFO_ID" = "null" ]; then
  INFO_ID="$(nlm notebook create "$INFO_TITLE" | sed -n 's/^  ID: //p' | tail -n 1)"
fi

if [ -z "$DEV_ID" ] || [ -z "$INFO_ID" ]; then
  echo "ERROR: could not resolve notebook IDs after create/list." >&2
  exit 3
fi

TMP="$(mktemp)"
jq --arg repo "$REPO_KEY" --arg dev "$DEV_ID" --arg info "$INFO_ID" --arg ts "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" '
  .updated_at = $ts
  | (.repos[] | select(.repo == $repo) | .dev.id) = $dev
  | (.repos[] | select(.repo == $repo) | .info.id) = $info
' "$CONFIG" > "$TMP"
mv "$TMP" "$CONFIG"

echo "DEV_ID=$DEV_ID"
echo "INFO_ID=$INFO_ID"
echo "Config updated: $CONFIG"

echo
echo "Next:"
echo "NLM_MODE=sync NLM_SCOPE=both NLM_FORCE_REPLACE=1 NLM_PRUNE_UNMANAGED=1 $WORKSPACE_ROOT/shared/scripts/sync-notebooklm.sh $REPO_KEY"
