import 'package:foodloop/core/utils/app_strings.dart';

/// Every FoodLoop endpoint answers with the same envelope:
/// `{ "success": bool, "data": ..., "message": string, "errors": [...] }`
/// [T] is whatever sits inside `data` for that particular endpoint.
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final List<dynamic>? errors;

  ApiResponse({required this.success, this.data, this.message, this.errors});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
      errors: json['errors'],
    );
  }

  String get errorMessage {
    if (errors != null && errors!.isNotEmpty) return errors!.join(', ');
    return message ?? AppStrings.errorSomethingWentWrong;
  }
}
