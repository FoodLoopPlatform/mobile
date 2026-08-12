import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api_helper/api_constants.dart';
import '../../../../core/api_helper/api_manager.dart';
import '../../../../core/api_helper/api_response.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/utils/app_strings.dart';

class AddProductRemoteDataSource {
  final ApiManager _apiManager;

  AddProductRemoteDataSource(this._apiManager);

  Future<String> addProduct({
    required String categoryId,
    required String title,
    required String description,
    required double originalPrice,
    required double discountedPrice,
    required int quantityAvailable,
    required String expirationDate,
  }) async {
    try {
      final response = await _apiManager.post(
        ApiConstants.storeProductsEndpoint,
        {
          "categoryId": categoryId,
          "title": title,
          "description": description,
          "originalPrice": originalPrice,
          "discountedPrice": discountedPrice,
          "quantityAvailable": quantityAvailable,
          "expirationDate": expirationDate,
        },
      );

      final parsed = ApiResponse<dynamic>.fromJson(response.data, (json) => json);
      if (!parsed.success) throw ServerError(parsed.errorMessage);

      // Assuming the created product ID is in data['id'] or data
      final data = parsed.data;
      if (data is Map<String, dynamic> && data.containsKey('id')) {
        return data['id'].toString();
      } else if (data is String) {
        return data; // sometimes the ID is just returned as string in data
      }
      
      throw ServerError(AppStrings.errorUnexpectedResponse);
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }

  Future<void> uploadProductImage(String productId, File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await _apiManager.post(
        ApiConstants.storeProductImagesEndpoint(productId),
        formData,
      );

      final parsed = ApiResponse<dynamic>.fromJson(response.data, (json) => json);
      if (!parsed.success) throw ServerError(parsed.errorMessage);
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }
}
