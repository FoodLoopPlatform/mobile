import 'package:flutter/material.dart';

abstract class AppColors {
  // --- Primary Palette ---
  static const Color primary = Color(0xFF005129);
  static const Color primaryLight = Color(0xFF006D38);
  static const Color primaryLighter = Color(0xFF338056);
  static const Color primarySurface = Color(0xFFCCE5D9);

  // --- Secondary (Warm Brown / Tertiary) ---
  static const Color tertiary = Color(0xFF643E00);
  static const Color tertiaryLight = Color(0xFF8A5E1A);
  static const Color tertiarySurface = Color(0xFFF3E5CC);

  // --- Neutral ---
  static const Color neutral = Color(0xFF747873);
  static const Color neutralLight = Color(0xFFA8ABA9);
  static const Color neutralDark = Color(0xFF3D403E);

  // --- Background & Surface ---
  static const Color background = Color(0xFFF5F5EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEEEEE6);

  // --- Text ---
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // --- Semantic ---
  static const Color error = Color(0xFFB00020);
  static const Color errorLight = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF006D38);
  static const Color warning = Color(0xFF643E00);
  static const Color pending = Color(0xFF947400);
  static const Color pendingSurface = Color(0xFFFFF3CC);

  // --- Border ---
  static const Color border = Color(0xFFD9D9D0);
  static const Color borderFocused = Color(0xFF005129);
}
