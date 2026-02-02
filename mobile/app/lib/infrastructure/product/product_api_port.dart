import '../../core/contracts/product/create_product_request.dart';
import '../../core/contracts/product/update_product_request.dart';
import '../../core/contracts/product/paged_product_response.dart';
import '../../core/contracts/product/product_response.dart';

/// Contract-first API port for Product operations.
/// No endpoints or semantics are invented; implementations must follow docs/openapi/products-v1.yaml.
abstract class ProductApiPort {
  /// List products with pagination and optional search/sort.
  Future<PagedProductResponse> listProducts({
    required int page,
    required int size,
    String? q,
    String? sort,
  });

  /// Fetch a single product by id.
  Future<ProductResponse> getProductById(String id);

  /// Create a product.
  Future<ProductResponse> createProduct(CreateProductRequest body);

  /// Update a product by id.
  Future<ProductResponse> updateProduct(String id, UpdateProductRequest body);
}
