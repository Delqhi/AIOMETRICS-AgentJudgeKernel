# OWASP LLM Mapping

<metadata>
  <document_id>OWASP_LLM_MAPPING</document_id>
  <version>1.1.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
  <owasp_version>Top 10 for LLMs and GenAI Apps 2025</owasp_version>
</metadata>

## Control Mapping
<owasp_map id="MAP-001" owasp="LLM01:2025 Prompt Injection">Mapped to TM-001, TM-005, SC-001, SC-006, CI-003, CI-004.</owasp_map>
<owasp_map id="MAP-002" owasp="LLM02:2025 Sensitive Information Disclosure">Mapped to TM-002, TM-006, SC-007, CI-001.</owasp_map>
<owasp_map id="MAP-003" owasp="LLM03:2025 Supply Chain">Mapped to TM-004, SC-003, SC-004.</owasp_map>
<owasp_map id="MAP-004" owasp="LLM04:2025 Data and Model Poisoning">Mapped to TM-004, SC-003, HC-002.</owasp_map>
<owasp_map id="MAP-005" owasp="LLM05:2025 Improper Output Handling">Mapped to VR-001, VR-002, VR-006, AC-003.</owasp_map>
<owasp_map id="MAP-006" owasp="LLM06:2025 Excessive Agency">Mapped to TM-003, TM-007, SC-005, SC-008, CI-009, CI-010.</owasp_map>
<owasp_map id="MAP-007" owasp="LLM07:2025 System Prompt Leakage">Mapped to TM-001, TM-006, SC-007, CI-001.</owasp_map>
<owasp_map id="MAP-008" owasp="LLM08:2025 Vector and Embedding Weaknesses">Mapped to TM-004, SC-003, HC-001.</owasp_map>
<owasp_map id="MAP-009" owasp="LLM09:2025 Misinformation">Mapped to CI-003, CI-004, HC-001, HC-002.</owasp_map>
<owasp_map id="MAP-010" owasp="LLM10:2025 Unbounded Consumption">Mapped to TM-007, SC-008, HC-005.</owasp_map>

## Enforcement Requirement
<owasp_enforcement id="OE-001">No control mapped in this document may be removed without ADR + security review approval.</owasp_enforcement>

## Source
- https://genai.owasp.org/llm-top-10/
