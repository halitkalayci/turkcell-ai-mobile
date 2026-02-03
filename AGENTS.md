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

---

## 5) FRONTEND (FLUTTER) ARCHITECTURE

Flutter projects MUST follow layered, contract-first, SSOT principles mirroring the backend.

Layering:

`ui (widgets/screens) -> application (use-cases/controllers) -> domain (entities/value objects) -> infrastructure (api/storage adapters) -> core (contracts/mappers/errors/pagination) -> config (env/base-url)`

### 5.1) UI (widgets/screens)

- No business logic.
- Uses `Provider` for state management (approved).
- Navigation via `go_router` (approved).
- Only interacts with `application` layer.
- Never handles raw HTTP or persistence directly.

### 5.2) Application (use-cases/controllers)

- Orchestrates use-cases, maps to/from `domain`, calls `infrastructure` ports.
- MUST be unit-testable.
- No framework-specific UI code.

### 5.3) Domain

- Contains domain entities/value objects and invariants.
- Avoid framework annotations.
- No external dependencies.

### 5.4) Infrastructure

- Implements ports for API and storage.
- No business rules.
- HTTP client: `http` (approved baseline) for adapters.

### 5.5) Core (SSOT)

- Contracts (DTOs) mirrored from OpenAPI under `docs/openapi` and backend DTO names.
- Mappers, error models, pagination helpers.
- Core is the single source of truth for mobile types.

### 5.6) Config

- Environment configuration and base URLs.
- Default base URL: `http://localhost:8080`.
- Platform scope: **Android** and **Web** only (current).

---

## 6) MOBILE CONTRACT-FIRST RULES

- Mobile DTOs MUST mirror `docs/openapi` contracts and backend DTO names exactly.
- Source of truth: `docs/openapi/products-v1.yaml` and backend DTOs:
  - `CreateProductRequest`, `UpdateProductRequest`, `ProductResponse`, `PagedProductResponse`, `ErrorResponse`.
- NO CONTRACT = NO ADAPTER/CONTROLLER.
- Any change to mobile types REQUIRES updating the OpenAPI contract first.

---

## 7) MOBILE DEPENDENCY APPROVAL FLOW

- Approved baseline dependencies:
  - State management: `provider`
  - Navigation: `go_router`
  - HTTP client: `http`
- Any additional dependency MUST have explicit approval before inclusion.

---

## 8) SSOT ENFORCEMENT CHECKLIST (MOBILE)

- Verify all mobile contract types against `docs/openapi/products-v1.yaml`.
- Verify error codes against `docs/business-rules/` (e.g., `PRODUCT_NAME_ALREADY_EXISTS`, `CONFLICT`).
- Verify pagination/query param names (`page`, `size`, `q`, `sort`) match the contract.
- Prohibit endpoint/field invention in mobile.
- Sync changes with contracts BEFORE implementation.

---

## 9) Business Rules Enforcement (Backend & Mobile)

- Source of truth: All business behavior MUST be defined under `docs/business-rules/` before any implementation.
- Required workflow:
  - BEFORE changing controllers/adapters/services, verify corresponding rule files exist and fully cover the current analysis needs.
  - If rules are missing or incomplete, CREATE/UPDATE files in `docs/business-rules/` first. **NO RULE = NO IMPLEMENTATION.**
  - Use stable rule IDs (e.g., `BR-04`, `CAT-02`, `REL-01`) and reference them in PR descriptions and changelogs.
  - Error-code policy: External API codes (`CONFLICT`, `VALIDATION_ERROR`, `NOT_FOUND`) are authoritative. Domain reasons (e.g., `PRODUCT_NAME_ALREADY_EXISTS`, `SKU_ALREADY_EXISTS`) go into `details`.
- Review gate:
  - CI must fail if a controller/adapter references behavior not present in `docs/business-rules/`.
  - Contract-first remains mandatory: NO CONTRACT = NO CONTROLLER.