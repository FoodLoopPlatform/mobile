import 'package:dio/dio.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';

class ApiManager {
  late final Dio _dio;

  ApiManager() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        receiveDataWhenStatusError: true,
      )
    );
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> post(String endPoint, dynamic data, {Map<String, dynamic>? headers}) async {
    return await _dio.post(
      endPoint,
      data: data,
      options: Options(headers: headers),
    );
  }

  Future<Response> get(
    String endPoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(
      endPoint,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete(String endPoint, {Map<String, dynamic>? headers, dynamic body}) async {
    return await _dio.delete(
      endPoint, 
      options: Options(headers: headers), 
      data: body
    );
  }

  Future<Response> patch(String endPoint, {dynamic data, Map<String, dynamic>? headers}) async {
    return await _dio.patch(
      endPoint,
      data: data,
      options: Options(headers: headers),
    );
  }
}
