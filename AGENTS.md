# AGENTS.md
AI-Assisted Development Rules

Version: 0.1

Last Update: 2.02.2026

---

## 1) HOW TO WORK (MANDATORY WORKFLOW)

### 1.1) CODE GENERATION POLICY

- Always plan first, generation second.

- Always propose a file breakdown (what files will be created/changed) and wait for an approval.

### 1.2) SMALL BATCH RULE

- Generate maximum of 5 files if strongly coupled. DO NOT proceed with next batches without explict approval for current batch.

### 1.3) COMMENT STRATEGY

- Comment only where intent is non-obvious.

- DO NOT add comments on every line, only summary for functions/classes.

### 1.4) NO INVENTING

- endpoints, request/response fields, error models

- event names/payloads

- business rules

If any detail is missing, ASK.

## 2) CONTRACT FIRST

### 2.1) OpenAPI is the source of truth

- API contracts live under: `docs/openapi`

- Implementation MUST follow the contracts.

### 2.2) Code Generation Policy

- We may use OpenAPI tooling ONLY if already present in the repository.

- You MUST NOT add new OpenAPI generator dependencies without explicit approval.

- If no generator is available, implement controllers/DTOs manually to match the spec.

### 2.3) NO CONTRACT = NO CONTROLLER

- **BEFORE creating ANY controller**, FIRST check `docs/openapi/` for existing contract.

- If contract does NOT exist for the requested controller:
  - STOP immediately
  - WARN the user that OpenAPI contract is missing
  - REQUEST the user to provide the contract first
  - DO NOT generate any controller code

- EXCEPTION: Non-API files (Application.java, config, utilities) can be created without contracts.


## 3) Business Rules Are Never Invented

**Rule**  
If any business rule is required while generating code, documentation, or tests:

- ALWAYS check `/docs/business-rules/`
- If a relevant rule exists, apply it exactly as defined
- If no rule exists, DO NOT invent, assume, or infer a new rule
- Instead, STOP and explicitly warn that the rule is missing

AI must never create new business rules implicitly.

**Why this in an enterprise project?**

- Invented rules create:
  - silent behavior changes
  - inconsistent implementations
  - hidden product decisions
- In enterprise systems:
  - business rules are **decisions**, not implementation details
  - every rule must be reviewable, versioned, and approved
- This rule enforces:
  - a single source of truth for business behavior
  - alignment between product, backend, mobile, and QA
  - safe AI usage without accidental domain drift

**Expected AI Behavior**
- “No rule found in `/docs/business-rules`. Please define it before implementation.”
- NOT: guessing, defaulting, or making assumptions.


## 4) BACKEND (SPRING) ARCHITECTURE

Each spring project MUST follow this layering

`controller (web) -> application (use-cases) -> domain (business rules) -> infrastructure (persistence/clients/messaging etc..)`

Each project MUST follow `Hexagonal Architecture` principles.

### 4.1) Controller (web)

- No business logic

- Validates input, maps to application layer, return response DTOs.

- NEVER returns JPA entities.


### 4.2) Application (use-cases)

- Orchestates use-cases, transaction, ports.

- MUST BE unit-testable.

### 4.3) Domain

- Containes business invariants and domain model.

- Avoid framework annotations in domain if possible.

### 4.4) Infrastructure

- JPA entities, repositories, external clients

- No business rules!