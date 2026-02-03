/// Pagination parameters for API requests.
/// Mirrors backend query parameters per docs/openapi/products-v2.yaml.
class PaginationParams {
  /// Page number (0-indexed)
  final int page;

  /// Page size
  final int size;

  /// Search query (optional)
  final String? q;

  /// Sort specification (optional)
  /// Format: "field:direction" (e.g., "createdAt:desc", "name:asc")
  final String? sort;

  /// Additional filters (e.g., categoryId for products)
  final Map<String, String>? filters;

  PaginationParams({
    this.page = 0,
    this.size = 20,
    this.q,
    this.sort,
    this.filters,
  });

  /// Convert to query parameters map for HTTP requests
  Map<String, String> toQueryParams() {
    final params = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
    };

    if (q != null && q!.isNotEmpty) {
      params['q'] = q!;
    }

    if (sort != null && sort!.isNotEmpty) {
      params['sort'] = sort!;
    }

    if (filters != null) {
      params.addAll(filters!);
    }

    return params;
  }

  /// Create copy with modified fields
  PaginationParams copyWith({
    int? page,
    int? size,
    String? q,
    String? sort,
    Map<String, String>? filters,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      size: size ?? this.size,
      q: q ?? this.q,
      sort: sort ?? this.sort,
      filters: filters ?? this.filters,
    );
  }

  /// Create next page params
  PaginationParams nextPage() {
    return copyWith(page: page + 1);
  }

  /// Create previous page params
  PaginationParams previousPage() {
    return copyWith(page: page > 0 ? page - 1 : 0);
  }

  /// Reset to first page
  PaginationParams resetToFirstPage() {
    return copyWith(page: 0);
  }
}
