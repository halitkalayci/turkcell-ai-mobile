# Phase 1 Difference Report — Product / Category / Relation

Date: 2026-02-03 09:55

Source of truth: [docs/analysis/phase1.md](docs/analysis/phase1.md)
Scope: Product domain, Category domain, Product–Category relation

---

## Product Domain

- WRONG:
  - Default sort uses `name` when `sort` is absent; BA specifies default "en son eklenenler" (latest first → `createdAt` desc). See [backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/adapter/ProductRepositoryJpaAdapter.java](backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/adapter/ProductRepositoryJpaAdapter.java).
  - Sort format expected in contract examples is comma (e.g., `name,asc`), but backend parses colon (`field:asc|desc`). See [docs/openapi/products-v1.yaml](docs/openapi/products-v1.yaml) and [backend/src/main/java/com/turkcell/aimobile/web/controller/ProductsController.java](backend/src/main/java/com/turkcell/aimobile/web/controller/ProductsController.java).

- MISSING:
  - `categoryId` field in product schemas/DTOs/entities. Absent in [docs/openapi/products-v1.yaml](docs/openapi/products-v1.yaml), [backend/src/main/java/com/turkcell/aimobile/dto](backend/src/main/java/com/turkcell/aimobile/dto), [backend/src/main/java/com/turkcell/aimobile/model/Product.java](backend/src/main/java/com/turkcell/aimobile/model/Product.java), [backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/entity/ProductEntity.java](backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/entity/ProductEntity.java), [mobile/app/lib/core/contracts/product](mobile/app/lib/core/contracts/product).
  - `imageUrl` (Görsel URL) in product schemas/DTOs/entities. Absent in the same locations as above.
  - Active-only behavior: listing should exclude passive products; detail access should be blocked for passive products. Not enforced in [backend/src/main/java/com/turkcell/aimobile/web/controller/ProductsController.java](backend/src/main/java/com/turkcell/aimobile/web/controller/ProductsController.java), [backend/src/main/java/com/turkcell/aimobile/application/ProductApplicationService.java](backend/src/main/java/com/turkcell/aimobile/application/ProductApplicationService.java), [backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/repository/ProductJpaRepository.java](backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/repository/ProductJpaRepository.java), and mobile UI/controller paths under [mobile/app/lib](mobile/app/lib).

- INCONSISTENT:
  - Error codes for SKU conflicts: BA/product rules expect `CONFLICT`; backend emits `SKU_ALREADY_EXISTS`. See [docs/business-rules/product.rules.md](docs/business-rules/product.rules.md), [backend/src/main/java/com/turkcell/aimobile/domain/service/ProductDomainService.java](backend/src/main/java/com/turkcell/aimobile/domain/service/ProductDomainService.java), [backend/src/main/java/com/turkcell/aimobile/exception/GlobalExceptionHandler.java](backend/src/main/java/com/turkcell/aimobile/exception/GlobalExceptionHandler.java), and OpenAPI [docs/openapi/products-v1.yaml](docs/openapi/products-v1.yaml) response examples.
  - Mobile error codes only define `PRODUCT_NAME_ALREADY_EXISTS` but not `CONFLICT` or `SKU_ALREADY_EXISTS`, causing mismatched handling. See [mobile/app/lib/core/errors/error_codes.dart](mobile/app/lib/core/errors/error_codes.dart).

- VIOLATES phase1.md:
  - UC-04/UC-05 requirements (active-only listing and passive detail blocked) are not implemented anywhere in backend/mobile product flows. See files cited above.

- EXISTS but SHOULD NOT:
  - Hard delete use-case present in application layer contradicts BA guidance to prefer active/pasif over deletion. See [backend/src/main/java/com/turkcell/aimobile/application/ProductApplicationService.java](backend/src/main/java/com/turkcell/aimobile/application/ProductApplicationService.java).

---

## Category Domain

- MISSING:
  - Entire Category domain: no contract, DTOs, entities, repositories, controllers, or mobile contracts/UI. Absent in [docs/openapi/products-v1.yaml](docs/openapi/products-v1.yaml) (no category schemas/paths), [backend/src/main/java/com/turkcell/aimobile](backend/src/main/java/com/turkcell/aimobile) (no Category artifacts), [mobile/app/lib/core/contracts](mobile/app/lib/core/contracts) (no Category DTOs), [mobile/app/lib/infrastructure](mobile/app/lib/infrastructure) (no Category adapters/ports), and [mobile/app/lib/application/ui](mobile/app/lib) (no Category screens/controllers).
  - Category fields per BA (parent category, ordering `sıralama`, active flag, audit timestamps) — entirely missing across layers due to missing Category.

- VIOLATES phase1.md:
  - BA specifies Category CRUD and passivation, hierarchical structure, and ordering for mobile listing; none exist in the current state. See [docs/analysis/phase1.md](docs/analysis/phase1.md).

---

## Product–Category Relation

- MISSING:
  - Relation field (`categoryId`) on Product to enforce 1 Category → N Product and single-category constraint. Absent in [docs/openapi/products-v1.yaml](docs/openapi/products-v1.yaml), [backend/src/main/java/com/turkcell/aimobile/model/Product.java](backend/src/main/java/com/turkcell/aimobile/model/Product.java), [backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/entity/ProductEntity.java](backend/src/main/java/com/turkcell/aimobile/infrastructure/persistence/h2/entity/ProductEntity.java), [mobile/app/lib/core/contracts/product](mobile/app/lib/core/contracts/product).
  - Category-based listing/filtering endpoints and query params. Not present in [docs/openapi/products-v1.yaml](docs/openapi/products-v1.yaml), backend controller/service, or mobile adapters/controllers.

- VIOLATES phase1.md:
  - Rule “Ürün yalnızca aktif bir kategoriye bağlanabilir” cannot be enforced because Category and the relation are absent.

- INCONSISTENT:
  - Discovery emphasis in BA is category-driven (users browse by category); current OpenAPI/mobile/backend expose only generic product paging/search/sort with no category filters.

---

## Notes on Top-level Flutter `app/lib`

- The top-level [app/lib/main.dart](app/lib/main.dart) is a scaffold and does not implement product/category logic; the active mobile implementation resides under [mobile/app/lib](mobile/app/lib). This file has no bearing on BA scope items and does not remedy Category/Relation gaps.

---

## Summary Judgment

- Product: Missing `categoryId` and `imageUrl`; active-only behavior not enforced; wrong default sort; inconsistent sort format; error code mismatch; hard delete exists and conflicts with BA.
- Category: Entire domain absent (contracts, backend, mobile).
- Relation: Absent (`categoryId` + category-driven listing), making BA rules unenforceable.

Overall: Current state significantly diverges from phase1.md for Category and Product–Category relation, and partially violates Product rules and usage scenarios.
