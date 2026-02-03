/// Price formatting utilities.
/// Per AGENTS.md Section 5.2: Application layer logic extracted for reusability.
/// 
/// Benefits:
/// - Single Responsibility Principle (SRP)
/// - Testable formatting logic
/// - Consistent price display across app
class PriceFormatter {
  PriceFormatter._();

  /// Format price with currency symbol.
  /// 
  /// Examples:
  /// - 96.0 -> "$96"
  /// - 85.5 -> "$85.5"
  /// - 199.99 -> "$199.99"
  /// 
  /// [price] The numeric price value
  /// [currencySymbol] Currency symbol (default: $)
  /// [decimalDigits] Number of decimal places for non-whole numbers
  static String format(
    double price, {
    String currencySymbol = '\$',
    int decimalDigits = 1,
  }) {
    final isWholeNumber = price.truncateToDouble() == price;
    final formattedPrice = isWholeNumber
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(decimalDigits);
    
    return '$currencySymbol$formattedPrice';
  }

  /// Format price with currency code suffix.
  /// 
  /// Examples:
  /// - 96.0, "TRY" -> "96.00 TRY"
  /// - 85.5, "USD" -> "85.50 USD"
  /// 
  /// [price] The numeric price value
  /// [currencyCode] Currency code (e.g., TRY, USD, EUR)
  /// [decimalDigits] Number of decimal places
  static String formatWithCode(
    double price, {
    required String currencyCode,
    int decimalDigits = 2,
  }) {
    return '${price.toStringAsFixed(decimalDigits)} $currencyCode';
  }

  /// Format price range.
  /// 
  /// Example: "$50 - $100"
  static String formatRange(
    double minPrice,
    double maxPrice, {
    String currencySymbol = '\$',
  }) {
    return '${format(minPrice, currencySymbol: currencySymbol)} - '
        '${format(maxPrice, currencySymbol: currencySymbol)}';
  }
}
