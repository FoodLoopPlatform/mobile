import 'package:dio/dio.dart';
import '../../../../core/errors/errors.dart';
import '../../../../core/utils/app_strings.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/address_model.dart';
import '../models/profile_model.dart';
import '../models/wallet_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  ProfileModel? _cachedProfile;
  List<AddressModel>? _cachedAddresses;
  WalletModel? _cachedWallet;

  Future<ProfileModel> getProfile({bool forceRefresh = false}) {
    return _guard(() async {
      if (_cachedProfile != null && !forceRefresh) return _cachedProfile!;
      _cachedProfile = await _remoteDataSource.getProfile();
      return _cachedProfile!;
    });
  }

  Future<ProfileModel> updateProfile({
    String? name,
    String? profileImage,
  }) {
    return _guard(() async {
      final updated = await _remoteDataSource.updateProfile(
        name: name,
        profileImage: profileImage,
      );
      // The API may answer with an empty body; fall back to a local copy.
      _cachedProfile = updated ??
          _cachedProfile?.copyWith(fullName: name, profileImage: profileImage);
      _cachedProfile ??= await _remoteDataSource.getProfile();
      return _cachedProfile!;
    });
  }

  Future<List<AddressModel>> getAddresses({bool forceRefresh = false}) {
    return _guard(() async {
      if (_cachedAddresses != null && !forceRefresh) return _cachedAddresses!;
      _cachedAddresses = await _remoteDataSource.getAddresses();
      return _cachedAddresses!;
    });
  }

  Future<WalletModel> getWalletBalance({bool forceRefresh = false}) {
    return _guard(() async {
      if (_cachedWallet != null && !forceRefresh) return _cachedWallet!;
      _cachedWallet = await _remoteDataSource.getWalletBalance();
      return _cachedWallet!;
    });
  }

  Future<List<AddressModel>> addAddress(AddressModel address) {
    return _guard(() async {
      await _remoteDataSource.addAddress(address);
      // The new id (and any server-side default reshuffle) only arrives on refetch.
      _cachedAddresses = await _remoteDataSource.getAddresses();
      return _cachedAddresses!;
    });
  }

  Future<List<AddressModel>> updateAddress(
    String id,
    Map<String, dynamic> changes,
  ) {
    return _guard(() async {
      await _remoteDataSource.updateAddress(id, changes);
      _cachedAddresses = await _remoteDataSource.getAddresses();
      return _cachedAddresses!;
    });
  }

  Future<List<AddressModel>> deleteAddress(String id) {
    return _guard(() async {
      await _remoteDataSource.deleteAddress(id);
      _cachedAddresses = await _remoteDataSource.getAddresses();
      return _cachedAddresses!;
    });
  }

  void clearCache() {
    _cachedProfile = null;
    _cachedAddresses = null;
    _cachedWallet = null;
  }

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError(AppStrings.errorUnknown);
    }
  }
}
