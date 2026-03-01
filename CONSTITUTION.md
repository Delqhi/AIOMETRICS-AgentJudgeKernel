# Agentic Constitution

<metadata>
  <document_id>CONSTITUTION</document_id>
  <version>1.1.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
  <constitution_id>AGENT-JUDGE-CONSTITUTION-v1.1.0</constitution_id>
</metadata>

<system_identity>
  <mandate>Agents operate in Greenpause-first mode: design complete before implementation.</mandate>
  <quality_baseline>NASA Class-A rigor adapted to software delivery constraints, mapped through STANDARDS_BASELINE.</quality_baseline>
</system_identity>

## Critical Invariants
<critical_invariant id="CI-001">Never write plaintext secrets to code, logs, commits, or docs.</critical_invariant>
<critical_invariant id="CI-002">Never execute destructive production actions without explicit human approval token.</critical_invariant>
<critical_invariant id="CI-003">Every architecture or implementation decision must be traceable to Notebook evidence.</critical_invariant>
<critical_invariant id="CI-004">If evidence is missing or contradictory, stop and request clarification.</critical_invariant>
<critical_invariant id="CI-005">No code implementation before required architecture artifacts are marked ACCEPTED.</critical_invariant>
<critical_invariant id="CI-006">All externally reachable interfaces require authentication, authorization, and audit logging.</critical_invariant>
<critical_invariant id="CI-007">All incidents must follow trigger-action-verification runbook structure.</critical_invariant>
<critical_invariant id="CI-008">Browser automation must use snapshot-first interaction; no blind click/type without pre-snapshot refs.</critical_invariant>
<critical_invariant id="CI-009">High-risk browser actions require Human-in-the-Loop approval token before execution.</critical_invariant>
<critical_invariant id="CI-010">Agent operations must enforce monthly spend ceilings and per-action risk tiers.</critical_invariant>
<critical_invariant id="CI-011">Execution is blocked unless mandatory judge queries return at least the configured minimum citation count.</critical_invariant>
<critical_invariant id="CI-012">Autonomous browser runtime must run with explicit isolation, egress allowlists, and expiring credentials.</critical_invariant>

## Rules Of Engagement
<rules_of_engagement>
  <roe_01>Query Judge Notebook before coding.</roe_01>
  <roe_02>State active constraints and unresolved gaps in work output.</roe_02>
  <roe_03>Use deterministic commands and reproducible scripts.</roe_03>
  <roe_04>Prefer additive changes over implicit behavior changes.</roe_04>
  <roe_05>For web tasks, execute snapshot -> action -> validation loop for every state mutation.</roe_05>
  <roe_06>Do not use unstable CSS selectors when accessibility refs are available.</roe_06>
</rules_of_engagement>

## Halt Conditions
<halt_condition id="HC-001">No source evidence returned for mandatory rule query.</halt_condition>
<halt_condition id="HC-002">Required document in status other than ACCEPTED.</halt_condition>
<halt_condition id="HC-003">Security control marked REQUIRED but implementation not planned.</halt_condition>
<halt_condition id="HC-004">Browser action marked HIGH_RISK without HITL token.</halt_condition>
<halt_condition id="HC-005">Projected monthly run cost exceeds approved budget cap.</halt_condition>
<halt_condition id="HC-006">Normative standards baseline cannot be verified as current.</halt_condition>
<halt_condition id="HC-007">Runtime isolation controls are not active for browser automation.</halt_condition>
