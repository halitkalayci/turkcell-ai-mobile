import '../../core/contracts/product/paged_product_response.dart';
import '../../core/contracts/product/product_response.dart';

/// Immutable controller state with loading/data/errorCode.
class ProductState {
  final bool loading;
  final String? errorCode;
  final PagedProductResponse? list;
  final ProductResponse? detail;

  const ProductState({
    required this.loading,
    this.errorCode,
    this.list,
    this.detail,
  });

  factory ProductState.initial() => const ProductState(loading: false);

  ProductState copyWith({
    bool? loading,
    String? errorCode,
    PagedProductResponse? list,
    ProductResponse? detail,
    bool clearError = false,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      list: list ?? this.list,
      detail: detail ?? this.detail,
    );
  }
}
