# Project Agent Protocol: Google-Doc-Only Kernel

## Project Identity
- repo_key: `10-agent-judge-kernel`
- PROJECT_GOOGLE_DOC_ID: `1tz_dx8OVLqHEGVP46FhB8IrVYKl_XKuhW9M1rsMk_mU`
- PROJECT_NOTEBOOK_ID: `784c4f30-b524-41d9-a0cc-3752b8303cf3`
- PROJECT_GOOGLE_DRIVE_FOLDER_ID: `1tFcvhLl7hGx-4Lyf9DzV8nbifzrIhwPF`

## Hard Rules
1. Do not create local documentation files (`*.md`, `*.txt`, `*.docx`) except this `AGENTS.md`.
2. All documentation updates go to the single Master Google Doc via service account/API.
3. Master Google Doc must use grouped tabs:
   - `00_FOUNDATION`: `Agents.md`, `CONTEXT.md`, `readme.md`
   - `01_DESIGN`: `ARCHITECTURE.md`, `DESIGN.md`
   - `02_ENGINEERING`: `BACKEND.md`, `FRONTEND.md`
   - `03_INFRASTRUCTURE`: `VM.md`, `VERCEL.md`, `CLOUDFLARE.md`
   - `04_INTELLIGENCE`: `NOTEBOOKLM.md`
4. Before architecture or code changes, query NotebookLM and require citation evidence.
5. If citations are missing or access fails, return `BLOCKED` and stop.
6. High-risk actions require explicit human approval.

## Mandatory Queries
```bash
nlm notebook query "784c4f30-b524-41d9-a0cc-3752b8303cf3" "Welche <critical_invariant> und <halt_condition> gelten fuer Modul <MODULE>?" --json
nlm notebook query "784c4f30-b524-41d9-a0cc-3752b8303cf3" "Welche Artefakte fehlen fuer Modul <MODULE> bis Definition of Done?" --json
```

## Documentation Workflow
1. Read/update project docs only in Google Doc tabs.
2. Keep NotebookLM source bound to this Google Doc.
3. After doc updates, run source sync:
```bash
nlm source sync "784c4f30-b524-41d9-a0cc-3752b8303cf3" --confirm
```

## Guardrail
If any mandatory rule cannot be proven with notebook citations: `BLOCKED`.
