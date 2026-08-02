import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Warm "active order" strip with a pulsing status dot.
class MarketActiveOrderBar extends StatelessWidget {
  const MarketActiveOrderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM.w,
        vertical: AppConstants.paddingS.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.tertiary,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
      ),
      child: Row(
        children: [
          Container(
            width: 12.r,
            height: 12.r,
            decoration: const BoxDecoration(
              color: AppColors.tertiaryFixedDim,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppConstants.paddingS.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.activeOrderLabel,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.onTertiary.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  AppStrings.activeOrderStatus,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onTertiary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.delivery_dining_rounded,
              size: 24.r, color: AppColors.onTertiary),
        ],
      ),
    );
  }
}
