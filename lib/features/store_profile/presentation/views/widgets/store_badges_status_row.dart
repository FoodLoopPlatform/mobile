import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

class StoreBadgesStatusRow extends StatelessWidget {
  const StoreBadgesStatusRow({super.key, required this.store});

  final StoreDetailsModel store;

  @override
  Widget build(BuildContext context) {
    final isOpen = store.isOpenNow;

    return Wrap(
      spacing: AppConstants.paddingS.w,
      runSpacing: AppConstants.paddingS.h,
      children: [
        // Open / Closed badge
        _StatusBadge(
          label: isOpen ? AppStrings.storeOpenNow : AppStrings.storeClosedNow,
          icon: Icons.access_time_rounded,
          backgroundColor: isOpen
              ? AppColors.secondaryContainer
              : AppColors.surfaceContainerHigh,
          foregroundColor: isOpen
              ? AppColors.onSecondaryContainer
              : AppColors.textSecondary,
        ),

        // Verified badge (if applicable)
        if (store.verificationStatus.toLowerCase() == 'verified')
          _StatusBadge(
            label: AppStrings.storeVerified,
            icon: Icons.verified_rounded,
            backgroundColor: AppColors.primarySurface,
            foregroundColor: AppColors.primary,
          ),

        // Business category badge
        if (store.businessCategory.isNotEmpty)
          _StatusBadge(
            label: store.businessCategory,
            icon: Icons.storefront_rounded,
            backgroundColor: AppColors.tertiarySurface,
            foregroundColor: AppColors.tertiary,
          ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: foregroundColor),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
