/// Generic paged response wrapper.
/// Provides pagination metadata and convenience methods.
class PagedResponse<T> {
  /// List of items in current page
  final List<T> items;

  /// Current page number (0-indexed)
  final int page;

  /// Page size
  final int size;

  /// Total number of items across all pages
  final int totalItems;

  /// Total number of pages
  final int totalPages;

  PagedResponse({
    required this.items,
    required this.page,
    required this.size,
    required this.totalItems,
    required this.totalPages,
  });

  /// Check if there are more pages available
  bool get hasMore => page < totalPages - 1;

  /// Check if this is the first page
  bool get isFirstPage => page == 0;

  /// Check if this is the last page
  bool get isLastPage => page >= totalPages - 1;

  /// Get next page number (or null if last page)
  int? get nextPage => hasMore ? page + 1 : null;

  /// Get previous page number (or null if first page)
  int? get previousPage => page > 0 ? page - 1 : null;

  /// Check if the list is empty
  bool get isEmpty => items.isEmpty;

  /// Check if the list is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get total items count
  int get itemCount => items.length;

  /// Map items to another type
  PagedResponse<R> map<R>(R Function(T) mapper) {
    return PagedResponse<R>(
      items: items.map(mapper).toList(),
      page: page,
      size: size,
      totalItems: totalItems,
      totalPages: totalPages,
    );
  }

  @override
  String toString() {
    return 'PagedResponse(page: $page/$totalPages, items: ${items.length}/$totalItems)';
  }
}
