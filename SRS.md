# Software Requirements Specification

<metadata>
  <document_id>SRS</document_id>
  <version>1.2.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
  <standard_ref>ISO/IEC/IEEE 29148:2018 (tailored)</standard_ref>
</metadata>

## Functional Requirements
<srs_requirement id="FR-001" priority="MUST">
The system must provide deterministic retrieval of active constraints for a target module.
</srs_requirement>

<srs_requirement id="FR-002" priority="MUST">
The system must provide deterministic retrieval of missing artifacts for a target module and sprint scope.
</srs_requirement>

<srs_requirement id="FR-003" priority="MUST">
The system must fail closed when no evidence is available.
</srs_requirement>

<srs_requirement id="FR-004" priority="MUST">
The system must support role-specific views: architecture, application, infrastructure, SRE, and security.
</srs_requirement>

<srs_requirement id="FR-005" priority="SHOULD">
The system should provide machine-readable response payloads for pipeline integration.
</srs_requirement>

<srs_requirement id="FR-006" priority="MUST">
The system must enforce a browser Snapshot-Interact-Validate loop for every web action sequence.
</srs_requirement>

<srs_requirement id="FR-007" priority="MUST">
The system must model browser interactions through stable accessibility references rather than fragile CSS selectors.
</srs_requirement>

<srs_requirement id="FR-008" priority="MUST">
The system must classify actions by risk tier and require HITL tokens for HIGH_RISK classes.
</srs_requirement>

<srs_requirement id="FR-009" priority="SHOULD">
The system should store persistent session traces for restart-safe autonomous workflows.
</srs_requirement>

<srs_requirement id="FR-010" priority="MUST">
The preflight gate must fail closed when citation_count is below configured threshold for any mandatory query.
</srs_requirement>

<srs_requirement id="FR-011" priority="MUST">
The browser runtime must enforce isolation and egress allowlist controls before autonomous execution.
</srs_requirement>

<srs_requirement id="FR-012" priority="MUST">
The preflight gate must enforce standards baseline freshness before any autonomous execution step.
</srs_requirement>

## Non-Functional Requirements
<nfr id="NFR-001" category="latency">Judge query P95 under 5 seconds for cached contexts.</nfr>
<nfr id="NFR-002" category="reliability">Query success rate >= 99.0% per 30-day window.</nfr>
<nfr id="NFR-003" category="security">No plaintext secret persistence in source or runtime logs.</nfr>
<nfr id="NFR-004" category="traceability">100% of architecture decisions linked to source evidence ID.</nfr>
<nfr id="NFR-005" category="operability">Runbook coverage for all Sev-1 and Sev-2 failure modes.</nfr>
<nfr id="NFR-006" category="token_efficiency">Browser state representation should reduce context noise by at least 80% compared with raw DOM payloads.</nfr>
<nfr id="NFR-007" category="cost_control">Autonomous runtime must remain within approved monthly spend limits.</nfr>
<nfr id="NFR-008" category="compliance">Controls must maintain documented mapping to OWASP GenAI Top 10 2025 and current standards baseline.</nfr>

## Acceptance Criteria
<srs_acceptance id="AC-001">Agent receives constraint set for module in one query cycle.</srs_acceptance>
<srs_acceptance id="AC-002">Agent receives missing artifact list in one query cycle.</srs_acceptance>
<srs_acceptance id="AC-003">Agent halts when evidence_count == 0.</srs_acceptance>
<srs_acceptance id="AC-004">Kernel docs are synchronized and versioned.</srs_acceptance>
<srs_acceptance id="AC-005">Browser workflows execute snapshot -> action -> validation without skipped steps.</srs_acceptance>
<srs_acceptance id="AC-006">HIGH_RISK actions are blocked without HITL token.</srs_acceptance>
<srs_acceptance id="AC-007">Preflight gate blocks execution when citations are below threshold.</srs_acceptance>
<srs_acceptance id="AC-008">Runtime isolation halt conditions are validated before browser automation starts.</srs_acceptance>
<srs_acceptance id="AC-009">Preflight gate blocks execution when standards baseline freshness check fails.</srs_acceptance>
