import '../../core/contracts/common/error_response.dart';

/// Basic HTTP request wrapper.
class HttpRequest {
  final String path;
  final Map<String, String>? headers;
  final Map<String, String>? query;
  final Object? body;

  const HttpRequest({
    required this.path,
    this.headers,
    this.query,
    this.body,
  });
}

/// Basic HTTP response wrapper.
class HttpResponse {
  final int statusCode;
  final Map<String, String>? headers;
  final Object? body;
  final ErrorResponse? error;

  const HttpResponse({
    required this.statusCode,
    this.headers,
    this.body,
    this.error,
  });

  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
