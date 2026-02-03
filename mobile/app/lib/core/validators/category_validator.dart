/// Category form validation utilities.
/// Per AGENTS.md Section 5.2: Application layer logic for reusability.
/// Validation rules derived from categories-v1.yaml and business-rules/category.rules.md
class CategoryValidator {
  CategoryValidator._();

  // ============================================
  // FIELD CONSTRAINTS (from OpenAPI contract)
  // ============================================
  
  /// Name minimum length (implicit from contract)
  static const int nameMinLength = 2;
  
  /// Name maximum length (implicit from contract)
  static const int nameMaxLength = 100;
  
  /// Description maximum length
  static const int descriptionMaxLength = 500;
  
  /// Ordering minimum value
  static const int orderingMin = 0;
  
  /// Ordering maximum value
  static const int orderingMax = 9999;

  // ============================================
  // NAME VALIDATION (CAT-01)
  // ============================================
  
  /// Validate category name.
  /// Per CAT-01: Name must be unique within parent (backend validates uniqueness).
  /// Per categories-v1.yaml: name is required
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category name is required';
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
  // DESCRIPTION VALIDATION
  // ============================================
  
  /// Validate category description (optional field).
  /// Per categories-v1.yaml: description is optional
  static String? validateDescription(String? value) {
    // Description is optional
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    
    final trimmed = value.trim();
    
    if (trimmed.length > descriptionMaxLength) {
      return 'Description cannot exceed $descriptionMaxLength characters';
    }
    
    return null;
  }

  // ============================================
  // ORDERING VALIDATION (CAT-05)
  // ============================================
  
  /// Validate ordering value.
  /// Per CAT-05: Ordering determines display order in mobile.
  /// Per categories-v1.yaml: ordering is integer, default 0
  static String? validateOrdering(String? value) {
    // Ordering is required but has default
    if (value == null || value.trim().isEmpty) {
      return null; // Will use default 0
    }
    
    final trimmed = value.trim();
    final ordering = int.tryParse(trimmed);
    
    if (ordering == null) {
      return 'Please enter a valid number';
    }
    
    if (ordering < orderingMin) {
      return 'Ordering cannot be negative';
    }
    
    if (ordering > orderingMax) {
      return 'Ordering cannot exceed $orderingMax';
    }
    
    return null;
  }

  /// Parse ordering from string with default value.
  static int parseOrdering(String? value, {int defaultValue = 0}) {
    if (value == null || value.trim().isEmpty) {
      return defaultValue;
    }
    return int.tryParse(value.trim()) ?? defaultValue;
  }
}
