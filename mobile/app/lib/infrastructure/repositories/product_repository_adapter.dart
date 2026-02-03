import '../../domain/entities/product.dart';
import '../../domain/ports/product_repository.dart';
import '../../core/pagination/pagination_params.dart';
import '../../core/pagination/paged_response.dart';
import '../../core/mappers/product_mapper.dart';
import '../api/product_api_client.dart';

/// Product repository adapter - implements ProductRepository port using API client.
/// Per AGENTS.md Section 5.4: Adapters implement ports, no business rules.
class ProductRepositoryAdapter implements ProductRepository {
  final ProductApiClient _apiClient;

  ProductRepositoryAdapter({ProductApiClient? apiClient})
      : _apiClient = apiClient ?? ProductApiClient();

  @override
  Future<PagedResponse<Product>> listProducts(
    PaginationParams params, {
    String? categoryId,
  }) async {
    final pagedResponse = await _apiClient.listProducts(
      params,
      categoryId: categoryId,
    );

    final products = ProductMapper.toDomainList(pagedResponse.items);

    return PagedResponse(
      items: products,
      page: pagedResponse.page,
      size: pagedResponse.size,
      totalItems: pagedResponse.totalItems,
      totalPages: pagedResponse.totalPages,
    );
  }

  @override
  Future<Product> getProductById(String id) async {
    final response = await _apiClient.getProductById(id);
    return ProductMapper.toDomain(response);
  }

  @override
  Future<Product> createProduct(Product product) async {
    final request = ProductMapper.toCreateRequest(product);
    final response = await _apiClient.createProduct(request);
    return ProductMapper.toDomain(response);
  }

  @override
  Future<Product> updateProduct(String id, Product product) async {
    final request = ProductMapper.toUpdateRequest(product);
    final response = await _apiClient.updateProduct(id, request);
    return ProductMapper.toDomain(response);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _apiClient.deleteProduct(id);
  }
}
