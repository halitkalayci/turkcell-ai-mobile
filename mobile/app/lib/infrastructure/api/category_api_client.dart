import '../../config/api_config.dart';
import '../../core/contracts/category/category_response.dart';
import '../../core/contracts/category/paged_category_response.dart';
import '../../core/contracts/category/create_category_request.dart';
import '../../core/contracts/category/update_category_request.dart';
import '../../core/pagination/pagination_params.dart';
import 'http_client.dart';

/// Category API client for V1 endpoints.
/// Source: docs/openapi/categories-v1.yaml
/// CRITICAL Business Rules:
/// - CAT-02: Only active categories in listings (isActive=true filter)
/// - CAT-05: Sort by ordering field for mobile display
class CategoryApiClient {
  final HttpClient _httpClient;

  CategoryApiClient({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  /// List categories with pagination
  /// Per CAT-02: Active-only filter applied
  /// Per CAT-05: Default sort by ordering field
  Future<PagedCategoryResponse> listCategories(
    PaginationParams params,
  ) async {
    // Build query params with business rules
    final queryParams = params.toQueryParams();
    
    // CAT-02: Active-only filter (mobile should only see active categories)
    queryParams['isActive'] = 'true';

    // CAT-05: Default sort by ordering for mobile display
    if (!queryParams.containsKey('sort')) {
      queryParams['sort'] = 'ordering:asc';
    }

    final response = await _httpClient.get(
      ApiConfig.categoriesV1Path,
      queryParams: queryParams,
    );

    return PagedCategoryResponse.fromJson(response);
  }

  /// Get category by ID
  /// Per CAT-02: Backend should return 404 for passive categories
  Future<CategoryResponse> getCategoryById(String id) async {
    final response = await _httpClient.get('${ApiConfig.categoriesV1Path}/$id');
    return CategoryResponse.fromJson(response);
  }

  /// Create new category
  /// Per CAT-01: Name must be unique within parent (backend validates)
  /// Per CAT-04: Child cannot be active if parent passive (backend validates)
  Future<CategoryResponse> createCategory(
    CreateCategoryRequest request,
  ) async {
    final response = await _httpClient.post(
      ApiConfig.categoriesV1Path,
      body: request.toJson(),
    );
    return CategoryResponse.fromJson(response);
  }

  /// Update category
  /// Per CAT-01: Name uniqueness within parent (backend validates)
  /// Per CAT-04: Parent-child activation constraint (backend validates)
  Future<CategoryResponse> updateCategory(
    String id,
    UpdateCategoryRequest request,
  ) async {
    final response = await _httpClient.put(
      '${ApiConfig.categoriesV1Path}/$id',
      body: request.toJson(),
    );
    return CategoryResponse.fromJson(response);
  }

  /// Delete category (soft delete via isActive=false)
  /// Per CAT-03: Cannot delete if has products (backend validates)
  Future<void> deleteCategory(String id) async {
    await _httpClient.delete('${ApiConfig.categoriesV1Path}/$id');
  }

  /// Close HTTP client
  void close() {
    _httpClient.close();
  }
}
