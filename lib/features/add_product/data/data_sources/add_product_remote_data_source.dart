import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api_helper/api_constants.dart';
import '../../../../core/api_helper/api_manager.dart';
import '../../../../core/api_helper/api_response.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/utils/app_strings.dart';
import '../models/ocr_scan_response.dart';

class AddProductRemoteDataSource {
  final ApiManager _apiManager;

  AddProductRemoteDataSource(this._apiManager);

  /// Uploads an image to the OCR scan endpoint and returns a parsed response.
  Future<OcrScanResponse> scanOCR(File image) async {
    try {
      final fileName = image.path.split('/').last.split('\\').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path, filename: fileName),
      });

      final response = await _apiManager.post(
        ApiConstants.ocrScanEndpoint,
        formData,
      );

      final parsed = ApiResponse<dynamic>.fromJson(response.data, (json) => json);
      if (!parsed.success) throw ServerError(parsed.errorMessage);

      final data = parsed.data;
      if (data is Map<String, dynamic>) {
        return OcrScanResponse.fromJson(data);
      }
      throw ServerError(AppStrings.errorUnexpectedResponse);
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }

  Future<String> addProduct({
    required String categoryId,
    required String title,
    required String description,
    required double originalPrice,
    required double discountedPrice,
    required int quantityAvailable,
    required String expirationDate,
    required double confidenceScore,
    String? extractedText,
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
          "confidenceScore": confidenceScore,
          if (extractedText != null && extractedText.isNotEmpty)
            "extractedText": extractedText,
        },
      );

      final parsed = ApiResponse<dynamic>.fromJson(response.data, (json) => json);
      if (!parsed.success) throw ServerError(parsed.errorMessage);

      final data = parsed.data;
      if (data is Map<String, dynamic> && data.containsKey('id')) {
        return data['id'].toString();
      } else if (data is String) {
        return data;
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
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
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
