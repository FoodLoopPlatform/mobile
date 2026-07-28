import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/profile/data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileInitial());

  Future<void> loadProfile({bool forceRefresh = false}) async {
    emit(const ProfileLoading());
    try {
      final profile =
          await _profileRepository.getProfile(forceRefresh: forceRefresh);
      final addresses =
          await _profileRepository.getAddresses(forceRefresh: forceRefresh);
      emit(ProfileLoaded(profile: profile, addresses: addresses));
    } on Errors catch (e) {
      emit(ProfileFail(message: e.errMessage));
    } catch (e) {
      emit(ProfileFail(message: e.toString()));
    }
  }

  Future<void> updateProfile({String? name, String? profileImage}) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    // Show the new value immediately; `current` still holds the old one, so a
    // failure rolls back simply by re-emitting it.
    final optimistic = current.profile.copyWith(
      fullName: name,
      profileImage: profileImage,
    );
    emit(current.copyWith(
      profile: optimistic,
      isUpdating: true,
      clearActionError: true,
    ));

    await _write(current, () async {
      final saved = await _profileRepository.updateProfile(
        name: name,
        profileImage: profileImage,
      );
      return current.copyWith(profile: saved, isUpdating: false);
    });
  }

  Future<void> addAddress(AddressModel address) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    emit(current.copyWith(isUpdating: true, clearActionError: true));

    await _write(current, () async {
      final addresses = await _profileRepository.addAddress(address);
      return current.copyWith(addresses: addresses, isUpdating: false);
    });
  }

  Future<void> updateAddress(String id, Map<String, dynamic> changes) async {
    final current = state;
    if (current is! ProfileLoaded) return;
    emit(current.copyWith(isUpdating: true, clearActionError: true));

    await _write(current, () async {
      final addresses = await _profileRepository.updateAddress(id, changes);
      return current.copyWith(addresses: addresses, isUpdating: false);
    });
  }

  Future<void> setDefaultAddress(String id) {
    return updateAddress(id, {'isDefault': true});
  }

  Future<void> deleteAddress(String id) async {
    final current = state;
    if (current is! ProfileLoaded) return;

    // Drop it from the list right away so the tile disappears on tap.
    final optimistic =
        current.addresses.where((address) => address.id != id).toList();
    emit(current.copyWith(
      addresses: optimistic,
      isUpdating: true,
      clearActionError: true,
    ));

    await _write(current, () async {
      final addresses = await _profileRepository.deleteAddress(id);
      return current.copyWith(addresses: addresses, isUpdating: false);
    });
  }

  /// Runs a write and, if it throws, restores [previous] with the error
  /// attached — the user never sees a half-applied change.
  Future<void> _write(
    ProfileLoaded previous,
    Future<ProfileLoaded> Function() action,
  ) async {
    try {
      emit(await action());
    } on Errors catch (e) {
      emit(previous.copyWith(isUpdating: false, actionError: e.errMessage));
    } catch (e) {
      emit(previous.copyWith(isUpdating: false, actionError: e.toString()));
    }
  }
}
