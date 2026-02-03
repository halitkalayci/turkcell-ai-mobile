/// Standard error codes used across the application.
/// External API codes are authoritative per AGENTS.md Section 9.
/// Domain-specific reasons go in ErrorResponse.details field.
class ErrorCodes {
  // External API Error Codes (go in ErrorResponse.code field)
  
  /// Conflict error - resource already exists (409)
  static const String conflict = 'CONFLICT';

  /// Validation error - invalid input data (400)
  static const String validationError = 'VALIDATION_ERROR';

  /// Resource not found (404)
  static const String notFound = 'NOT_FOUND';

  /// Internal server error (500)
  static const String internalError = 'INTERNAL_ERROR';

  /// Unauthorized access (401)
  static const String unauthorized = 'UNAUTHORIZED';

  /// Forbidden access (403)
  static const String forbidden = 'FORBIDDEN';

  // Domain-Specific Error Reasons (go in ErrorResponse.details array)
  
  /// Product name already exists in category (per BR-01)
  static const String productNameAlreadyExists = 'PRODUCT_NAME_ALREADY_EXISTS';

  /// SKU already exists globally (per BR-02)
  static const String skuAlreadyExists = 'SKU_ALREADY_EXISTS';

  /// Category name already exists within parent (per CAT-01)
  static const String categoryNameAlreadyExists = 'CATEGORY_NAME_ALREADY_EXISTS';

  /// Category has products, cannot be deleted (per CAT-03)
  static const String categoryHasProducts = 'CATEGORY_HAS_PRODUCTS';

  /// Parent category is passive (per CAT-04)
  static const String parentCategoryPassive = 'PARENT_CATEGORY_PASSIVE';

  /// Product is passive, cannot access detail (per BR-04)
  static const String productPassive = 'PRODUCT_PASSIVE';

  /// Category is passive, cannot bind product (per BR-06)
  static const String categoryPassive = 'CATEGORY_PASSIVE';

  /// Invalid category ID (per REL-01)
  static const String invalidCategoryId = 'INVALID_CATEGORY_ID';

  /// Negative price not allowed (per BR-03)
  static const String negativePriceNotAllowed = 'NEGATIVE_PRICE_NOT_ALLOWED';
}
