import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/add_product/data/models/category_model.dart';
import 'package:foodloop/features/add_product/presentation/manager/category_cubit/category_cubit.dart';
import 'package:foodloop/features/add_product/presentation/manager/category_cubit/category_state.dart';

/// Horizontally scrolling category filter chips.
class MarketCategoryChips extends StatelessWidget {
  const MarketCategoryChips({
    super.key,
    this.selectedCategoryId,
    this.onCategorySelected,
  });

  final String? selectedCategoryId;
  final ValueChanged<String?>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return SizedBox(
            height: 36.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is CategoryLoaded) {
          final categories = [
            CategoryModel(id: '', name: AppStrings.viewAll),
            ...state.categories,
          ];

          return SizedBox(
            height: 36.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.screenHorizontalPadding.w,
              ),
              itemCount: categories.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: AppConstants.paddingXS.w),
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = (cat.id.isEmpty && selectedCategoryId == null) ||
                    (cat.id == selectedCategoryId);

                return GestureDetector(
                  onTap: () {
                    if (!isSelected) {
                      onCategorySelected?.call(cat.id.isEmpty ? null : cat.id);
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
                      cat.name,
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

        return SizedBox(height: 36.h);
      },
    );
  }
}
