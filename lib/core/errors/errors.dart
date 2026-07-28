import 'package:dio/dio.dart';

abstract class Errors {
  final String errMessage;
  Errors(this.errMessage);
}

class ServerError extends Errors {
  ServerError(super.errMessage);

  factory ServerError.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerError("انتهت مهلة الاتصال بالخادم");
      case DioExceptionType.sendTimeout:
        return ServerError("انتهت مهلة إرسال الطلب");
      case DioExceptionType.receiveTimeout:
        return ServerError("انتهت مهلة استقبال الرد من الخادم");
      case DioExceptionType.badCertificate:
        return ServerError("الشهادة غير صالحة");
      case DioExceptionType.badResponse:
        return ServerError.fromResponse(dioError.response?.statusCode ?? 500, dioError.response?.data);
      case DioExceptionType.cancel:
        return ServerError("تم إلغاء الطلب");
      case DioExceptionType.connectionError:
        return ServerError("خطأ في الاتصال بالشبكة");
      case DioExceptionType.unknown:
        if (dioError.message != null && dioError.message!.contains("SocketException")) {
          return ServerError("لا يوجد اتصال بالإنترنت");
        } else {
          return ServerError("حدث خطأ غير معروف، يرجى المحاولة مرة أخرى");
        }
      default:
        return ServerError("حدث خطأ غير متوقع");
    }
  }

  factory ServerError.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      String msg = "طلب غير صالح أو غير مصرح به";
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
      return ServerError("المورد المطلوب غير موجود");
    } else if (statusCode == 500) {
      return ServerError("خطأ داخلي في الخادم");
    } else {
      return ServerError("حدث خطأ غير معروف ($statusCode)");
    }
  }
}
