import 'package:equatable/equatable.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/profile/data/models/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  final List<AddressModel> addresses;

  /// True while a write is in flight — the screen stays visible, so show a
  /// small inline indicator rather than replacing the whole body.
  final bool isUpdating;

  /// Set when a write failed; the shown data has already been rolled back.
  final String? actionError;

  const ProfileLoaded({
    required this.profile,
    required this.addresses,
    this.isUpdating = false,
    this.actionError,
  });

  ProfileLoaded copyWith({
    ProfileModel? profile,
    List<AddressModel>? addresses,
    bool? isUpdating,
    String? actionError,
    bool clearActionError = false,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      addresses: addresses ?? this.addresses,
      isUpdating: isUpdating ?? this.isUpdating,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [profile, addresses, isUpdating, actionError];
}

/// Only for a failed initial load — write failures surface through
/// [ProfileLoaded.actionError] so the screen keeps its data.
class ProfileFail extends ProfileState {
  final String message;
  const ProfileFail({required this.message});

  @override
  List<Object?> get props => [message];
}
