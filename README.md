# AIOMETRICS Agent Judge Kernel

## Mission
This repository defines the operational intelligence kernel used by coder agents as the single source of truth for:
- mandatory rules (`critical_invariant`)
- implementation scope (`srs_requirement`)
- interface contracts (`interface_contract`)
- incident response (`sre_runbook`)
- security controls (`threat_control`)

## Operational Model
1. Agent starts with Greenpause mode (design first, no implementation).
2. Agent queries Judge Notebook for active constraints and missing deliverables.
3. Agent must stop when no source evidence is returned.
4. Agent can continue only when cited constraints exist and no blocked state is active.

## Document Index
- `MISSION_OPORD.md`: strategic mission order.
- `CONSTITUTION.md`: immutable governance and Rules of Engagement.
- `SRS.md`: software requirement specification.
- `IDD.md`: interface design description.
- `AGENT_BROWSER_PROTOCOL.md`: deterministic browser sensing and action gates.
- `SRE_PLAYBOOK.md`: trigger-action-verification runbooks.
- `THREAT_MODEL.md`: threat model and hardening controls.
- `STANDARDS_BASELINE.md`: normative baseline and verification cadence.
- `OWASP_LLM_MAPPING.md`: OWASP LLM Top 10 2025 control mapping.
- `RUNTIME_ISOLATION.md`: runtime sandbox and egress guardrails.
- `DOMAIN_LEXICON.md`: ubiquitous language.
- `docs/architecture/system-overview.md`: C4-style overview and trust boundaries.
- `docs/adr/0001-judge-kernel-architecture.md`: architecture decision record.
- `docs/rfc/0001-agent-judge-gate.md`: judge-gate protocol.

## Execution Commands
```bash
# Create DEV/INFO notebooks and write IDs into portfolio config
./scripts/create-judge-notebooks.sh

# Read required constraints for a module
./scripts/nlm-judge-query.sh rules "ModuleName"

# Read missing artifacts for a module
./scripts/nlm-judge-query.sh next "ModuleName"

# Read browser action protocol for a target workflow
./scripts/nlm-judge-query.sh browser "LoginFlow"

# Free-form query
./scripts/nlm-judge-query.sh custom "Welche <critical_invariant> gelten fuer Modul X?"

# Verify standards baseline freshness/full drift checks
./scripts/verify-standards-baseline.sh --mode freshness
./scripts/verify-standards-baseline.sh --mode full

# Run full preflight gate (includes standards freshness check)
./scripts/judge-preflight-gate.sh --module CoreModule --workflow LoginFlow

# Google-Doc-only migration (dry-run)
KERNEL_MODE=dry-run \
PROJECT_GOOGLE_DOC_ID="<DOC_ID>" \
PROJECT_NOTEBOOK_ID="<NOTEBOOK_ID>" \
PROJECT_GOOGLE_DRIVE_FOLDER_ID="<FOLDER_ID>" \
GOOGLE_SERVICE_ACCOUNT_KEY="/path/to/service-account.json" \
./scripts/gdoc-kernel-sync.sh .

# Google-Doc-only migration (sync)
KERNEL_MODE=sync \
PROJECT_GOOGLE_DOC_ID="<DOC_ID>" \
PROJECT_NOTEBOOK_ID="<NOTEBOOK_ID>" \
PROJECT_GOOGLE_DRIVE_FOLDER_ID="<FOLDER_ID>" \
GOOGLE_SERVICE_ACCOUNT_KEY="/path/to/service-account.json" \
ENFORCE_SINGLE_SOURCE=1 \
SYNC_NOTEBOOK=1 \
./scripts/gdoc-kernel-sync.sh .

# Autonomous doc create (if DOC_ID missing)
KERNEL_MODE=sync \
CREATE_GOOGLE_DOC_IF_MISSING=1 \
PROJECT_GOOGLE_DOC_TITLE="AIOMETRICS <PROJECT> Master Kernel" \
PROJECT_GOOGLE_DRIVE_FOLDER_ID="<FOLDER_ID>" \
PROJECT_NOTEBOOK_ID="<NOTEBOOK_ID>" \
GOOGLE_SERVICE_ACCOUNT_KEY="/path/to/service-account.json" \
./scripts/gdoc-kernel-sync.sh .

# Local policy check
GDOC_ONLY_MODE=report ./scripts/enforce-gdoc-only-docs.sh .
GDOC_ONLY_MODE=enforce ./scripts/enforce-gdoc-only-docs.sh .
```

## Definition Of Done (Judge Layer)
- Notebook exists and is referenced in portfolio config.
- All kernel docs are synced as NotebookLM sources.
- Agent query helper enforces evidence check.
- Preflight gate enforces minimum citations for rules, next, and browser queries.
- Preflight gate blocks execution when standards baseline freshness check fails.
- Standards baseline and OWASP mapping are versioned and ACCEPTED.
- Rule and backlog prompts are deterministic and reusable.
