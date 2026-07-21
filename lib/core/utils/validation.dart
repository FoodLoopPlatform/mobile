import '../utils/app_strings.dart';

class Validation {
  static String? validateRequiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.length < 8) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  static String? Function(String?) validateConfirmPassword(
      String passwordValue) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return AppStrings.fieldRequired;
      }
      if (value != passwordValue) {
        return AppStrings.passwordsDoNotMatch;
      }
      return null;
    };
  }
}
