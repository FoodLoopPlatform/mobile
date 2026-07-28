import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/utils/secure_storage_helper.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/auth_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Future<AuthModel> login(String email, String password) async {
    try {
      final authModel = await _remoteDataSource.login(email, password);
      
      if (authModel.success && authModel.data != null) {
        if (authModel.data!.accessToken != null) {
          await SecureStorageHelper.saveToken(authModel.data!.accessToken!);
        }
        if (authModel.data!.refreshToken != null) {
          await SecureStorageHelper.saveRefreshToken(authModel.data!.refreshToken!);
        }
      } else {
        String msg = authModel.message ?? "Login failed";
        if (authModel.errors != null && authModel.errors!.isNotEmpty) {
          msg = authModel.errors!.join(", ");
        }
        throw ServerError(msg);
      }
      return authModel;
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is ServerError) rethrow;
      throw ServerError("Unknown error occurred");
    }
  }

  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
    String? businessName,
    String? businessCategory,
    File? documentFile,
  }) async {
    try {
      final authModel = await _remoteDataSource.register(
        name,
        email,
        password,
        phoneNumber,
        role,
        businessName,
        businessCategory,
      );

      if (authModel.success && authModel.data != null) {
        if (authModel.data!.accessToken != null) {
          await SecureStorageHelper.saveToken(authModel.data!.accessToken!);
        }
        if (authModel.data!.refreshToken != null) {
          await SecureStorageHelper.saveRefreshToken(authModel.data!.refreshToken!);
        }
        
        // If role is Merchant/Charity and we have a document, upload it using the same email
        if ((role == 'Merchant' || role == 'Charity') && documentFile != null) {
            await _remoteDataSource.uploadDocument(email, "Legal Document", documentFile);
        }
      } else {
        String msg = authModel.message ?? "Registration failed";
        if (authModel.errors != null && authModel.errors!.isNotEmpty) {
          msg = authModel.errors!.join(", ");
        }
        throw ServerError(msg);
      }
      return authModel;
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is ServerError) rethrow;
      throw ServerError("Unknown error occurred");
    }
  }
}
