import 'package:dio/dio.dart';
import 'package:foodloop/core/utils/app_strings.dart';

abstract class Errors {
  final String errMessage;
  Errors(this.errMessage);
}

class ServerError extends Errors {
  ServerError(super.errMessage);

  factory ServerError.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerError(AppStrings.errorConnectionTimeout);
      case DioExceptionType.sendTimeout:
        return ServerError(AppStrings.errorSendTimeout);
      case DioExceptionType.receiveTimeout:
        return ServerError(AppStrings.errorReceiveTimeout);
      case DioExceptionType.badCertificate:
        return ServerError(AppStrings.errorBadCertificate);
      case DioExceptionType.badResponse:
        return ServerError.fromResponse(dioError.response?.statusCode ?? 500, dioError.response?.data);
      case DioExceptionType.cancel:
        return ServerError(AppStrings.errorRequestCancelled);
      case DioExceptionType.connectionError:
        return ServerError(AppStrings.errorConnectionError);
      case DioExceptionType.unknown:
        if (dioError.message != null && dioError.message!.contains("SocketException")) {
          return ServerError(AppStrings.errorNoInternet);
        } else {
          return ServerError(AppStrings.errorUnknown);
        }
      default:
        return ServerError(AppStrings.errorUnexpected);
    }
  }

  factory ServerError.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      String msg = AppStrings.errorBadRequest;
      if (response is Map<String, dynamic>) {
        if (response.containsKey("message") && response["message"] != null) {
          msg = response["message"];
        } else if (response.containsKey("error")) {
           if (response["error"] is String) {
             msg = response["error"];
           } else if (response["error"] is Map && response["error"].containsKey("message")) {
             msg = response["error"]["message"];
           }
        }
      } else if (response is String) {
        msg = response;
      }
      return ServerError(msg);
    } else if (statusCode == 404) {
      return ServerError(AppStrings.errorNotFound);
    } else if (statusCode == 500) {
      return ServerError(AppStrings.errorInternalServer);
    } else {
      return ServerError("${AppStrings.errorUnknown} ($statusCode)");
    }
  }
}
