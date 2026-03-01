# Runtime Isolation Baseline

<metadata>
  <document_id>RUNTIME_ISOLATION</document_id>
  <version>1.1.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
</metadata>

## Isolation Controls
<runtime_control id="RC-001">Agent Browser daemon runs in isolated container/VM; host credentials are not mounted read-write.</runtime_control>
<runtime_control id="RC-002">Filesystem is read-only by default; writable mounts are task-scoped and ephemeral.</runtime_control>
<runtime_control id="RC-003">Network egress allowlist is mandatory and domain-scoped.</runtime_control>
<runtime_control id="RC-004">Secrets are short-lived and injected at runtime; no persistent plaintext secret files.</runtime_control>
<runtime_control id="RC-005">Session state is encrypted at rest and auto-expired after inactivity window.</runtime_control>
<runtime_control id="RC-006">Per-action timeout and max-step limits are enforced for autonomous loops.</runtime_control>

## Egress Policy
<egress_allow id="EG-001">notebooklm.google.com</egress_allow>
<egress_allow id="EG-002">genai.owasp.org</egress_allow>
<egress_allow id="EG-003">approved target domains explicitly declared per workflow</egress_allow>
<egress_block id="EB-001">Any domain not declared in active allowlist.</egress_block>

## Credential Policy
<credential_policy id="CP-001">Rotate automation credentials at least every 30 days.</credential_policy>
<credential_policy id="CP-002">Disable dormant credentials automatically.</credential_policy>
<credential_policy id="CP-003">Require HITL token for high-impact credential usage events.</credential_policy>

## Runtime Halt Conditions
<runtime_halt id="RH-001">Isolation mode not active.</runtime_halt>
<runtime_halt id="RH-002">Unauthorized egress destination requested.</runtime_halt>
<runtime_halt id="RH-003">Secret material detected in logs/output stream.</runtime_halt>
<runtime_halt id="RH-004">Step limit, cost ceiling, or timeout exceeded.</runtime_halt>
