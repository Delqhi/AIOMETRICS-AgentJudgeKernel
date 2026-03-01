# Agent Browser Protocol

<metadata>
  <document_id>AGENT_BROWSER_PROTOCOL</document_id>
  <version>1.1.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
</metadata>

## Purpose
<action_protocol id="ABP-001">
Define deterministic browser interaction rules so autonomous agents can perceive and act with bounded risk.
</action_protocol>

## Snapshot-Interact-Validate Loop
<action_protocol id="ABP-002">
  <step_01>snapshot: capture current accessibility tree with stable refs (E1, E2, ...).</step_01>
  <step_02>select: choose target ref from snapshot, not from raw DOM selector guess.</step_02>
  <step_03>act: execute a single action (click/type/select/upload).</step_03>
  <step_04>validate: take post-action snapshot and assert expected state transition.</step_04>
</action_protocol>

## Interaction Invariants
<interaction_invariant id="II-001">One action per command cycle.</interaction_invariant>
<interaction_invariant id="II-002">No action without fresh snapshot in the same workflow stage.</interaction_invariant>
<interaction_invariant id="II-003">No direct CSS/XPath dependence when accessibility refs are available.</interaction_invariant>
<interaction_invariant id="II-004">State validation is mandatory before next action.</interaction_invariant>

## Security Gates
<security_gate id="SG-001" risk_tier="LOW">Read-only actions; proceed with notebook evidence.</security_gate>
<security_gate id="SG-002" risk_tier="MEDIUM">State-changing non-destructive actions; require post-validation evidence.</security_gate>
<security_gate id="SG-003" risk_tier="HIGH">Financial, credential, or destructive actions; require HITL token.</security_gate>
<security_gate id="SG-004" risk_tier="ALL">Execution requires active runtime isolation and egress allowlist for session domain scope.</security_gate>

## Session Strategy
<session_policy id="SP-001">Use persistent sessions only with encrypted state storage.</session_policy>
<session_policy id="SP-002">Expire dormant sessions automatically to reduce blast radius.</session_policy>
<session_policy id="SP-003">Write reasoning trace IDs for every snapshot/action pair.</session_policy>
<session_policy id="SP-004">Reject session start when isolation mode, credential TTL, or timeout budget is undefined.</session_policy>

## Query Templates
<query_template id="QT-001">Welche &lt;interaction_invariant&gt; gelten fuer Workflow X?</query_template>
<query_template id="QT-002">Welche &lt;security_gate&gt; ist fuer Aktion Y verbindlich?</query_template>
<query_template id="QT-003">Welche Artefakte fehlen fuer Snapshot-Interact-Validate in Modul X?</query_template>
