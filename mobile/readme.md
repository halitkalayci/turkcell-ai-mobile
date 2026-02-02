# Mobile Frontend (Flutter)

Contract-first, SSOT-driven Flutter frontend for the mini e-commerce system.

## Platforms
- Android
- Web

## Architecture & Layering
`ui (widgets/screens)` → `application (use-cases/controllers)` → `domain (entities/value objects)` → `infrastructure (api/storage adapters)` → `core (contracts/mappers/errors/pagination)` → `config (env/base-url)`

- UI: No business logic; uses Provider; navigation via go_router.
- Application: Orchestrates use-cases; maps to/from domain; calls infrastructure ports; unit-testable.
- Domain: Entities/value objects; no framework dependencies.
- Infrastructure: Implements ports for API/storage; no business rules; HTTP adapters use `http`.
- Core (SSOT): Contracts mirror docs/openapi and backend DTOs; mappers, errors, pagination.
- Config: Environment/base URL; default `http://localhost:8080`.

## SSOT & Contract-First
- Source of truth: ../docs/openapi/products-v1.yaml and backend DTOs.
- Mobile types must mirror:
  - CreateProductRequest, UpdateProductRequest, ProductResponse, PagedProductResponse, ErrorResponse.
- No contract = no controller/adapter.

## Approved Dependencies
- provider
- go_router
- http

## Getting Started (scaffold)
1) Create Flutter app for Android + Web:
```bash
flutter create --platforms=android,web app
```
2) Copy/ensure files under `mobile/app/` match this repository structure.
3) Run (Web):
```bash
flutter run -d chrome
```
4) Run (Android):
```bash
flutter run -d android
```

## Next Batches
- Core contract DTOs and product API port.
- Application controllers and UI shells.
