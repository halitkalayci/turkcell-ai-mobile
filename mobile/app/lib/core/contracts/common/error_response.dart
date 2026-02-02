/// ErrorResponse mirrors backend DTO and OpenAPI schema.
class ErrorResponse {
  final String? code;
  final String? message;
  final List<String>? details;
  final String? correlationId;
  final DateTime? timestamp;

  ErrorResponse({
    this.code,
    this.message,
    this.details,
    this.correlationId,
    this.timestamp,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['code'] as String?,
      message: json['message'] as String?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      correlationId: json['correlationId'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'details': details,
      'correlationId': correlationId,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
