import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// How much shelf life is left on the earliest expiring batch.
enum ShelfLife {
  unknown,
  expired,
  short,
  moderate,
  long;

  /// Buckets by days remaining: past → expired, ≤7 short, ≤30 moderate.
  static ShelfLife fromDate(DateTime? date) {
    if (date == null) return ShelfLife.unknown;
    final days = DateUtils.dateOnly(date)
        .difference(DateUtils.dateOnly(DateTime.now()))
        .inDays;
    if (days < 0) return ShelfLife.expired;
    if (days <= 7) return ShelfLife.short;
    if (days <= 30) return ShelfLife.moderate;
    return ShelfLife.long;
  }

  String get label {
    switch (this) {
      case ShelfLife.unknown:
        return AppStrings.shelfLifeUnknown;
      case ShelfLife.expired:
        return AppStrings.shelfLifeExpired;
      case ShelfLife.short:
        return AppStrings.shelfLifeShort;
      case ShelfLife.moderate:
        return AppStrings.shelfLifeModerate;
      case ShelfLife.long:
        return AppStrings.shelfLifeLong;
    }
  }

  Color get color {
    switch (this) {
      case ShelfLife.unknown:
        return AppColors.textHint;
      case ShelfLife.expired:
        return AppColors.error;
      case ShelfLife.short:
        return AppColors.pending;
      case ShelfLife.moderate:
        return AppColors.tertiary;
      case ShelfLife.long:
        return AppColors.success;
    }
  }
}

class VerificationStatusCard extends StatelessWidget {
  const VerificationStatusCard({
    super.key,
    required this.productName,
    required this.quantity,
    required this.earliestDate,
  });

  final String productName;
  final int quantity;
  final DateTime? earliestDate;

  @override
  Widget build(BuildContext context) {
    final shelfLife = ShelfLife.fromDate(earliestDate);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppConstants.paddingS.r),
            color: AppColors.primary,
            child: Text(
              AppStrings.verificationStatusTitle,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingM.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Product + quantity ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.productNameStatusLabel,
                            style: TextStyle(
                              fontFamily: 'DmSans',
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            productName,
                            style: TextStyle(
                              fontFamily: 'DmSans',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusM.r),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: Text(
                        '${AppStrings.quantityShort}: $quantity',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppConstants.paddingM.h),
                Divider(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                SizedBox(height: AppConstants.paddingS.h),

                // --- Indicators ---
                _StatusRow(
                  icon: Icons.schedule_rounded,
                  label: AppStrings.shelfLifeIndexLabel,
                  value: shelfLife.label,
                  valueColor: shelfLife.color,
                ),
                SizedBox(height: AppConstants.paddingS.h),
                _StatusRow(
                  icon: Icons.verified_user_outlined,
                  label: AppStrings.batchIntegrityLabel,
                  value: AppStrings.batchIntegrityPending,
                  valueColor: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primaryLight),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
