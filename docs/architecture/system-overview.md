# System Overview

## C4 Level 1 - System Context
```mermaid
flowchart LR
  U[Human Operator] --> A[Coder Agent]
  A --> J[Judge Query Script]
  A --> B[Agent Browser CLI]
  B --> W[Web Target]
  B --> A
  J --> N[NotebookLM Judge Kernel]
  N --> J
  J --> A
  A --> R[Project Repositories]
  A --> O[Delivery Outputs]
```

## C4 Level 2 - Container View
```mermaid
flowchart TD
  subgraph AgentRuntime[Agent Runtime]
    P[Preflight Gate]
    Q[Query Adapter]
    V[Evidence Validator]
    B[Backlog Extractor]
    S[Snapshot-Interact-Validate Engine]
  end

  subgraph NLM[NotebookLM]
    K1[Constitution Sources]
    K2[SRS Sources]
    K3[IDD Sources]
    K4[Agent Browser Protocol]
    K5[SRE Sources]
    K6[Threat Sources]
  end

  subgraph BrowserLayer[Browser Layer]
    AB[Agent Browser]
    AT[Accessibility Tree Refs]
    TS[Target Systems]
  end

  P --> Q
  Q --> NLM
  NLM --> V
  V --> B
  V --> S
  S --> AB
  AB --> AT
  AB --> TS
```

## Trust Boundaries
- Boundary 1: Agent runtime to external NotebookLM API.
- Boundary 2: Notebook evidence to autonomous execution decision.
- Boundary 3: Governance documents to implementation repositories.
