# Category Business Rules

## Scope
Applies to Category domain.

### CAT-01 - Category name uniqueness within parent
**Description**  
Category `name` must be unique under the same parent category.

**Why**  
Prevents confusion and duplicate navigation nodes.

**Applies when**
- Creating a category
- Updating category `name` or `parentId`

**Validation**
- Backend checks uniqueness within parent context.

**Error Code**
- `CONFLICT`


### CAT-02 - Passive cascade & listing behavior
**Description**  
Passive categories (isActive=false) are not listed. A passive parent implies the entire subtree is passive.

**Applies when**
- Listing categories
- Activating/deactivating categories

**Validation**
- Backend blocks listing of passive categories.
- Activating a child while parent is passive is rejected.

**Error Code**
- `VALIDATION_ERROR`


### CAT-03 - No hard delete when products exist
**Description**  
Categories with bound products cannot be hard deleted; use passivation instead.

**Why**  
Protects referential integrity and preserves auditability.

**Applies when**
- Deleting a category

**Validation**
- Backend rejects delete if products exist.

**Error Code**
- `CONFLICT`


### CAT-04 - Parent-child activation constraint
**Description**  
A child category cannot be active if its parent is passive.

**Applies when**
- Activating child category

**Validation**
- Backend rejects activation when parent is passive.

**Error Code**
- `VALIDATION_ERROR`


### CAT-05 - Ordering for listing
**Description**  
Use `ordering` field to determine display order.

**Applies when**
- Listing categories (mobile)

**Validation**
- Backend returns only active categories ordered by `ordering`.
