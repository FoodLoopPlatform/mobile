import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Dismissible error strip shown above the form when an error occurs.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({
    super.key, 
    required this.message, 
    required this.onClose,
  });

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.error,
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM.w,
        vertical: AppConstants.paddingS.h,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded,
              size: 18.r, color: Colors.white),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onClose,
            child: Icon(Icons.close_rounded,
                size: 18.r, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
