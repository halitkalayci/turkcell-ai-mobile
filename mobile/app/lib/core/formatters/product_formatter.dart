/// Product-related formatting utilities.
/// Per AGENTS.md Section 5.2: Application layer logic extracted for reusability.
/// 
/// Benefits:
/// - Single Responsibility Principle (SRP)
/// - Testable formatting logic
/// - Consistent product display across app
class ProductFormatter {
  ProductFormatter._();

  /// Extract brand name from product name.
  /// 
  /// Assumes the first word is the brand name.
  /// 
  /// Examples:
  /// - "Nike Air Force 1" -> "Nike"
  /// - "Converse Chuck Taylor" -> "Converse"
  /// - "SingleWord" -> "SingleWord"
  /// - "" -> ""
  /// 
  /// [productName] Full product name
  static String extractBrand(String productName) {
    if (productName.isEmpty) return productName;
    
    final parts = productName.trim().split(' ');
    return parts.first;
  }

  /// Extract model name from product name (everything after brand).
  /// 
  /// Examples:
  /// - "Nike Air Force 1" -> "Air Force 1"
  /// - "Converse Chuck Taylor" -> "Chuck Taylor"
  /// - "SingleWord" -> ""
  /// 
  /// [productName] Full product name
  static String extractModel(String productName) {
    if (productName.isEmpty) return '';
    
    final parts = productName.trim().split(' ');
    if (parts.length <= 1) return '';
    
    return parts.skip(1).join(' ');
  }

  /// Format product count text.
  /// 
  /// Examples:
  /// - 0 -> "No products found"
  /// - 1 -> "1 product found"
  /// - 25 -> "25 products found"
  /// 
  /// [count] Number of products
  static String formatProductCount(int count) {
    if (count == 0) return 'No products found';
    if (count == 1) return '1 product found';
    return '$count products found';
  }

  /// Truncate description to max length with ellipsis.
  /// 
  /// [description] Full description text
  /// [maxLength] Maximum characters before truncation
  static String truncateDescription(String description, {int maxLength = 100}) {
    if (description.length <= maxLength) return description;
    return '${description.substring(0, maxLength)}...';
  }
}
