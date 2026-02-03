/// Error Response - mirrors backend ErrorResponse
/// Source: docs/openapi/products-v2.yaml, categories-v1.yaml
/// Standardized error format per AGENTS.md Section 9
class ErrorResponse {
  /// External API error code (CONFLICT, VALIDATION_ERROR, NOT_FOUND, etc.)
  final String code;

  /// Human-readable error message
  final String message;

  /// Domain-specific error details (e.g., SKU_ALREADY_EXISTS, PRODUCT_NAME_ALREADY_EXISTS)
  final List<String> details;

  /// Request correlation ID for tracing
  final String? correlationId;

  /// Error timestamp
  final DateTime timestamp;

  ErrorResponse({
    required this.code,
    required this.message,
    required this.details,
    this.correlationId,
    required this.timestamp,
  });

  /// Create from JSON
  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      details: (json['details'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      correlationId: json['correlationId'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'details': details,
      if (correlationId != null) 'correlationId': correlationId,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Check if error is a conflict error
  bool get isConflict => code == 'CONFLICT';

  /// Check if error is a validation error
  bool get isValidationError => code == 'VALIDATION_ERROR';

  /// Check if error is a not found error
  bool get isNotFound => code == 'NOT_FOUND';

  @override
  String toString() {
    return 'ErrorResponse(code: $code, message: $message, details: $details)';
  }
}
