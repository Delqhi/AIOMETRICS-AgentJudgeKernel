# RFC 0001: Agent Judge Gate

## Goal
Define a preflight protocol requiring judge query before architecture or implementation execution.

## Protocol
1. Resolve active notebook ID.
2. Query constraints for target module.
3. Query missing artifacts for target module.
4. For web workflows, query browser invariants and security gates.
5. Enforce minimum citation threshold for each mandatory query.
6. Verify standards baseline freshness before running judge queries.
7. Verify runtime isolation preconditions before browser execution.
8. Execute Snapshot-Interact-Validate loop with risk-tier checks.
9. Enforce stop when evidence is absent.
10. Emit structured output for logs and pipeline checks.

## Rejection Conditions
- Notebook ID missing.
- Query failure after retry.
- Zero evidence for mandatory questions.
- Citation count below configured minimum.
- Standards baseline freshness check failed.
- Runtime isolation preconditions missing.
- HIGH_RISK browser action without HITL token.
