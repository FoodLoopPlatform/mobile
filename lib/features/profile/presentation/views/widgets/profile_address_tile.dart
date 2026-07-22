import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

class ProfileAddressTile extends StatelessWidget {
  const ProfileAddressTile({
    super.key,
    required this.icon,
    required this.title,
    required this.line1,
    required this.line2,
    this.isDefault = false,
  });

  final IconData icon;
  final String title;
  final String line1;
  final String line2;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: isDefault
            ? AppColors.secondaryContainer.withValues(alpha: 0.08)
            : AppColors.surfaceContainerLow,
        border: Border.all(
          color: isDefault ? AppColors.primaryLight : AppColors.outlineVariant,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Leading icon badge ---
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDefault
                  ? AppColors.secondaryContainer
                  : AppColors.surfaceContainerHigh,
            ),
            child: Icon(
              icon,
              size: 20.r,
              color: isDefault
                  ? AppColors.onSecondaryContainer
                  : AppColors.textSecondary,
            ),
          ),
          SizedBox(width: AppConstants.paddingS.w),

          // --- Title + address lines ---
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (isDefault) ...[
                      SizedBox(width: 8.w),
                      const _DefaultBadge(),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  line1,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  line2,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: AppColors.outline,
                  ),
                ),
              ],
            ),
          ),

          // --- Edit / delete actions ---
          _ActionIcon(
            icon: Icons.edit_outlined,
            color: AppColors.primaryLight,
            onTap: () {},
          ),
          _ActionIcon(
            icon: Icons.delete_outline_rounded,
            color: AppColors.error,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  const _DefaultBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
      ),
      child: Text(
        AppStrings.addressDefaultBadge,
        style: TextStyle(
          fontFamily: 'DmSans',
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
      constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
      padding: EdgeInsets.all(6.r),
      icon: Icon(icon, size: 20.r, color: color),
    );
  }
}
