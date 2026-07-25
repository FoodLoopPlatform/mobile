import 'package:foodloop/core/utils/app_strings.dart';

/// Strength tiers for the reset-password meter, with the number of segments
/// each tier fills. Colors are mapped in the presentation layer.
enum PasswordStrength {
  none,
  weak,
  medium,
  strong;

  static PasswordStrength fromPassword(String value) {
    if (value.isEmpty) return PasswordStrength.none;
    if (value.length < 6) return PasswordStrength.weak;
    if (value.length < 10) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  String get label {
    switch (this) {
      case PasswordStrength.none:
        return AppStrings.passwordStrengthEmpty;
      case PasswordStrength.weak:
        return AppStrings.passwordStrengthWeak;
      case PasswordStrength.medium:
        return AppStrings.passwordStrengthMedium;
      case PasswordStrength.strong:
        return AppStrings.passwordStrengthStrong;
    }
  }

  int get filledBars {
    switch (this) {
      case PasswordStrength.none:
        return 0;
      case PasswordStrength.weak:
        return 1;
      case PasswordStrength.medium:
        return 3;
      case PasswordStrength.strong:
        return 4;
    }
  }
}
