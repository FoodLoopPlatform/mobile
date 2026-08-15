import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Horizontally scrolling category filter chips (static selection).
class MarketCategoryChips extends StatefulWidget {
  const MarketCategoryChips({super.key, this.onCategorySelected});

  final ValueChanged<String?>? onCategorySelected;

  @override
  State<MarketCategoryChips> createState() => _MarketCategoryChipsState();
}

class _MarketCategoryChipsState extends State<MarketCategoryChips> {
  static final List<Map<String, String?>> _categories = [
    {'label': AppStrings.viewAll, 'id': null},
    {'label': AppStrings.categoryBakery, 'id': 'Bakery'},
    {'label': AppStrings.categoryMeals, 'id': 'Meals'},
    {'label': AppStrings.categoryGroceries, 'id': 'Groceries'},
    {'label': AppStrings.categoryDesserts, 'id': 'Desserts'},
    {'label': AppStrings.categoryBeverages, 'id': 'Beverages'},
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
          final cat = _categories[index];
          return GestureDetector(
            onTap: () {
              if (_selected != index) {
                setState(() => _selected = index);
                widget.onCategorySelected?.call(cat['id']);
              }
            },
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
                cat['label']!,
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
