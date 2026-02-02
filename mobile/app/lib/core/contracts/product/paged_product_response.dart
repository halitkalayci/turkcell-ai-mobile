import 'product_response.dart';

/// PagedProductResponse mirrors backend DTO with items and pagination fields.
class PagedProductResponse {
  final List<ProductResponse> items;
  final int page;
  final int size;
  final int totalItems;
  final int totalPages;

  PagedProductResponse({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  factory PagedProductResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List<dynamic>)
        .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
        .toList();
    return PagedProductResponse(
      items: list,
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'page': page,
      'size': size,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }
}
