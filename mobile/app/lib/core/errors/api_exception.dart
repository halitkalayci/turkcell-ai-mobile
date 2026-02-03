import '../contracts/error_response.dart';

/// Base exception for API-related errors.
/// Wraps ErrorResponse from backend per AGENTS.md Section 9.
class ApiException implements Exception {
  /// HTTP status code
  final int statusCode;

  /// Error response from backend
  final ErrorResponse errorResponse;

  ApiException({
    required this.statusCode,
    required this.errorResponse,
  });

  /// Create from HTTP response
  factory ApiException.fromResponse(int statusCode, Map<String, dynamic> json) {
    return ApiException(
      statusCode: statusCode,
      errorResponse: ErrorResponse.fromJson(json),
    );
  }

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, error: ${errorResponse.toString()})';
  }

  /// Check if this is a conflict error (409)
  bool get isConflict => statusCode == 409 || errorResponse.isConflict;

  /// Check if this is a validation error (400)
  bool get isValidationError => statusCode == 400 || errorResponse.isValidationError;

  /// Check if this is a not found error (404)
  bool get isNotFound => statusCode == 404 || errorResponse.isNotFound;

  /// Check if this is an unauthorized error (401)
  bool get isUnauthorized => statusCode == 401;

  /// Check if this is a forbidden error (403)
  bool get isForbidden => statusCode == 403;

  /// Check if this is a server error (5xx)
  bool get isServerError => statusCode >= 500 && statusCode < 600;
}

/// Network-related exception (no internet, timeout, etc.)
class NetworkException implements Exception {
  final String message;
  final Exception? originalException;

  NetworkException(this.message, [this.originalException]);

  @override
  String toString() {
    return 'NetworkException: $message${originalException != null ? ' (${originalException.toString()})' : ''}';
  }
}

/// Validation exception for client-side validation
class ValidationException implements Exception {
  final String field;
  final String message;

  ValidationException(this.field, this.message);

  @override
  String toString() {
    return 'ValidationException: $field - $message';
  }
}

/// Unknown exception wrapper
class UnknownException implements Exception {
  final String message;
  final dynamic originalException;

  UnknownException(this.message, [this.originalException]);

  @override
  String toString() {
    return 'UnknownException: $message${originalException != null ? ' (${originalException.toString()})' : ''}';
  }
}
