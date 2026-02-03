/// Product form validation utilities.
/// Per AGENTS.md Section 5.2: Application layer logic for reusability.
/// Validation rules derived from products-v2.yaml and business-rules/product.rules.md
class ProductValidator {
  ProductValidator._();

  // ============================================
  // FIELD CONSTRAINTS (from OpenAPI contract)
  // ============================================
  
  static const int nameMinLength = 2;
  static const int nameMaxLength = 120;
  static const int skuMinLength = 2;
  static const int skuMaxLength = 64;
  static const int descriptionMaxLength = 1000;
  static const int currencyLength = 3;

  // ============================================
  // NAME VALIDATION (BR-01)
  // ============================================
  
  /// Validate product name.
  /// Per BR-01: Name must be unique (backend validates uniqueness).
  /// Per products-v2.yaml: minLength 2, maxLength 120
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required';
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < nameMinLength) {
      return 'Name must be at least $nameMinLength characters';
    }
    
    if (trimmed.length > nameMaxLength) {
      return 'Name cannot exceed $nameMaxLength characters';
    }
    
    return null;
  }

  // ============================================
  // SKU VALIDATION (BR-02)
  // ============================================
  
  /// Validate SKU (optional field).
  /// Per BR-02: If provided, must be unique (backend validates uniqueness).
  /// Per products-v2.yaml: minLength 2, maxLength 64
  static String? validateSku(String? value) {
    // SKU is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length < skuMinLength) {
      return 'SKU must be at least $skuMinLength characters';
    }
    
    if (trimmed.length > skuMaxLength) {
      return 'SKU cannot exceed $skuMaxLength characters';
    }
    
    // SKU format: alphanumeric + hyphens
    final skuPattern = RegExp(r'^[a-zA-Z0-9\-]+$');
    if (!skuPattern.hasMatch(trimmed)) {
      return 'SKU can only contain letters, numbers, and hyphens';
    }
    
    return null;
  }

  // ============================================
  // PRICE VALIDATION (BR-03)
  // ============================================
  
  /// Validate price.
  /// Per BR-03: Price must be >= 0
  static String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }
    
    final trimmed = value.trim();
    final price = double.tryParse(trimmed);
    
    if (price == null) {
      return 'Please enter a valid number';
    }
    
    if (price < 0) {
      return 'Price cannot be negative';
    }
    
    return null;
  }

  // ============================================
  // CURRENCY VALIDATION
  // ============================================
  
  /// Validate currency code.
  /// Per products-v2.yaml: exactly 3 characters (ISO 4217)
  static String? validateCurrency(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Currency is required';
    }
    
    final trimmed = value.trim().toUpperCase();
    
    if (trimmed.length != currencyLength) {
      return 'Currency must be $currencyLength characters (e.g., TRY, USD)';
    }
    
    // Must be letters only
    final currencyPattern = RegExp(r'^[A-Z]+$');
    if (!currencyPattern.hasMatch(trimmed)) {
      return 'Currency must contain only letters';
    }
    
    return null;
  }

  // ============================================
  // CATEGORY VALIDATION (BR-06, BR-07)
  // ============================================
  
  /// Validate category selection.
  /// Per BR-06: Must reference an active category
  /// Per BR-07: Single category per product
  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category';
    }
    return null;
  }

  // ============================================
  // DESCRIPTION VALIDATION
  // ============================================
  
  /// Validate description (optional field).
  /// Per products-v2.yaml: maxLength 1000
  static String? validateDescription(String? value) {
    // Description is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    if (value.length > descriptionMaxLength) {
      return 'Description cannot exceed $descriptionMaxLength characters';
    }
    
    return null;
  }

  // ============================================
  // IMAGE URL VALIDATION (BR-08)
  // ============================================
  
  /// Validate image URL (optional field).
  /// Per BR-08: Image is recommended but not mandatory
  static String? validateImageUrl(String? value) {
    // Image URL is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final trimmed = value.trim();
    
    // Basic URL validation
    final urlPattern = RegExp(
      r'^https?:\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    
    if (!urlPattern.hasMatch(trimmed)) {
      return 'Please enter a valid URL (http:// or https://)';
    }
    
    return null;
  }

  // ============================================
  // HELPER METHODS
  // ============================================
  
  /// Parse price string to double
  static double? parsePrice(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return double.tryParse(value.trim());
  }

  /// Normalize currency to uppercase
  static String normalizeCurrency(String value) {
    return value.trim().toUpperCase();
  }
}
