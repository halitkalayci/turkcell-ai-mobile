/// Product domain entity.
/// Per AGENTS.md Section 5.3: Domain contains business invariants.
/// Per phase1.md Section 5.2: Product fields with categoryId and imageUrl.
class Product {
  /// Product unique identifier (UUID)
  final String id;

  /// Product name (unique per category per BR-01)
  final String name;

  /// Stock Keeping Unit (globally unique per BR-02)
  final String sku;

  /// Product description
  final String description;

  /// Product price (must be >= 0 per BR-03)
  final double price;

  /// Currency code
  final String currency;

  /// Active status (per BR-04)
  final bool isActive;

  /// Category ID (per REL-01: one-to-one relation)
  final String categoryId;

  /// Product image URL (per BR-08)
  final String? imageUrl;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  Product({
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
  }) {
    // Domain invariant: price cannot be negative (BR-03)
    if (price < 0) {
      throw ArgumentError('Price cannot be negative');
    }
  }

  /// Check if product can be displayed in mobile
  /// Per BR-04: Only active products shown
  bool get canBeDisplayed => isActive;

  /// Check if product is passive
  bool get isPassive => !isActive;

  /// Check if product has image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Create copy with modified fields
  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? description,
    double? price,
    String? currency,
    bool? isActive,
    String? categoryId,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, sku: $sku, isActive: $isActive, categoryId: $categoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
