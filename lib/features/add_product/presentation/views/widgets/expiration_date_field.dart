import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Read-only, tappable date field — the value can only come from the platform
/// date picker, so a free-text field would just invite invalid input.
class ExpirationDateField extends StatelessWidget {
  const ExpirationDateField({
    super.key,
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  /// yyyy/MM/dd without pulling in `intl` for one format string.
  static String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}/$month/$day';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.paddingS.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              border: Border.all(
                color: date == null
                    ? AppColors.outlineVariant
                    : AppColors.primary,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.event_outlined,
                    size: 18.r, color: AppColors.primaryLight),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    date == null
                        ? AppStrings.selectDateHint
                        : formatDate(date!),
                    style: TextStyle(
                      fontFamily: date == null ? 'DmSans' : 'JetBrainsMono',
                      fontSize: 13.sp,
                      fontWeight:
                          date == null ? FontWeight.w400 : FontWeight.w500,
                      color: date == null
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
