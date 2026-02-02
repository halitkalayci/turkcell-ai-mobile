import 'package:flutter/foundation.dart';

import '../../core/pagination/page_request.dart';
import '../../core/contracts/product/create_product_request.dart';
import '../../core/contracts/product/update_product_request.dart';
import '../../core/contracts/product/paged_product_response.dart';
import '../../core/contracts/product/product_response.dart';
import '../../core/contracts/common/error_response.dart';
import '../../infrastructure/product/product_api_port.dart';
import '../../infrastructure/product/product_api_http_adapter.dart';
import 'product_state.dart';

/// Controller orchestrating Product use-cases; no business rules.
class ProductController extends ChangeNotifier {
  final ProductApiPort _api;
  ProductState _state = ProductState.initial();

  ProductController({ProductApiPort? api}) : _api = api ?? ProductApiHttpAdapter();

  ProductState get state => _state;

  Future<void> list(PageRequest req) async {
    _setLoading(true);
    try {
      final PagedProductResponse data = await _api.listProducts(
        page: req.page,
        size: req.size,
        q: req.q,
        sort: req.sort,
      );
      _state = _state.copyWith(list: data, loading: false, clearError: true);
      notifyListeners();
    } catch (e) {
      final code = _extractCode(e);
      _state = _state.copyWith(loading: false, errorCode: code);
      notifyListeners();
    }
  }

  Future<void> getById(String id) async {
    _setLoading(true);
    try {
      final ProductResponse data = await _api.getProductById(id);
      _state = _state.copyWith(detail: data, loading: false, clearError: true);
      notifyListeners();
    } catch (e) {
      final code = _extractCode(e);
      _state = _state.copyWith(loading: false, errorCode: code);
      notifyListeners();
    }
  }

  Future<void> create(CreateProductRequest body) async {
    _setLoading(true);
    try {
      final ProductResponse created = await _api.createProduct(body);
      _state = _state.copyWith(detail: created, loading: false, clearError: true);
      notifyListeners();
    } catch (e) {
      final code = _extractCode(e);
      _state = _state.copyWith(loading: false, errorCode: code);
      notifyListeners();
    }
  }

  Future<void> update(String id, UpdateProductRequest body) async {
    _setLoading(true);
    try {
      final ProductResponse updated = await _api.updateProduct(id, body);
      _state = _state.copyWith(detail: updated, loading: false, clearError: true);
      notifyListeners();
    } catch (e) {
      final code = _extractCode(e);
      _state = _state.copyWith(loading: false, errorCode: code);
      notifyListeners();
    }
  }

  void _setLoading(bool v) {
    _state = _state.copyWith(loading: v);
    notifyListeners();
  }

  String? _extractCode(Object e) {
    if (e is ApiError) {
      return e.error?.code;
    }
    return null;
  }
}
