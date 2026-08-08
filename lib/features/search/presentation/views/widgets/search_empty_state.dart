import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_outlined_button.dart';

/// Shown when a query returns nothing: illustration, message with the query,
/// recovery actions, and a few trending suggestions.
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    required this.query,
    required this.onBrowseAll,
    required this.onClearFilters,
  });

  final String query;
  final VoidCallback onBrowseAll;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppConstants.screenHorizontalPadding.w),
      children: [
        SizedBox(height: AppConstants.paddingL.h),

        // --- Illustration ---
        Center(
          child: Container(
            width: 120.r,
            height: 120.r,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search_off_rounded,
                size: 56.r, color: AppColors.outline),
          ),
        ),
        SizedBox(height: AppConstants.paddingL.h),

        // --- Message ---
        Text(
          '${AppStrings.noResultsTitlePrefix} "$query"',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppConstants.paddingS.h),
        Text(
          AppStrings.noResultsSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: AppConstants.paddingL.h),

        // --- Actions ---
        CustomButton(
          label: AppStrings.browseAllDeals,
          onTap: onBrowseAll,
        ),
        SizedBox(height: AppConstants.paddingS.h),
        CustomOutlinedButton(
          label: AppStrings.clearAllFilters,
          onTap: onClearFilters,
        ),
        SizedBox(height: AppConstants.paddingXL.h),

        // --- Suggestions ---
        Text(
          AppStrings.trendingInArea,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.outline,
          ),
        ),
        SizedBox(height: AppConstants.paddingM.h),
        _SuggestionTile(
          icon: Icons.eco_rounded,
          iconColor: AppColors.onSecondaryContainer,
          iconBackground: AppColors.secondaryContainer,
          title: AppStrings.suggestionTomatoes,
          distance: AppStrings.suggestionTomatoesDistance,
          onTap: () {},
        ),
        SizedBox(height: AppConstants.paddingS.h),
        _SuggestionTile(
          icon: Icons.bakery_dining_rounded,
          iconColor: AppColors.onTertiaryFixed,
          iconBackground: AppColors.tertiaryFixed,
          title: AppStrings.suggestionSourdough,
          distance: AppStrings.suggestionSourdoughDistance,
          onTap: () {},
        ),
      ],
    );
  }
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.distance,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConstants.paddingS.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              ),
              child: Icon(icon, size: 24.r, color: iconColor),
            ),
            SizedBox(width: AppConstants.paddingS.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  distance,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
