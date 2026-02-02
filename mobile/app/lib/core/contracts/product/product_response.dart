/// ProductResponse mirrors backend DTO and OpenAPI schema.
class ProductResponse {
  final String id;
  final String name;
  final String? sku;
  final String? description;
  final double price;
  final String? currency;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductResponse({
    required this.id,
    required this.name,
    this.sku,
    this.description,
    required this.price,
    this.currency,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      sku: json['sku'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'currency': currency,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
