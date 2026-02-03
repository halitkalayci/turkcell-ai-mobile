import '../entities/product.dart';
import '../../core/pagination/pagination_params.dart';
import '../../core/pagination/paged_response.dart';

/// Product repository port (interface).
/// Per AGENTS.md Section 5.4: Ports define contracts, adapters implement.
/// This is the domain's view of product data access.
abstract class ProductRepository {
  /// List products with pagination and optional category filter
  /// Per BR-04: Should only return active products
  /// Per BR-05: Default sort by createdAt desc
  /// Per REL-03: Support categoryId filter
  Future<PagedResponse<Product>> listProducts(
    PaginationParams params, {
    String? categoryId,
  });

  /// Get product by ID
  /// Per BR-04: Should throw exception for passive products
  Future<Product> getProductById(String id);

  /// Create new product
  /// Per BR-06: categoryId must reference active category
  Future<Product> createProduct(Product product);

  /// Update existing product
  /// Per BR-02: SKU conflicts should throw exception
  Future<Product> updateProduct(String id, Product product);

  /// Delete product (soft delete via isActive=false)
  Future<void> deleteProduct(String id);
}
