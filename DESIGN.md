# Judge Kernel Design

## Design Principles
- Atomic living documents per domain.
- XML semantic layering for deterministic retrieval.
- Evidence-first execution with hard stop on missing evidence.
- Architecture-first workflow (Greenpause) before source code.

## Required Document Set
- `MISSION_OPORD.md`
- `CONSTITUTION.md`
- `SRS.md`
- `IDD.md`
- `AGENT_BROWSER_PROTOCOL.md`
- `SRE_PLAYBOOK.md`
- `THREAT_MODEL.md`
- `DOMAIN_LEXICON.md`

## Query Contract
- Rule query template: `Welche <critical_invariant> gelten fuer Modul <X>?`
- Gap query template: `Welche Artefakte fehlen fuer Modul <X> bis Definition of Done?`
- Conflict query template: `Welche <halt_condition> erzwingen Stop fuer Modul <X>?`
- Browser query template: `Welche <interaction_invariant> und <security_gate> gelten fuer Browser-Workflow <X>?`
