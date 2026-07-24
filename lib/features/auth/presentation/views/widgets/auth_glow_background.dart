import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';

/// Soft tinted glows bleeding in from the top-right and bottom-left corners,
/// standing in for the designs' blurred background orbs.
class AuthGlowBackground extends StatelessWidget {
  const AuthGlowBackground({super.key, this.size = 280});

  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -(size / 3).r,
            right: -(size / 3).r,
            child: _Glow(color: AppColors.primary, size: size),
          ),
          Positioned(
            bottom: -(size / 3).r,
            left: -(size / 3).r,
            child: _Glow(color: AppColors.primaryLight, size: size),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.10),
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}
