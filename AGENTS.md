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