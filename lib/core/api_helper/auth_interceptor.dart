import 'package:dio/dio.dart';
import '../../main.dart';
import '../routes_manager/routes_names.dart';
import '../api_helper/api_constants.dart';
import '../utils/secure_storage_helper.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorageHelper.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      if (refreshToken != null) {
        try {
          var dio = Dio();
          var response = await dio.post(
            '${ApiConstants.baseUrl}${ApiConstants.refreshEndpoint}',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 && response.data['success'] == true) {
             final newAccessToken = response.data['data']['accessToken'];
             final newRefreshToken = response.data['data']['refreshToken'];
             
             await SecureStorageHelper.saveTokens(newAccessToken, newRefreshToken);
             
             err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
             final retryResponse = await dio.fetch(err.requestOptions);
             return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Fall through to clear tokens
        }
      }
      
      await SecureStorageHelper.clearTokens();
      navigatorKey.currentState?.pushNamedAndRemoveUntil(RoutesNames.loginView, (route) => false);
    }
    return super.onError(err, handler);
  }
}
