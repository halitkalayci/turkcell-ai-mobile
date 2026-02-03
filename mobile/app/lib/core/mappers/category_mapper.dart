import '../contracts/category/category_response.dart';
import '../contracts/category/create_category_request.dart';
import '../contracts/category/update_category_request.dart';
import '../../domain/entities/category.dart';

/// Mapper for Category DTO ↔ Domain Entity conversions.
/// Per AGENTS.md Section 5.5: Clean separation between layers.
class CategoryMapper {
  /// Convert CategoryResponse (DTO) to Category (Domain Entity)
  static Category toDomain(CategoryResponse response) {
    return Category(
      id: response.id,
      name: response.name,
      description: response.description,
      parentId: response.parentId,
      ordering: response.ordering,
      isActive: response.isActive,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  /// Convert Category (Domain Entity) to CreateCategoryRequest (DTO)
  static CreateCategoryRequest toCreateRequest(Category category) {
    return CreateCategoryRequest(
      name: category.name,
      description: category.description,
      parentId: category.parentId,
      ordering: category.ordering,
      isActive: category.isActive,
    );
  }

  /// Convert Category (Domain Entity) to UpdateCategoryRequest (DTO)
  static UpdateCategoryRequest toUpdateRequest(Category category) {
    return UpdateCategoryRequest(
      name: category.name,
      description: category.description,
      parentId: category.parentId,
      ordering: category.ordering,
      isActive: category.isActive,
    );
  }

  /// Convert list of CategoryResponse to list of Category entities
  static List<Category> toDomainList(List<CategoryResponse> responses) {
    return responses.map((response) => toDomain(response)).toList();
  }
}
