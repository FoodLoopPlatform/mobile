import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/api_helper/api_constants.dart';
import '../../../../core/api_helper/api_manager.dart';
import '../models/auth_model.dart';

class AuthRemoteDataSource {
  final ApiManager _apiManager;

  AuthRemoteDataSource(this._apiManager);

  Future<AuthModel> login(String email, String password) async {
    final response = await _apiManager.post(ApiConstants.loginEndpoint, {
      "email": email,
      "password": password,
    });
    return AuthModel.fromJson(response.data);
  }

  Future<AuthModel> register(
    String name,
    String email,
    String password,
    String phoneNumber,
    String role,
    String? businessName,
    String? businessCategory,
  ) async {
    final response = await _apiManager.post(ApiConstants.registerEndpoint, {
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "role": role,
      "businessName": ?businessName,
      "businessCategory": ?businessCategory,
    });
    return AuthModel.fromJson(response.data);
  }

  /// Revokes [refreshToken] server-side so it can't be used again.
  Future<void> logout(String refreshToken) async {
    await _apiManager.post(ApiConstants.logoutEndpoint, {
      "refreshToken": refreshToken,
    });
  }

  Future<void> uploadDocument(String email, String type, File file) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "Email": email,
      "Type": type,
      "File": await MultipartFile.fromFile(file.path, filename: fileName),
    });

    await _apiManager.post(ApiConstants.uploadDocumentsEndpoint, formData);
  }
}
