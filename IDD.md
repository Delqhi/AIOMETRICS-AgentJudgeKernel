# Interface Design Description

<metadata>
  <document_id>IDD</document_id>
  <version>1.2.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
  <standard_ref>MIL-STD-498-aligned Data Item Description (tailored)</standard_ref>
</metadata>

## Interface Contracts
<interface_contract id="IDD-001">
  <name>JudgeQueryRules</name>
  <transport>CLI</transport>
  <command>nlm notebook query &lt;NOTEBOOK_ID&gt; &quot;Welche &lt;critical_invariant&gt; gelten fuer Modul X?&quot; --json</command>
</interface_contract>

<interface_contract id="IDD-002">
  <name>JudgeQueryMissingArtifacts</name>
  <transport>CLI</transport>
  <command>nlm notebook query &lt;NOTEBOOK_ID&gt; &quot;Welche Artefakte fehlen fuer Modul X bis Definition of Done?&quot; --json</command>
</interface_contract>

<interface_contract id="IDD-003">
  <name>JudgeSourceInventory</name>
  <transport>CLI</transport>
  <command>nlm source list &lt;NOTEBOOK_ID&gt; --json</command>
</interface_contract>

<interface_contract id="IDD-004">
  <name>BrowserSnapshot</name>
  <transport>CLI</transport>
  <command>agent-browser snapshot --session &lt;SESSION_ID&gt;</command>
</interface_contract>

<interface_contract id="IDD-005">
  <name>BrowserActionByRef</name>
  <transport>CLI</transport>
  <command>agent-browser click --ref &lt;E_REF&gt; --session &lt;SESSION_ID&gt;</command>
</interface_contract>

<interface_contract id="IDD-006">
  <name>BrowserPostActionValidation</name>
  <transport>CLI</transport>
  <command>agent-browser snapshot --session &lt;SESSION_ID&gt; --assert &lt;EXPECTED_STATE&gt;</command>
</interface_contract>

<interface_contract id="IDD-007">
  <name>JudgePreflightGate</name>
  <transport>CLI</transport>
  <command>./scripts/judge-preflight-gate.sh --module &lt;MODULE&gt; --workflow &lt;WORKFLOW&gt;</command>
</interface_contract>

## Payload Schemas
```json
{
  "JudgeQueryRequest": {
    "module": "string",
    "intent": "rules|next|custom",
    "question": "string",
    "caller": "string",
    "timestamp_utc": "RFC3339"
  },
  "JudgeQueryResult": {
    "answer": "string",
    "evidence_count": "number",
    "citation_count": "number",
    "citations": ["string"],
    "status": "ok|blocked",
    "blocked_reason": "string|null"
  },
  "JudgeGateConfig": {
    "module": "string",
    "workflow": "string",
    "min_citations": "number"
  },
  "JudgeGateResult": {
    "rules_citations": "number",
    "next_citations": "number",
    "browser_citations": "number",
    "status": "ok|blocked",
    "blocked_reason": "string|null"
  },
  "BrowserActionRequest": {
    "session_id": "string",
    "action": "open|click|type|select|upload|submit",
    "target_ref": "string",
    "risk_tier": "LOW|MEDIUM|HIGH",
    "requires_hitl": "boolean",
    "hitl_token": "string|null"
  },
  "BrowserActionResult": {
    "action_status": "ok|failed|blocked",
    "post_snapshot_id": "string",
    "state_verified": "boolean",
    "blocked_reason": "string|null"
  }
}
```

## Validation Rules
<validation_rule id="VR-001">Reject execution when evidence_count == 0.</validation_rule>
<validation_rule id="VR-002">Reject execution when status == blocked.</validation_rule>
<validation_rule id="VR-003">Persist request + result metadata for audits.</validation_rule>
<validation_rule id="VR-004">Reject HIGH_RISK browser actions when hitl_token is missing.</validation_rule>
<validation_rule id="VR-005">Reject browser actions that do not reference a pre-snapshot element ID.</validation_rule>
<validation_rule id="VR-006">Reject workflows without post-action validation snapshot.</validation_rule>
<validation_rule id="VR-007">Reject execution when citation_count &lt; configured minimum.</validation_rule>
<validation_rule id="VR-008">Reject browser execution when runtime isolation preconditions are not met.</validation_rule>
<validation_rule id="VR-009">Reject execution when standards baseline freshness verification fails.</validation_rule>
