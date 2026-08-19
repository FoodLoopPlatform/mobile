import 'package:dio/dio.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/core/utils/app_strings.dart';

class PaymentRepository {
  final ApiManager _apiManager;

  PaymentRepository(this._apiManager);

  Future<String> getCheckoutUrl(String orderId) async {
    try {
      final response = await _apiManager.post(ApiConstants.paymobCheckoutEndpoint(orderId), {});
      final data = response.data as Map<String, dynamic>;
      
      String? extractedUrl;
      
      if (data.containsKey('data')) {
         final nestedData = data['data'];
         if (nestedData is Map<String, dynamic>) {
           extractedUrl = nestedData['url'] as String? ?? nestedData['checkoutUrl'] as String?;
         } else if (nestedData is String) {
           extractedUrl = nestedData;
         }
      } 
      
      if (extractedUrl == null) {
        extractedUrl = data['url'] as String? ?? data['checkoutUrl'] as String?;
      }
      
      if (extractedUrl == null || extractedUrl.isEmpty) {
         throw ServerError('Could not find URL in response: $data');
      }
      
      return extractedUrl;
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }
}
