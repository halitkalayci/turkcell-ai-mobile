# Product Business Rules

## Scope
Applies to Product domain.


### BR-01 - Product name must be unique

**Description**  
Product name must be unique within the same tenant.

**Why**  
Prevents customer confusion and duplicate listings.

**Applies when**
- Creating a product
- Updating product name

**Validation**
- Backend checks uniqueness before persistence.

**Error Code**
- PRODUCT_NAME_ALREADY_EXISTS


### BR-02 - SKU code must be unique
**Description**  
If `sku` is provided (not null/blank), it must be unique among all products.

**Why**  
SKU is often used by integrations and inventory; duplicates cause data corruption.

**Applies when**
- Creating a product
- Updating product name

**Conflict**
- If another product already has the same SKU, return **409 CONFLICT**.

**Error Code**
- `CONFLICT`


### BR-03 - Price must be non-negative
**Description**  
Product `price` must be greater than or equal to 0.

**Why**  
Prevents invalid pricing.

**Applies when**
- Creating a product
- Updating a product

**Validation**
- Backend rejects negative prices.

**Error Code**
- `VALIDATION_ERROR`


### BR-04 - Active lifecycle behavior
**Description**  
Inactive (`isActive=false`) products are not listed. Product detail access is blocked for inactive products.

**Why**  
Aligns with UC-04/UC-05 and mobile experience.

**Applies when**
- Listing products
- Getting product detail by id

**Validation**
- Listing returns only active products.
- Inactive product detail returns not found.

**Error Code**
- `NOT_FOUND` (for inactive product detail)


### BR-05 - Default sort (latest first)
**Description**  
When `sort` is absent, default ordering is `createdAt,desc` (latest first).

**Applies when**
- Listing products

**Validation**
- Backend applies default sort.


### BR-06 - Category binding must target an active category
**Description**  
Every product must have a `categoryId` and may only bind to an active category.

**Why**  
Ensures discoverability and integrity of product–category relation.

**Applies when**
- Creating a product
- Updating product `categoryId`

**Validation**
- Backend rejects binding to inactive/non-existing category.

**Error Code**
- `VALIDATION_ERROR`


### BR-07 - Single category per product
**Description**  
A product belongs to exactly one category.

**Why**  
Simplifies mini e-commerce scope and UX.

**Applies when**
- Create/update product

**Validation**
- Schema and backend enforce single `categoryId`.


### BR-08 - Image URL preference
**Description**  
Products should preferably have at least one image; `imageUrl` is recommended (not mandatory in v2).

**Why**  
Improves mobile UX and product presentation.

**Applies when**
- Create/update product

**Validation**
- If missing, system may log warnings; no rejection by default.


### Error Code Policy (Product)
- External API code: `CONFLICT` for uniqueness violations; domain reason is included in `details` (e.g., `PRODUCT_NAME_ALREADY_EXISTS`, `SKU_ALREADY_EXISTS`).
- `VALIDATION_ERROR` for price < 0, missing `categoryId`, or binding to inactive category.
- `NOT_FOUND` for inactive product detail access.