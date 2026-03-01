# ADR 0001: Judge Kernel Architecture

## Status
Accepted

## Context
Multiple agents need one deterministic governance source to prevent scope drift and unsafe implementation.

## Decision
Adopt a NotebookLM-based judge kernel with atomic documents and XML semantic layers.
Adopt Agent Browser as the deterministic sensor/actuator layer for web interactions.
Adopt citation-threshold preflight gating as a mandatory CI quality gate.
Adopt explicit standards/OWASP mapping and runtime isolation baseline as first-class kernel artifacts.

## Consequences
- Positive: centralized constraints and explicit evidence tracing.
- Positive: reusable query templates for all modules.
- Positive: reduced token noise for web-state perception through accessibility-ref snapshots.
- Positive: deterministic block on low-evidence outputs via citation-threshold gate.
- Positive: explicit compliance traceability to standards and OWASP LLM risks.
- Positive: monthly automated standards drift detection with hard fail behavior.
- Negative: requires active sync and document maintenance discipline.
- Negative: higher operational overhead for monthly standards verification and isolation controls.
