# Project Summary (as of 2026-02-02)

## 1- Project Overview
- **Purpose:** Education project practicing AI-assisted, contract-first development with a Java backend and Flutter clients.
- **Scope:** Focus on a "Products" module defined by an OpenAPI contract and mirrored on mobile.
- **Approach:** Contracts and documented rules drive implementation; no assumptions or invented behavior.

## 2- Backend
- **Technology:** Java with Maven; Spring-style layered structure is required by project rules.
- **Architecture Rules:** Layered: controller (web) → application (use-cases) → domain (business rules) → infrastructure (persistence/clients). Controllers must not include business logic and must not return JPA entities.
- **Source of Truth (API):** OpenAPI contract at docs/openapi/products-v1.yaml.
- **Configuration:** Application settings exist at backend/src/main/resources/application.yml.
- **Codebase Presence:** Backend scaffold exists under backend/src/main/java/com/turkcell/aimobile.
- **Current Implementation Status:** Concrete endpoints/controllers, services, and persistence details — Not Decided Yet.

## 3- Frontend
- **Technology:** Flutter.
- **Approved Baselines:** provider (state), go_router (navigation), http (API calls).
- **Apps:** Two Flutter apps exist: app and mobile. Primary app designation — Not Decided Yet.
- **Mobile Structure:** Layered files under mobile/lib (application, domain, infrastructure, core, config). Product controller and HTTP adapter are present.
- **Platform Scope:** Android and Web (per project rules).
- **Base URL:** Default base URL is http://localhost:8080 (per project rules).

## 4- What Exists?
- **Project Rules & Process:** AGENTS.md defining contract-first, layering, and no-invention policies; dependency approvals and mobile scope.
- **Decisions Log:** DECISIONS.md present; specific decision contents — Not Decided Yet in this summary.
- **Business Rules:** docs/business-rules/product.rules.md for product-related rules.
- **API Contract:** docs/openapi/products-v1.yaml defining Products API and mobile DTO source of truth.
- **Backend Artifacts:** backend/pom.xml, backend/src/main/java/com/turkcell/aimobile, backend/src/main/resources/application.yml.
- **Mobile App Code:** mobile/lib with application, domain, infrastructure, core, config layers; product module files present.
- **Secondary Flutter App:** app/lib/main.dart and app/test/widget_test.dart.
- **Build Artifacts:** Backend build outputs under backend/target; mobile build assets under mobile/app/build.

## 5- What is NOT Done yet?
- **Backend Implementation:** Controllers/services/repositories aligned to the OpenAPI — Not Decided Yet.
- **Mobile Completeness:** End-to-end flows and UI for products — Not Decided Yet.
- **Testing Depth:** Unit/integration/e2e coverage across backend and mobile — Not Decided Yet.
- **CI/CD:** Pipelines, environments, deployment strategy — Not Decided Yet.
- **Non-Functional Choices:** Logging, monitoring, security hardening, performance budgets — Not Decided Yet.
- **Primary App Choice:** Whether app or mobile is the main client — Not Decided Yet.

## 6- Current Position
- **Stage:** Early development. Contracts and rules are defined; scaffolds exist for backend and mobile.
- **Progress:** Mobile has initial product layer pieces and an HTTP adapter; backend has project structure and configuration.
- **Integration Status:** Contract-to-implementation verification and end-to-end integration — Not Decided Yet.
- **Base URL:** http://localhost:8080 (default per rules).