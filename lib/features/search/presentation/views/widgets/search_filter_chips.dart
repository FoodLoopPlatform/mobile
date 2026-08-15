import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// Horizontally scrolling filter row.
class SearchFilterChips extends StatefulWidget {
  const SearchFilterChips({super.key, this.onFilterSelected});

  final void Function(String? sortBy)? onFilterSelected;

  @override
  State<SearchFilterChips> createState() => _SearchFilterChipsState();
}

class _SearchFilterChipsState extends State<SearchFilterChips> {
  int? _selectedIndex;

  void _handleTap(int index, String filterKey) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null;
        widget.onFilterSelected?.call(null);
      } else {
        _selectedIndex = index;
        widget.onFilterSelected?.call(filterKey);
      }
    });
  }

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
          GestureDetector(
            onTap: () => _handleTap(0, 'price'),
            child: _Chip(
              label: AppStrings.filterSortByPrice,
              selected: _selectedIndex == 0,
              trailingIcon: Icons.keyboard_arrow_down_rounded,
            ),
          ),
          SizedBox(width: AppConstants.paddingXS.w),
          GestureDetector(
            onTap: () => _handleTap(1, 'rating'),
            child: _Chip(
              label: AppStrings.filterRating,
              selected: _selectedIndex == 1,
            ),
          ),
          SizedBox(width: AppConstants.paddingXS.w),
          GestureDetector(
            onTap: () => _handleTap(2, 'distance'),
            child: _Chip(
              label: AppStrings.filterNearby,
              selected: _selectedIndex == 2,
            ),
          ),
          SizedBox(width: AppConstants.paddingXS.w),
          GestureDetector(
            onTap: () => _handleTap(3, 'organic'),
            child: _Chip(
              label: AppStrings.filterOrganicOnly,
              selected: _selectedIndex == 3,
            ),
          ),
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
