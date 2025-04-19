class ApiError {
  final String message;
  final Map<String, List<String>>? fieldErrors;
  final int? statusCode;
  final bool? success;
  final String? version;
  final String? appName;

  ApiError({
    required this.message,
    this.fieldErrors,
    this.statusCode,
    this.success,
    this.version,
    this.appName,
  });

  factory ApiError.fromJson(Map<String, dynamic> json, {int? statusCode}) {
    // Handle 422 validation errors format
    if (json.containsKey('errors') && json['errors'] is Map) {
      final Map<String, List<String>> fieldErrors = {};
      (json['errors'] as Map).forEach((key, value) {
        if (value is List) {
          fieldErrors[key] = List<String>.from(value.map((e) => e.toString()));
        } else if (value is String) {
          fieldErrors[key] = [value];
        }
      });

      return ApiError(
        message: json['message'] ?? 'Validation error',
        fieldErrors: fieldErrors,
        statusCode: statusCode ?? 422,
        success: false,
      );
    }

    // Handle API key/password error
    if (json.containsKey('status') && json.containsKey('message')) {
      return ApiError(
        message: json['message'] ?? 'Authentication error',
        statusCode: statusCode,
        success: json['status'],
      );
    }

    // Handle subdomain error
    if (json.containsKey('code') && json.containsKey('message')) {
      return ApiError(
        message: json['message'] ?? 'Not found',
        statusCode: json['code'] ?? statusCode,
        success: json['success'],
      );
    }

    // Handle version error
    if (json.containsKey('The Version') && json.containsKey('The App')) {
      return ApiError(
        message: 'Invalid accept header',
        version: json['The Version'],
        appName: json['The App'],
        statusCode: statusCode,
      );
    }

    // Default case for any other error format
    return ApiError(
      message: json['message'] ?? 'Unknown error',
      statusCode: statusCode,
    );
  }

  String getUserFriendlyMessage() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      // Join all field error messages
      final List<String> allErrors = [];
      fieldErrors!.forEach((field, errors) {
        for (final error in errors) {
          allErrors.add(error);
        }
      });
      return allErrors.join('\n');
    }
    return message;
  }

  List<String> getErrorsList() {
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      final List<String> allErrors = [];
      fieldErrors!.forEach((field, errors) {
        for (final error in errors) {
          allErrors.add(error);
        }
      });
      return allErrors;
    }
    return [message];
  }
}
