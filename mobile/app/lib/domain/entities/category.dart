/// Category domain entity.
/// Per AGENTS.md Section 5.3: Domain contains business invariants.
/// Per phase1.md Section 4.2: Category fields with parentId and ordering.
class Category {
  /// Category unique identifier (UUID)
  final String id;

  /// Category name (unique within parent per CAT-01)
  final String name;

  /// Category description (optional)
  final String? description;

  /// Parent category ID (null for root categories)
  final String? parentId;

  /// Display ordering (per CAT-05)
  final int ordering;

  /// Active status (per CAT-02)
  final bool isActive;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.parentId,
    required this.ordering,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Check if category can be displayed in mobile
  /// Per CAT-02: Only active categories shown
  bool get canBeDisplayed => isActive;

  /// Check if category is passive
  bool get isPassive => !isActive;

  /// Check if this is a root category (no parent)
  bool get isRootCategory => parentId == null;

  /// Check if this is a child category (has parent)
  bool get isChildCategory => parentId != null;

  /// Create copy with modified fields
  Category copyWith({
    String? id,
    String? name,
    String? description,
    String? parentId,
    int? ordering,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      ordering: ordering ?? this.ordering,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, parentId: $parentId, ordering: $ordering, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
