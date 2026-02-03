/// Create Category Request - mirrors backend CreateCategoryRequest
/// Source: docs/openapi/categories-v1.yaml
/// CRITICAL: Includes parentId and ordering fields per phase1.md Section 4.2
class CreateCategoryRequest {
  /// Category name (required, unique within parent per CAT-01)
  final String name;

  /// Category description (optional)
  final String? description;

  /// Parent category ID (optional, null for root categories)
  /// Per CAT-04: Child cannot be active if parent is passive
  final String? parentId;

  /// Display ordering (required, default: 0)
  /// Per CAT-05: Used for mobile listing order
  final int ordering;

  /// Active status (required, default: true)
  /// Per CAT-02: Passive categories not shown in mobile
  final bool isActive;

  CreateCategoryRequest({
    required this.name,
    this.description,
    this.parentId,
    required this.ordering,
    required this.isActive,
  });

  /// Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId,
      'ordering': ordering,
      'isActive': isActive,
    };
  }

  /// Create from JSON
  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) {
    return CreateCategoryRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      parentId: json['parentId'] as String?,
      ordering: json['ordering'] as int,
      isActive: json['isActive'] as bool,
    );
  }
}
