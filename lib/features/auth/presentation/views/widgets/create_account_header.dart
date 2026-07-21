import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';

class CreateAccountHeader extends StatelessWidget {
  const CreateAccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.createAccountTitle,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          AppStrings.createAccountSubtitle,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 13.sp,
            color: AppColors.primary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
