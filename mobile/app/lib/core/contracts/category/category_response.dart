/// Category Response - mirrors backend CategoryResponse
/// Source: docs/openapi/categories-v1.yaml
/// CRITICAL: Includes parentId and ordering fields per phase1.md Section 4.2
class CategoryResponse {
  /// Category unique identifier (UUID)
  final String id;

  /// Category name
  final String name;

  /// Category description (optional)
  final String? description;

  /// Parent category ID (null for root categories)
  /// Per phase1.md: Hierarchical structure support
  final String? parentId;

  /// Display ordering
  /// Per CAT-05: Used for sorting in mobile listings
  final int ordering;

  /// Active status
  /// Per CAT-02: Only active categories shown in mobile
  final bool isActive;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  CategoryResponse({
    required this.id,
    required this.name,
    this.description,
    this.parentId,
    required this.ordering,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON
  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      parentId: json['parentId'] as String?,
      ordering: json['ordering'] as int,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId,
      'ordering': ordering,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Check if this is a root category
  bool get isRootCategory => parentId == null;
}
