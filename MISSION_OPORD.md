# MISSION OPORD

<metadata>
  <document_id>MISSION_OPORD</document_id>
  <version>1.0.0</version>
  <status>ACCEPTED</status>
  <effective_date>2026-03-01</effective_date>
</metadata>

## Situation
<opord_situation>
- Multi-agent coding environment with parallel repositories.
- Risk: inconsistent architecture decisions and undocumented changes.
- Requirement: deterministic governance before implementation.
</opord_situation>

## Mission
<opord_mission>
Establish one Judge NotebookLM kernel that all coder agents query before architecture and implementation actions.
</opord_mission>

## Execution
<opord_execution>
- Phase 1: define constitution + constraints + contracts.
- Phase 2: publish runbooks and threat model.
- Phase 3: enforce query gate with evidence requirement.
- Phase 4: synchronize kernel documents to NotebookLM.
</opord_execution>

## Sustainment
<opord_sustainment>
- Version each document incrementally.
- Maintain changelog in ADR/RFC updates.
- Run daily sync health checks.
</opord_sustainment>

## Command And Control
<opord_command_control>
- Authority: Human operator.
- Execution agents: coding assistants and automation workers.
- Escalation: missing evidence, conflicting constraints, or unresolved threat findings.
</opord_command_control>
