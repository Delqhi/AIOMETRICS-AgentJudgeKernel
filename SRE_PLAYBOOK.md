# SRE Playbook

<metadata>
  <document_id>SRE_PLAYBOOK</document_id>
  <version>1.1.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
</metadata>

## SLO Profile
<slo id="SLO-001">Judge query success >= 99.0% monthly.</slo>
<slo id="SLO-002">Judge query P95 latency <= 5s.</slo>
<slo id="SLO-003">Daily sync success >= 99.5%.</slo>

## Runbooks (Trigger / Action / Verification)
<sre_runbook id="RB-001">
  <trigger>Notebook query fails or times out.</trigger>
  <action>Retry once, then execute profile check and endpoint diagnostics.</action>
  <verification>Successful query response or incident ticket created.</verification>
</sre_runbook>

<sre_runbook id="RB-002">
  <trigger>Evidence count is zero for mandatory query.</trigger>
  <action>Stop execution and create missing-document task in backlog.</action>
  <verification>Task ID exists and work is blocked until resolved.</verification>
</sre_runbook>

<sre_runbook id="RB-003">
  <trigger>Notebook source count reaches warning threshold.</trigger>
  <action>Prioritize atomic document consolidation and remove duplicates.</action>
  <verification>Source count below threshold and duplicate title count is zero.</verification>
</sre_runbook>

<sre_runbook id="RB-004">
  <trigger>Document status mismatch (not ACCEPTED).</trigger>
  <action>Freeze implementation and request governance decision.</action>
  <verification>Decision recorded in ADR and status updated.</verification>
</sre_runbook>

<sre_runbook id="RB-005">
  <trigger>Browser action executed without successful post-action validation snapshot.</trigger>
  <action>Invalidate session, replay from previous stable snapshot, and open incident.</action>
  <verification>Recovered state matches expected workflow checkpoint.</verification>
</sre_runbook>

<sre_runbook id="RB-006">
  <trigger>Runtime spend projection exceeds approved monthly budget.</trigger>
  <action>Switch to budget-safe model profile and disable non-critical automations.</action>
  <verification>Projected spend returns below budget guardrail.</verification>
</sre_runbook>

<sre_runbook id="RB-007">
  <trigger>Standards baseline freshness or monthly external revalidation fails.</trigger>
  <action>Freeze autonomous execution, open compliance incident, update STANDARDS_BASELINE metadata and mappings.</action>
  <verification>verify-standards-baseline.sh passes in full mode and incident is closed.</verification>
</sre_runbook>
