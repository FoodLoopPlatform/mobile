import '../../../../core/api_helper/api_constants.dart';
import '../../../../core/api_helper/api_manager.dart';
import '../../../../core/api_helper/api_response.dart';
import '../../../../core/errors/errors.dart';
import '../models/address_model.dart';
import '../models/profile_model.dart';

class ProfileRemoteDataSource {
  final ApiManager _apiManager;

  ProfileRemoteDataSource(this._apiManager);

  Future<ProfileModel> getProfile() async {
    final response = await _apiManager.get(ApiConstants.profileEndpoint);
    return _unwrap(response.data, (json) => ProfileModel.fromJson(json));
  }

  /// `PATCH /users/me` — send only the fields that changed.
  Future<ProfileModel?> updateProfile({
    String? name,
    String? profileImage,
  }) async {
    final response = await _apiManager.patch(
      ApiConstants.profileEndpoint,
      data: {
        'name': ?name,
        'profileImage': ?profileImage,
      },
    );
    return _unwrapOptional(response.data, (json) => ProfileModel.fromJson(json));
  }

  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiManager.get(ApiConstants.addressesEndpoint);
    return _unwrap(
      response.data,
      (json) => (json as List)
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<AddressModel?> addAddress(AddressModel address) async {
    final response = await _apiManager.post(
      ApiConstants.addressesEndpoint,
      address.toCreateJson(),
    );
    return _unwrapOptional(response.data, (json) => AddressModel.fromJson(json));
  }

  /// `changes` holds only the keys being edited, e.g. `{'isDefault': true}`.
  Future<AddressModel?> updateAddress(
    String id,
    Map<String, dynamic> changes,
  ) async {
    final response = await _apiManager.patch(
      ApiConstants.addressByIdEndpoint(id),
      data: changes,
    );
    return _unwrapOptional(response.data, (json) => AddressModel.fromJson(json));
  }

  Future<void> deleteAddress(String id) async {
    final response =
        await _apiManager.delete(ApiConstants.addressByIdEndpoint(id));
    _ensureSuccess(response.data);
  }

  // --- Envelope handling -----------------------------------------------

  ApiResponse<T> _parse<T>(dynamic body, T Function(dynamic json) fromJsonT) {
    if (body is! Map<String, dynamic>) {
      throw ServerError('Unexpected response from the server');
    }
    return ApiResponse<T>.fromJson(body, fromJsonT);
  }

  /// For endpoints that must return a payload.
  T _unwrap<T>(dynamic body, T Function(dynamic json) fromJsonT) {
    final parsed = _parse(body, fromJsonT);
    if (!parsed.success || parsed.data == null) {
      throw ServerError(parsed.errorMessage);
    }
    return parsed.data as T;
  }

  /// For writes that may answer with an empty `data` — the caller keeps its
  /// own updated copy in that case.
  T? _unwrapOptional<T>(dynamic body, T Function(dynamic json) fromJsonT) {
    final parsed = _parse(body, fromJsonT);
    if (!parsed.success) {
      throw ServerError(parsed.errorMessage);
    }
    return parsed.data;
  }

  void _ensureSuccess(dynamic body) {
    final parsed = _parse<dynamic>(body, (json) => json);
    if (!parsed.success) {
      throw ServerError(parsed.errorMessage);
    }
  }
}
