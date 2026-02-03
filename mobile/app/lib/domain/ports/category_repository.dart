import '../entities/category.dart';
import '../../core/pagination/pagination_params.dart';
import '../../core/pagination/paged_response.dart';

/// Category repository port (interface).
/// Per AGENTS.md Section 5.4: Ports define contracts, adapters implement.
/// This is the domain's view of category data access.
abstract class CategoryRepository {
  /// List categories with pagination
  /// Per CAT-02: Should only return active categories
  /// Per CAT-05: Default sort by ordering field
  Future<PagedResponse<Category>> listCategories(PaginationParams params);

  /// Get category by ID
  /// Per CAT-02: Should throw exception for passive categories
  Future<Category> getCategoryById(String id);

  /// Create new category
  /// Per CAT-01: Name must be unique within parent
  /// Per CAT-04: Child cannot be active if parent passive
  Future<Category> createCategory(Category category);

  /// Update existing category
  /// Per CAT-01: Name uniqueness within parent
  /// Per CAT-04: Parent-child activation constraint
  Future<Category> updateCategory(String id, Category category);

  /// Delete category (soft delete via isActive=false)
  /// Per CAT-03: Cannot delete if has products
  Future<void> deleteCategory(String id);
}
