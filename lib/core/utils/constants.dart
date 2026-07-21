abstract class AppConstants {
  // --- Padding & Spacing ---
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // --- Screen Horizontal Padding ---
  static const double screenHorizontalPadding = 20.0;

  // --- Border Radius ---
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusFull = 100.0;

  // --- Button Height ---
  static const double buttonHeight = 52.0;

  // --- Divider Thickness ---
  static const double dividerThickness = 1.0;

  // --- Animation Durations ---
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // --- Email Verification OTP Expiry ---
  static const int otpExpirySeconds = 300; // 5 minutes
}
