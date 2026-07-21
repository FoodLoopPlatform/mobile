import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/validation.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';

class CreateAccountFormFields extends StatelessWidget {
  const CreateAccountFormFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordStrength,
    required this.passwordStrengthColor,
    required this.onPasswordChanged,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String passwordStrength;
  final Color passwordStrengthColor;
  final ValueChanged<String> onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: AppStrings.fullNameLabel,
          hint: AppStrings.fullNameHint,
          controller: fullNameController,
          keyboardType: TextInputType.name,
          validator: Validation.validateRequiredField,
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          label: AppStrings.emailLabel,
          hint: AppStrings.emailHint,
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: Validation.validateEmail,
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          label: AppStrings.passwordLabel,
          hint: '••••••',
          controller: passwordController,
          isPassword: true,
          validator: Validation.validatePassword,
          onChanged: onPasswordChanged,
          suffixWidget: passwordStrength.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Center(
                    child: Text(
                      passwordStrength,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: passwordStrengthColor,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        if (passwordController.text.isNotEmpty &&
            passwordController.text.length < 8) ...[
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 12.r, color: AppColors.error),
              SizedBox(width: 4.w),
              Text(
                AppStrings.passwordMinLength,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
        SizedBox(height: 20.h),
        CustomTextField(
          label: AppStrings.confirmPasswordLabel,
          hint: '••••••',
          controller: confirmPasswordController,
          isPassword: true,
          validator: Validation.validateConfirmPassword(passwordController.text),
        ),
      ],
    );
  }
}
