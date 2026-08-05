import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Horizontally scrolling category filter chips (static selection).
class MarketCategoryChips extends StatefulWidget {
  const MarketCategoryChips({super.key});

  @override
  State<MarketCategoryChips> createState() => _MarketCategoryChipsState();
}

class _MarketCategoryChipsState extends State<MarketCategoryChips> {
  static const List<String> _categories = [
    AppStrings.categoryBakery,
    AppStrings.categoryMeals,
    AppStrings.categoryGroceries,
    AppStrings.categoryDesserts,
    AppStrings.categoryBeverages,
  ];

  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w,
        ),
        itemCount: _categories.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppConstants.paddingXS.w),
        itemBuilder: (context, index) {
          final isSelected = index == _selected;
          return GestureDetector(
            onTap: () => setState(() => _selected = index),
            child: AnimatedContainer(
              duration: AppConstants.animationFast,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondaryContainer
                    : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
              ),
              child: Text(
                _categories[index],
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.onSecondaryContainer
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
