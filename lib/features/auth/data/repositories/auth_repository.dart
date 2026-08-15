import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/utils/app_strings.dart';
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
        if (authModel.data!.user?.status == "PendingVerification") {
          throw ServerError(AppStrings.errorAccountNotVerified);
        }
        if (authModel.data!.accessToken != null &&
            authModel.data!.accessToken != "") {
          await SecureStorageHelper.saveToken(authModel.data!.accessToken!);
        }
        if (authModel.data!.refreshToken != null &&
            authModel.data!.refreshToken != "") {
          await SecureStorageHelper.saveRefreshToken(
            authModel.data!.refreshToken!,
          );
        } else {
          throw ServerError(AppStrings.errorSomethingWentWrong);
        }
        // Persist the user's first role for UI role-gating (e.g. Merchant nav)
        final roles = authModel.data!.user?.roles;
        if (roles != null && roles.isNotEmpty) {
          await SecureStorageHelper.saveUserRole(roles.first);
        }
      } else {
        String msg = authModel.message ?? AppStrings.errorLoginFailed;
        if (authModel.errors != null && authModel.errors!.isNotEmpty) {
          msg = authModel.errors!.join(", ");
        }
        throw ServerError(msg);
      }
      return authModel;
    } on DioException catch (e) {
      print(e);
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is ServerError) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }

  /// Revokes the session server-side, then wipes local tokens.
  ///
  /// The local wipe happens even when the network call fails — otherwise a
  /// dead connection would leave the user stuck in a logged-in state with no
  /// way out.
  Future<void> logout() async {
    try {
      final refreshToken = await SecureStorageHelper.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _remoteDataSource.logout(refreshToken);
      }
    } catch (_) {
      // Best-effort: revoking failed, but the user still leaves the session.
    } finally {
      await SecureStorageHelper.clearTokens();
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
    Map<String, File?> documentFiles = const {},
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
          await SecureStorageHelper.saveRefreshToken(
            authModel.data!.refreshToken!,
          );
        }

        // Upload each legal document individually using its title as the Type.
        if (role == 'Merchant' || role == 'Charity') {
          for (final entry in documentFiles.entries) {
            final file = entry.value;
            if (file != null) {
              await _remoteDataSource.uploadDocument(
                email,
                entry.key,
                file,
                role,
              );
            }
          }
        }
      } else {
        String msg = authModel.message ?? AppStrings.errorRegistrationFailed;
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
      print("Error: $e");
      throw ServerError(AppStrings.errorUnknown);
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      throw ServerError(AppStrings.errorUnknown);
    }
  }
}
