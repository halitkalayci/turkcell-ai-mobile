import 'category_response.dart';

/// Paged Category Response - mirrors backend PagedCategoryResponse
/// Source: docs/openapi/categories-v1.yaml
/// Used for paginated category listings per phase1.md Section 7
class PagedCategoryResponse {
  /// List of categories in current page
  final List<CategoryResponse> items;

  /// Current page number (0-indexed)
  final int page;

  /// Page size
  final int size;

  /// Total number of items across all pages
  final int totalItems;

  /// Total number of pages
  final int totalPages;

  PagedCategoryResponse({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  /// Create from JSON
  factory PagedCategoryResponse.fromJson(Map<String, dynamic> json) {
    return PagedCategoryResponse(
      items: (json['items'] as List<dynamic>)
          .map((item) => CategoryResponse.fromJson(item as Map<String, dynamic>))
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
