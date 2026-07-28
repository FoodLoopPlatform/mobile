import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/enums/password_strength_enum.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/validation.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';
import 'package:foodloop/features/auth/presentation/widgets/auth_dotted_background.dart';
import 'package:foodloop/features/auth/presentation/widgets/password_strength_indicator.dart';

class ResetPasswordCard extends StatelessWidget {
  const ResetPasswordCard({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.strength,
    required this.onPasswordChanged,
    required this.onUpdatePassword,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final PasswordStrength strength;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onUpdatePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // --- Corner texture patch ---
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 128.r,
              height: 128.r,
              child: const Opacity(
                opacity: 0.5,
                child: AuthDottedBackground(spacing: 16, dotRadius: 0.75),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(AppConstants.paddingL.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Heading ---
                Text(
                  AppStrings.resetPasswordTitle,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppConstants.paddingS.h),
                Text(
                  AppStrings.resetPasswordSubtitle,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: AppConstants.paddingL.h),

                // --- New password ---
                CustomTextField(
                  label: AppStrings.newPasswordLabel,
                  hint: AppStrings.newPasswordHint,
                  controller: passwordController,
                  isPassword: true,
                  validator: Validation.validatePassword,
                  onChanged: onPasswordChanged,
                ),
                SizedBox(height: AppConstants.paddingS.h),

                // --- Strength meter ---
                PasswordStrengthIndicator(strength: strength),
                SizedBox(height: AppConstants.paddingL.h),

                // --- Confirm password ---
                CustomTextField(
                  label: AppStrings.confirmNewPasswordLabel,
                  hint: AppStrings.confirmNewPasswordHint,
                  controller: confirmPasswordController,
                  isPassword: true,
                  validator:
                      Validation.validateConfirmPassword(passwordController.text),
                ),
                SizedBox(height: AppConstants.paddingL.h),

                // --- Submit ---
                CustomButton(
                  label: AppStrings.updatePassword,
                  suffixIcon: Icons.check_circle_outline_rounded,
                  onTap: onUpdatePassword,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
