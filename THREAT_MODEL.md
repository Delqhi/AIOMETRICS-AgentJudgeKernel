# Threat Model

<metadata>
  <document_id>THREAT_MODEL</document_id>
  <version>1.1.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
</metadata>

## Threat Inventory
<threat id="TM-001" type="PromptInjection">
Untrusted prompt content attempts to override constitution rules.
</threat>

<threat id="TM-002" type="DataExfiltration">
Sensitive information leaked through logs, output, or unsafe source uploads.
</threat>

<threat id="TM-003" type="RuleBypass">
Agent performs implementation without judge query or evidence checks.
</threat>

<threat id="TM-004" type="ScopePoisoning">
Agent pulls irrelevant documents and makes unsupported design decisions.
</threat>

<threat id="TM-005" type="UIInjection">
Malicious page content manipulates autonomous browser actions.
</threat>

<threat id="TM-006" type="CredentialLeak">
Browser session or API keys are exposed through unsafe tool calls.
</threat>

<threat id="TM-007" type="SpendRunaway">
Autonomous loops trigger uncontrolled cost growth.
</threat>

<threat id="TM-008" type="RuntimeEscape">
Browser daemon or automation runtime escapes intended isolation boundaries.
</threat>

<threat id="TM-009" type="StandardsDrift">
Control set diverges from current normative standards and security baseline.
</threat>

## Security Controls
<threat_control id="SC-001">Mandatory preflight query gate for all implementation tasks.</threat_control>
<threat_control id="SC-002">Block execution when evidence metadata is absent.</threat_control>
<threat_control id="SC-003">Limit source corpus to approved kernel documents.</threat_control>
<threat_control id="SC-004">Use least-privilege notebook segmentation for sensitive domains.</threat_control>
<threat_control id="SC-005">Apply human approval token for destructive operations.</threat_control>
<threat_control id="SC-006">Allow browser actions only by accessibility refs from latest snapshot.</threat_control>
<threat_control id="SC-007">Isolate browser daemon runtime and rotate credentials frequently.</threat_control>
<threat_control id="SC-008">Enforce budget guardrails with automatic stop at threshold breach.</threat_control>
<threat_control id="SC-009">Map controls to OWASP LLM Top 10 2025 and review mapping on baseline updates.</threat_control>
<threat_control id="SC-010">Enforce runtime egress allowlist and halt on unauthorized destination.</threat_control>
<threat_control id="SC-011">Require monthly standards re-verification and freeze autonomous deploy on verification failure.</threat_control>

## Residual Risk
<residual_risk id="RR-001">Model output ambiguity can still occur; enforce explicit verification gates.</residual_risk>
<residual_risk id="RR-002">Operational drift possible if sync cadence is not maintained.</residual_risk>
<residual_risk id="RR-003">Fast-moving agent ecosystems can outpace static controls; require weekly control review.</residual_risk>
