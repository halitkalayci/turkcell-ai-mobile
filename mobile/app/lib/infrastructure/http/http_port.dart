import 'http_models.dart';

/// Minimal HTTP client abstraction using approved `http` package for adapters.
/// This is an interface; concrete adapter will follow the OpenAPI spec and Env.baseUrl.
abstract class HttpPort {
  Future<HttpResponse> get(String path, {
    Map<String, String>? headers,
    Map<String, String>? query,
  });

  Future<HttpResponse> post(String path, {
    Map<String, String>? headers,
    Object? body,
  });

  Future<HttpResponse> put(String path, {
    Map<String, String>? headers,
    Object? body,
  });
}
