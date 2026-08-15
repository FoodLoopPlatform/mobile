import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/validation.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';

class ForgotPasswordCard extends StatelessWidget {
  const ForgotPasswordCard({
    super.key,
    required this.emailController,
    required this.onSendResetLink,
    this.isLoading = false,
  });

  final TextEditingController emailController;
  final VoidCallback onSendResetLink;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingL.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Heading ---
          Text(
            AppStrings.forgotPasswordTitle,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          Text(
            AppStrings.forgotPasswordSubtitle,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 13.sp,
              height: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Email ---
          CustomTextField(
            label: AppStrings.emailLabel,
            hint: AppStrings.forgotPasswordEmailHint,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validation.validateEmail,
            suffixWidget: Icon(
              Icons.mail_outline_rounded,
              size: 18.r,
              color: AppColors.outline,
            ),
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Submit ---
          CustomButton(
            label: AppStrings.sendResetLink,
            suffixIcon: Icons.arrow_forward_rounded,
            isLoading: isLoading,
            onTap: onSendResetLink,
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Back to login ---
          Divider(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
          SizedBox(height: AppConstants.paddingM.h),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.keyboard_backspace_rounded,
                      size: 18.r, color: AppColors.primaryLight),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.backToLogin,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 14.sp,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
