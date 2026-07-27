import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/enums/password_strength_enum.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// "PASSWORD STRENGTH" caption plus a four-segment meter.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.strength});

  static const int _segmentCount = 4;

  final PasswordStrength strength;

  Color get _strengthColor {
    switch (strength) {
      case PasswordStrength.none:
        return AppColors.outline;
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return AppColors.tertiary;
      case PasswordStrength.strong:
        return AppColors.primaryLight;
    }
  }

  Color get _barColor {
    switch (strength) {
      case PasswordStrength.none:
        return AppColors.outlineVariant;
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return AppColors.tertiaryFixedDim;
      case PasswordStrength.strong:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.passwordStrengthLabel,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              strength.label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: _strengthColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Row(
          children: List.generate(_segmentCount, (index) {
            final isFilled = index < strength.filledBars;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == _segmentCount - 1 ? 0 : 4.w,
                ),
                child: AnimatedContainer(
                  duration: AppConstants.animationFast,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isFilled
                        ? _barColor
                        : AppColors.outlineVariant.withValues(alpha: 0.35),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull.r),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
