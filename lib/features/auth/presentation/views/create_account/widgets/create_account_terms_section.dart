import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';

class CreateAccountTermsSection extends StatelessWidget {
  const CreateAccountTermsSection({
    super.key,
    required this.agreedToTerms,
    required this.onChanged,
  });

  final bool agreedToTerms;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20.r,
          height: 20.r,
          child: Checkbox(
            value: agreedToTerms,
            activeColor: AppColors.primary,
            side: const BorderSide(color: AppColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(text: AppStrings.termsPrefix),
                TextSpan(
                  text: AppStrings.termsOfService,
                  style: const TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: AppStrings.termsAnd),
                TextSpan(
                  text: AppStrings.privacyPolicy,
                  style: const TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: AppStrings.termsSuffix),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
