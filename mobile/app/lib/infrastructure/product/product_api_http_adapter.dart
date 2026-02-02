import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/contracts/product/create_product_request.dart';
import '../../core/contracts/product/update_product_request.dart';
import '../../core/contracts/product/paged_product_response.dart';
import '../../core/contracts/product/product_response.dart';
import '../../core/contracts/common/error_response.dart';
import '../../config/env.dart';
import 'product_api_port.dart';

/// HTTP adapter implementing ProductApiPort using approved `http` client.
/// Strictly follows endpoints from docs/openapi/products-v1.yaml.
class ProductApiHttpAdapter implements ProductApiPort {
  final http.Client _client;
  final String _base; // e.g., http://localhost:8080/api/v1

  ProductApiHttpAdapter({http.Client? client})
      : _client = client ?? http.Client(),
        _base = '${Env.baseUrl}/api/v1';

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('$_base$path').replace(queryParameters: query);

  Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  @override
  Future<PagedProductResponse> listProducts({
    required int page,
    required int size,
    String? q,
    String? sort,
  }) async {
    final query = <String, String>{
      'page': page.toString(),
      'size': size.toString(),
      if (q != null && q.isNotEmpty) 'q': q,
      if (sort != null && sort.isNotEmpty) 'sort': sort,
    };
    final response = await _client.get(_uri('/products', query), headers: _jsonHeaders);
    return _handlePaged(response);
  }

  @override
  Future<ProductResponse> getProductById(String id) async {
    final response = await _client.get(_uri('/products/$id'), headers: _jsonHeaders);
    return _handleProduct(response, expected: 200);
  }

  @override
  Future<ProductResponse> createProduct(CreateProductRequest body) async {
    final response = await _client.post(
      _uri('/products'),
      headers: _jsonHeaders,
      body: jsonEncode(body.toJson()),
    );
    return _handleProduct(response, expected: 201);
  }

  @override
  Future<ProductResponse> updateProduct(String id, UpdateProductRequest body) async {
    final response = await _client.put(
      _uri('/products/$id'),
      headers: _jsonHeaders,
      body: jsonEncode(body.toJson()),
    );
    return _handleProduct(response, expected: 200);
  }

  PagedProductResponse _handlePaged(http.Response res) {
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return PagedProductResponse.fromJson(map);
    }
    _throwApiError(res);
    throw StateError('Unreachable');
  }

  ProductResponse _handleProduct(http.Response res, {required int expected}) {
    if (res.statusCode == expected) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      return ProductResponse.fromJson(map);
    }
    _throwApiError(res);
    throw StateError('Unreachable');
  }

  Never _throwApiError(http.Response res) {
    try {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final err = ErrorResponse.fromJson(map);
      throw ApiError(statusCode: res.statusCode, error: err);
    } catch (_) {
      throw ApiError(statusCode: res.statusCode);
    }
  }
}

/// Lightweight API error carrying ErrorResponse when available.
class ApiError implements Exception {
  final int statusCode;
  final ErrorResponse? error;
  ApiError({required this.statusCode, this.error});

  @override
  String toString() => 'ApiError(status=$statusCode, code=${error?.code})';
}
