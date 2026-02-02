/// Helper for building query params aligned with products-v1 contract.
class PageRequest {
  final int page;
  final int size;
  final String? q;
  final String? sort;

  const PageRequest({
    required this.page,
    required this.size,
    this.q,
    this.sort,
  });

  Map<String, String> toQueryMap() {
    final map = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
    };
    final query = q;
    final order = sort;
    if (query != null && query.isNotEmpty) {
      map['q'] = query;
    }
    if (order != null && order.isNotEmpty) {
      map['sort'] = order;
    }
    return map;
  }
}
