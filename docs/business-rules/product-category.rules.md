# Product–Category Relation Rules

## Scope
Applies to the relation between Product and Category.

### REL-01 - Relation type
**Description**  
One Category → Many Products. A Product belongs to exactly one Category.

**Applies when**
- Creating a product
- Updating product `categoryId`

**Validation**
- Schema enforces single `categoryId`.


### REL-02 - Active-only binding
**Description**  
Products can only bind to an active category. Updates re-validate target category state.

**Applies when**
- Creating a product
- Updating product `categoryId`

**Validation**
- Backend rejects binding to inactive category.

**Error Code**
- `VALIDATION_ERROR`


### REL-03 - Category-based listing
**Description**  
Product listing supports `categoryId` filter; only active products are returned.

**Applies when**
- Listing products

**Validation**
- Backend filters by `categoryId` (when provided) and `isActive=true`.
