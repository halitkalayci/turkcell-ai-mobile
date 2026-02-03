/// API configuration for backend communication.
/// Base URL points to local development server by default.
///
/// Platform scope: Android, Web
/// Source: AGENTS.md Section 5.6, phase1.md
class ApiConfig {
  /// Base URL for backend API
  /// Default: http://localhost:8080
  static const String baseUrl = 'http://localhost:8080';

  /// HTTP request timeout duration
  static const Duration timeout = Duration(seconds: 30);

  /// Connect timeout for establishing connection
  static const Duration connectTimeout = Duration(seconds: 10);

  /// API version paths
  static const String productsV2Path = '/api/v2/products';
  static const String categoriesV1Path = '/api/v1/categories';

  /// Default pagination values
  static const int defaultPageSize = 20;
  static const int defaultPage = 0;
}
