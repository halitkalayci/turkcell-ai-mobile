import '../../domain/entities/category.dart';
import '../../domain/ports/category_repository.dart';
import '../../core/pagination/pagination_params.dart';
import '../../core/pagination/paged_response.dart';
import '../../core/mappers/category_mapper.dart';
import '../api/category_api_client.dart';

/// Category repository adapter - implements CategoryRepository port using API client.
/// Per AGENTS.md Section 5.4: Adapters implement ports, no business rules.
class CategoryRepositoryAdapter implements CategoryRepository {
  final CategoryApiClient _apiClient;

  CategoryRepositoryAdapter({CategoryApiClient? apiClient})
      : _apiClient = apiClient ?? CategoryApiClient();

  @override
  Future<PagedResponse<Category>> listCategories(
    PaginationParams params,
  ) async {
    final pagedResponse = await _apiClient.listCategories(params);

    final categories = CategoryMapper.toDomainList(pagedResponse.items);

    return PagedResponse(
      items: categories,
      page: pagedResponse.page,
      size: pagedResponse.size,
      totalItems: pagedResponse.totalItems,
      totalPages: pagedResponse.totalPages,
    );
  }

  @override
  Future<Category> getCategoryById(String id) async {
    final response = await _apiClient.getCategoryById(id);
    return CategoryMapper.toDomain(response);
  }

  @override
  Future<Category> createCategory(Category category) async {
    final request = CategoryMapper.toCreateRequest(category);
    final response = await _apiClient.createCategory(request);
    return CategoryMapper.toDomain(response);
  }

  @override
  Future<Category> updateCategory(String id, Category category) async {
    final request = CategoryMapper.toUpdateRequest(category);
    final response = await _apiClient.updateCategory(id, request);
    return CategoryMapper.toDomain(response);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await _apiClient.deleteCategory(id);
  }
}
