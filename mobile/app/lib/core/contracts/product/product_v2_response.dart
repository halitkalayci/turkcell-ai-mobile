/// Product Response V2 - mirrors backend ProductResponseV2
/// Source: docs/openapi/products-v2.yaml
/// CRITICAL: Includes categoryId and imageUrl fields per phase1-dif-report.md
class ProductV2Response {
  /// Product unique identifier (UUID)
  final String id;

  /// Product name
  final String name;

  /// Stock Keeping Unit
  final String sku;

  /// Product description
  final String description;

  /// Product price
  final double price;

  /// Currency code
  final String currency;

  /// Active status (per BR-04: only active products shown in listings)
  final bool isActive;

  /// Category ID (per REL-01: one-to-one product-category relation)
  final String categoryId;

  /// Product image URL (per BR-08)
  final String? imageUrl;

  /// Creation timestamp (for default sort per BR-05)
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  ProductV2Response({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.price,
    required this.currency,
    required this.isActive,
    required this.categoryId,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory ProductV2Response.fromJson(Map<String, dynamic> json) {
    return ProductV2Response(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      isActive: json['isActive'] as bool,
      categoryId: json['categoryId'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'currency': currency,
      'isActive': isActive,
      'categoryId': categoryId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
