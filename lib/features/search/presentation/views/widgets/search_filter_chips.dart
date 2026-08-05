import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Horizontally scrolling filter row. Static/visual — the first chip carries a
/// dropdown affordance, the rest are plain toggles.
class SearchFilterChips extends StatelessWidget {
  const SearchFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w,
        ),
        children: [
          _Chip(
            label: AppStrings.filterSortByPrice,
            selected: true,
            trailingIcon: Icons.keyboard_arrow_down_rounded,
          ),
          SizedBox(width: AppConstants.paddingXS.w),
          _Chip(label: AppStrings.filterRating),
          SizedBox(width: AppConstants.paddingXS.w),
          _Chip(label: AppStrings.filterNearby),
          SizedBox(width: AppConstants.paddingXS.w),
          _Chip(label: AppStrings.filterOrganicOnly),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    this.selected = false,
    this.trailingIcon,
  });

  final String label;
  final bool selected;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
        border: selected
            ? null
            : Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: selected
                  ? AppColors.onSecondaryContainer
                  : AppColors.textSecondary,
            ),
          ),
          if (trailingIcon != null) ...[
            SizedBox(width: 4.w),
            Icon(trailingIcon,
                size: 16.r, color: AppColors.onSecondaryContainer),
          ],
        ],
      ),
    );
  }
}
