import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import '../../core/errors/api_exception.dart';

/// Base HTTP client for making API requests.
/// Handles common concerns: base URL, headers, error handling, timeout.
/// Per AGENTS.md Section 5.4: Infrastructure layer, no business rules.
class HttpClient {
  final http.Client _client;
  final String _baseUrl;

  HttpClient({
    http.Client? client,
    String? baseUrl,
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  /// GET request
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParams);
    
    try {
      final response = await _client
          .get(uri, headers: _buildHeaders(headers))
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, null);

    try {
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, null);

    try {
      final response = await _client
          .put(
            uri,
            headers: _buildHeaders(headers),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, null);

    try {
      final response = await _client
          .delete(uri, headers: _buildHeaders(headers))
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Build full URI with base URL and query parameters
  Uri _buildUri(String path, Map<String, String>? queryParams) {
    final url = '$_baseUrl$path';
    return Uri.parse(url).replace(queryParameters: queryParams);
  }

  /// Build headers with default Content-Type
  Map<String, String> _buildHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Handle HTTP response and throw appropriate exceptions
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {};
      }
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    // Error response
    if (response.body.isNotEmpty) {
      try {
        final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
        throw ApiException.fromResponse(statusCode, errorJson);
      } catch (e) {
        if (e is ApiException) rethrow;
        // If error body is not valid JSON, create generic error
        throw ApiException.fromResponse(statusCode, {
          'code': 'INTERNAL_ERROR',
          'message': 'HTTP $statusCode: ${response.reasonPhrase}',
          'details': [],
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    }

    throw ApiException.fromResponse(statusCode, {
      'code': 'INTERNAL_ERROR',
      'message': 'HTTP $statusCode: ${response.reasonPhrase}',
      'details': [],
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Handle errors during HTTP request
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }

    if (error is http.ClientException) {
      return NetworkException('Network error: ${error.message}', error);
    }

    return UnknownException('Unknown error occurred', error);
  }

  /// Close the client
  void close() {
    _client.close();
  }
}
