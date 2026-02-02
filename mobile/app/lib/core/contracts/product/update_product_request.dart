/// UpdateProductRequest mirrors docs/openapi and backend DTO fields.
class UpdateProductRequest {
  final String name;
  final String? sku;
  final String? description;
  final double price;
  final String? currency; // 3-letter code
  final bool isActive;

  UpdateProductRequest({
    required this.name,
    this.sku,
    this.description,
    required this.price,
    this.currency,
    required this.isActive,
  });

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) {
    return UpdateProductRequest(
      name: json['name'] as String,
      sku: json['sku'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'currency': currency,
      'isActive': isActive,
    };
  }
}
