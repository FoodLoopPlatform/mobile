class AuthModel {
  final bool success;
  final AuthData? data;
  final String? message;
  final List<dynamic>? errors;

  AuthModel({required this.success, this.data, this.message, this.errors});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
      message: json['message'],
      errors: json['errors'],
    );
  }
}

class AuthData {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final String? accessTokenExpiresAt;

  AuthData({this.user, this.accessToken, this.refreshToken, this.accessTokenExpiresAt});

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      accessTokenExpiresAt: json['accessTokenExpiresAt'],
    );
  }
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? profileImage;
  final String language;
  final String status;
  final List<String> roles;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    required this.language,
    required this.status,
    required this.roles,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'],
      language: json['language'] ?? 'en',
      status: json['status'] ?? 'Active',
      roles: json['roles'] != null ? List<String>.from(json['roles']) : [],
    );
  }
}
