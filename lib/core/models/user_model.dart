import 'package:foodloop/core/enums/account_type_enum.dart';

class UserModel {
  String? fullName;
  String? email;
  String? token;
  AccountType? accountType;
  bool? isEmailVerified;
  String? id;

  UserModel._();
  static final UserModel _singletonInstance = UserModel._();
  static UserModel get instance => _singletonInstance;

  void setFromJson(Map<String, dynamic> json) {
    id = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    token = json['token'];
    isEmailVerified = json['isEmailVerified'] ?? false;
    accountType = AccountType.fromString(json['accountType']);
  }

  void clear() {
    fullName = null;
    email = null;
    token = null;
    accountType = null;
    isEmailVerified = null;
    id = null;
  }
}
