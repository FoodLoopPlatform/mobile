import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String language;
  final String status;
  final List<String> roles;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.language,
    required this.status,
    required this.roles,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      // register sends `name`, login returns `fullName` — accept either.
      fullName: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'],
      language: json['preferredLanguage'] ?? json['language'] ?? 'en',
      status: json['status'] ?? '',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : const [],
    );
  }

  ProfileModel copyWith({
    String? fullName,
    String? profileImage,
  }) {
    return ProfileModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phoneNumber: phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      language: language,
      status: status,
      roles: roles,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        profileImage,
        language,
        status,
        roles,
      ];
}
