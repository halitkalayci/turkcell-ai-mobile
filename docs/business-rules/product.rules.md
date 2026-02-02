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