# NotebookLM Sync - Agent Judge Kernel

## Target Alias
`10-agent-judge-kernel`

## Notebook IDs
- DEV: `784c4f30-b524-41d9-a0cc-3752b8303cf3`
- INFO: `ab67c7ae-5e83-4316-9587-83ac5fabe396`

## Notebook Bootstrap
```bash
/Users/jeremyschulze/dev/AIOMETRICS/10-AgentJudgeKernel/scripts/create-judge-notebooks.sh
```

## Dry Run
```bash
NLM_MODE=dry-run NLM_SCOPE=both /Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/sync-notebooklm.sh 10-agent-judge-kernel
```

## Sync (DEV + INFO)
```bash
NLM_MODE=sync NLM_SCOPE=both NLM_FORCE_REPLACE=1 NLM_PRUNE_UNMANAGED=1 /Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/sync-notebooklm.sh 10-agent-judge-kernel
```

## Chat konfigurieren (Gesprächsziel/-stil/-rolle)
Setzt das Notebook auf `goal=custom` mit der Governance-Prompt aus `CHAT_RESPONSE_CONSTITUTION.md`:

```bash
PROMPT="$(cat /Users/jeremyschulze/dev/AIOMETRICS/10-AgentJudgeKernel/CHAT_RESPONSE_CONSTITUTION.md)"
nlm chat configure 784c4f30-b524-41d9-a0cc-3752b8303cf3 --goal custom --response-length longer --prompt "$PROMPT"
nlm chat configure ab67c7ae-5e83-4316-9587-83ac5fabe396 --goal custom --response-length longer --prompt "$PROMPT"
```

## Google-Doc-Only Kernel Migration (pro Projekt)
Erzwingt je Projekt: `1x Master Google Doc` + `1x NotebookLM` + lokal nur `AGENTS.md`.

```bash
KERNEL_MODE=dry-run \
PROJECT_GOOGLE_DOC_ID="<DOC_ID>" \
PROJECT_NOTEBOOK_ID="<NOTEBOOK_ID>" \
PROJECT_GOOGLE_DRIVE_FOLDER_ID="<FOLDER_ID>" \
GOOGLE_SERVICE_ACCOUNT_KEY="/path/to/service-account.json" \
/Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/gdoc-kernel-sync.sh <repo-key-or-path>
```

```bash
KERNEL_MODE=sync \
PROJECT_GOOGLE_DOC_ID="<DOC_ID>" \
PROJECT_NOTEBOOK_ID="<NOTEBOOK_ID>" \
PROJECT_GOOGLE_DRIVE_FOLDER_ID="<FOLDER_ID>" \
GOOGLE_SERVICE_ACCOUNT_KEY="/path/to/service-account.json" \
ENFORCE_SINGLE_SOURCE=1 \
SYNC_NOTEBOOK=1 \
/Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/gdoc-kernel-sync.sh <repo-key-or-path>
```

Autonomes Erstellen der Master-Doc (wenn `DOC_ID` fehlt):
```bash
KERNEL_MODE=sync \
CREATE_GOOGLE_DOC_IF_MISSING=1 \
PROJECT_GOOGLE_DOC_TITLE="AIOMETRICS <PROJECT> Master Kernel" \
PROJECT_GOOGLE_DRIVE_FOLDER_ID="<FOLDER_ID>" \
PROJECT_NOTEBOOK_ID="<NOTEBOOK_ID>" \
GOOGLE_SERVICE_ACCOUNT_KEY="/path/to/service-account.json" \
/Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/gdoc-kernel-sync.sh <repo-key-or-path>
```

## Sync (Scope-specific)
```bash
NLM_MODE=sync NLM_SCOPE=dev NLM_FORCE_REPLACE=1 NLM_PRUNE_UNMANAGED=1 /Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/sync-notebooklm.sh 10-agent-judge-kernel
NLM_MODE=sync NLM_SCOPE=info NLM_FORCE_REPLACE=1 NLM_PRUNE_UNMANAGED=1 /Users/jeremyschulze/dev/AIOMETRICS/shared/scripts/sync-notebooklm.sh 10-agent-judge-kernel
```

## Manual Query Examples
```bash
nlm notebook query <DEV_NOTEBOOK_ID> "Welche <critical_invariant> gelten fuer Modul X?" --json
nlm notebook query <DEV_NOTEBOOK_ID> "Welche Artefakte fehlen fuer Modul X bis Definition of Done?" --json
nlm notebook query <DEV_NOTEBOOK_ID> "Welche <interaction_invariant> und <security_gate> gelten fuer Browser-Workflow LoginFlow?" --json
```

## Preflight Gate Check
```bash
/Users/jeremyschulze/dev/AIOMETRICS/10-AgentJudgeKernel/scripts/judge-preflight-gate.sh --module CoreModule --workflow LoginFlow
```

## Standards Revalidation
```bash
/Users/jeremyschulze/dev/AIOMETRICS/10-AgentJudgeKernel/scripts/verify-standards-baseline.sh --mode freshness
/Users/jeremyschulze/dev/AIOMETRICS/10-AgentJudgeKernel/scripts/verify-standards-baseline.sh --mode full
```

## Verify Synced Sources
```bash
nlm source list 784c4f30-b524-41d9-a0cc-3752b8303cf3 --json | jq -r '.[].title' | sort
nlm source list ab67c7ae-5e83-4316-9587-83ac5fabe396 --json | jq -r '.[].title' | sort
```
