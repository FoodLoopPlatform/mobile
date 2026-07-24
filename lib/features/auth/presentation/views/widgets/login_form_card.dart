import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/validation.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

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
            AppStrings.loginTitle,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.loginSubtitle,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 13.sp,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Email ---
          CustomTextField(
            label: AppStrings.emailLabel,
            hint: AppStrings.loginEmailHint,
            labelIcon: Icons.alternate_email_rounded,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validation.validateEmail,
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Password ---
          CustomTextField(
            label: AppStrings.passwordLabel,
            hint: AppStrings.passwordHint,
            labelIcon: Icons.lock_outline_rounded,
            controller: passwordController,
            isPassword: true,
            validator: Validation.validateRequiredField,
          ),
          SizedBox(height: AppConstants.paddingS.h),

          // --- Forgot password ---
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                RoutesNames.forgotPasswordView,
              ),
              child: Text(
                AppStrings.forgotPassword,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: AppColors.primaryLight,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryLight,
                ),
              ),
            ),
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Login button ---
          CustomButton(
            label: AppStrings.loginButton,
            suffixIcon: Icons.arrow_forward_rounded,
            onTap: onLogin,
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Create account link ---
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  AppStrings.noAccountPrefix,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    RoutesNames.createAccountView,
                  ),
                  child: Text(
                    AppStrings.joinFoodloop,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
