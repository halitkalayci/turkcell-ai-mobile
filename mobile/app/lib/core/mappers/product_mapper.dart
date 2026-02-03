import '../contracts/product/product_v2_response.dart';
import '../contracts/product/create_product_v2_request.dart';
import '../contracts/product/update_product_v2_request.dart';
import '../../domain/entities/product.dart';

/// Mapper for Product DTO ↔ Domain Entity conversions.
/// Per AGENTS.md Section 5.5: Clean separation between layers.
class ProductMapper {
  /// Convert ProductV2Response (DTO) to Product (Domain Entity)
  static Product toDomain(ProductV2Response response) {
    return Product(
      id: response.id,
      name: response.name,
      sku: response.sku,
      description: response.description,
      price: response.price,
      currency: response.currency,
      isActive: response.isActive,
      categoryId: response.categoryId,
      imageUrl: response.imageUrl,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  /// Convert Product (Domain Entity) to CreateProductV2Request (DTO)
  static CreateProductV2Request toCreateRequest(Product product) {
    return CreateProductV2Request(
      name: product.name,
      sku: product.sku,
      description: product.description,
      price: product.price,
      currency: product.currency,
      isActive: product.isActive,
      categoryId: product.categoryId,
      imageUrl: product.imageUrl,
    );
  }

  /// Convert Product (Domain Entity) to UpdateProductV2Request (DTO)
  static UpdateProductV2Request toUpdateRequest(Product product) {
    return UpdateProductV2Request(
      name: product.name,
      sku: product.sku,
      description: product.description,
      price: product.price,
      currency: product.currency,
      isActive: product.isActive,
      categoryId: product.categoryId,
      imageUrl: product.imageUrl,
    );
  }

  /// Convert list of ProductV2Response to list of Product entities
  static List<Product> toDomainList(List<ProductV2Response> responses) {
    return responses.map((response) => toDomain(response)).toList();
  }
}
