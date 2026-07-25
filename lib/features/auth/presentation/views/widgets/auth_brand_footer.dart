import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';

/// Centered "Foodloop" wordmark closing out the auth screens.
class AuthBrandFooter extends StatelessWidget {
  const AuthBrandFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppStrings.appName,
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
