import 'product_v2_response.dart';

/// Paged Product Response V2 - mirrors backend PagedProductResponseV2
/// Source: docs/openapi/products-v2.yaml
/// Used for paginated product listings per phase1.md Section 7
class PagedProductV2Response {
  /// List of products in current page
  final List<ProductV2Response> items;

  /// Current page number (0-indexed)
  final int page;

  /// Page size
  final int size;

  /// Total number of items across all pages
  final int totalItems;

  /// Total number of pages
  final int totalPages;

  PagedProductV2Response({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  /// Create from JSON
  factory PagedProductV2Response.fromJson(Map<String, dynamic> json) {
    return PagedProductV2Response(
      items: (json['items'] as List<dynamic>)
          .map((item) => ProductV2Response.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: json['page'] as int,
      size: json['size'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'page': page,
      'size': size,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }

  /// Check if there are more pages
  bool get hasMore => page < totalPages - 1;

  /// Check if this is the first page
  bool get isFirstPage => page == 0;

  /// Check if this is the last page
  bool get isLastPage => page >= totalPages - 1;
}
