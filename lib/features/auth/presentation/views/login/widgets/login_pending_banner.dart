import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Dismissible status strip shown above the login form while an account is
/// still awaiting verification.
class LoginPendingBanner extends StatelessWidget {
  const LoginPendingBanner({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.tertiaryFixed,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM.w,
        vertical: AppConstants.paddingS.h,
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_person_rounded,
            size: 18.r,
            color: AppColors.onTertiaryFixed,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              AppStrings.accountPendingBanner,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.onTertiaryFixed,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onClose,
            child: Icon(
              Icons.close_rounded,
              size: 18.r,
              color: AppColors.onTertiaryFixed,
            ),
          ),
        ],
      ),
    );
  }
}
