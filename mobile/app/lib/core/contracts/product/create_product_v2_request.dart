/// Create Product Request V2 - mirrors backend CreateProductRequestV2
/// Source: docs/openapi/products-v2.yaml
/// CRITICAL: Includes categoryId and imageUrl fields per phase1-dif-report.md
class CreateProductV2Request {
  /// Product name (required, unique per category per BR-01)
  final String name;

  /// Stock Keeping Unit (required, globally unique per BR-02)
  final String sku;

  /// Product description (required)
  final String description;

  /// Product price (required, must be >= 0 per BR-03)
  final double price;

  /// Currency code (required, default: TRY)
  final String currency;

  /// Active status (required, default: true)
  final bool isActive;

  /// Category ID (required per REL-01, REL-02)
  /// Must reference an active category per BR-06
  final String categoryId;

  /// Product image URL (optional but recommended per BR-08)
  final String? imageUrl;

  CreateProductV2Request({
    required this.name,
    required this.sku,
    required this.description,
    required this.price,
    required this.currency,
    required this.isActive,
    required this.categoryId,
    this.imageUrl,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'currency': currency,
      'isActive': isActive,
      'categoryId': categoryId,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  /// Create from JSON
  factory CreateProductV2Request.fromJson(Map<String, dynamic> json) {
    return CreateProductV2Request(
      name: json['name'] as String,
      sku: json['sku'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      isActive: json['isActive'] as bool,
      categoryId: json['categoryId'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}
