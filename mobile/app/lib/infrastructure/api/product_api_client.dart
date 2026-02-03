import '../../config/api_config.dart';
import '../../core/contracts/product/product_v2_response.dart';
import '../../core/contracts/product/paged_product_v2_response.dart';
import '../../core/contracts/product/create_product_v2_request.dart';
import '../../core/contracts/product/update_product_v2_request.dart';
import '../../core/pagination/pagination_params.dart';
import 'http_client.dart';

/// Product API client for V2 endpoints.
/// Source: docs/openapi/products-v2.yaml
/// CRITICAL Business Rules:
/// - BR-04: Only active products in listings (isActive=true filter)
/// - BR-05: Default sort by createdAt:desc (latest first)
/// - REL-03: Support categoryId filter for product listings
class ProductApiClient {
  final HttpClient _httpClient;

  ProductApiClient({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  /// List products with pagination and filters
  /// Per BR-04: Active-only filter applied
  /// Per BR-05: Default sort createdAt:desc
  /// Per REL-03: Optional categoryId filter
  Future<PagedProductV2Response> listProducts(
    PaginationParams params, {
    String? categoryId,
  }) async {
    // Build query params with business rules
    final queryParams = params.toQueryParams();
    
    // BR-04: Active-only filter (mobile should only see active products)
    queryParams['isActive'] = 'true';

    // REL-03: Category filter if provided
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['categoryId'] = categoryId;
    }

    // BR-05: Default sort by createdAt desc if not specified
    if (!queryParams.containsKey('sort')) {
      queryParams['sort'] = 'createdAt:desc';
    }

    final response = await _httpClient.get(
      ApiConfig.productsV2Path,
      queryParams: queryParams,
    );

    return PagedProductV2Response.fromJson(response);
  }

  /// Get product by ID
  /// Per BR-04: Should return 404 for passive products (backend enforces)
  Future<ProductV2Response> getProductById(String id) async {
    final response = await _httpClient.get('${ApiConfig.productsV2Path}/$id');
    return ProductV2Response.fromJson(response);
  }

  /// Create new product
  /// Per BR-06: categoryId must reference active category (backend validates)
  Future<ProductV2Response> createProduct(
    CreateProductV2Request request,
  ) async {
    final response = await _httpClient.post(
      ApiConfig.productsV2Path,
      body: request.toJson(),
    );
    return ProductV2Response.fromJson(response);
  }

  /// Update product
  /// Per BR-02: SKU conflicts return CONFLICT error
  Future<ProductV2Response> updateProduct(
    String id,
    UpdateProductV2Request request,
  ) async {
    final response = await _httpClient.put(
      '${ApiConfig.productsV2Path}/$id',
      body: request.toJson(),
    );
    return ProductV2Response.fromJson(response);
  }

  /// Delete product (soft delete via isActive=false)
  /// Note: Per AGENTS.md, prefer passive status over hard delete
  Future<void> deleteProduct(String id) async {
    await _httpClient.delete('${ApiConfig.productsV2Path}/$id');
  }

  /// Close HTTP client
  void close() {
    _httpClient.close();
  }
}
