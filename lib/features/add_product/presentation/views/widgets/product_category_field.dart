import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/widgets/custom_dropdown_field.dart';
import 'package:foodloop/features/add_product/data/models/category_model.dart';
import 'package:foodloop/features/add_product/presentation/manager/category_cubit/category_cubit.dart';
import 'package:foodloop/features/add_product/presentation/manager/category_cubit/category_state.dart';

/// Category picker backed by `GET /categories`.
class ProductCategoryField extends StatelessWidget {
  const ProductCategoryField({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final CategoryModel? selected;
  final ValueChanged<CategoryModel?> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryFail) {
          return _CategoryMessage(
            message: state.message,
            onRetry: () => context.read<CategoryCubit>().loadCategories(
                  forceRefresh: true,
                ),
          );
        }

        final categories =
            state is CategoryLoaded ? state.categories : <CategoryModel>[];
        final isLoading = state is CategoryLoading || state is CategoryInitial;

        return CustomDropdownField<CategoryModel>(
          label: AppStrings.productCategoryLabel,
          hint: isLoading
              ? AppStrings.categoriesLoading
              : AppStrings.productCategoryHint,
          // A value absent from `items` throws, so it's only passed through
          // once the matching list has arrived.
          value: categories.contains(selected) ? selected : null,
          items: categories
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(category.name),
                ),
              )
              .toList(),
          onChanged: isLoading ? (_) {} : onChanged,
          validator: (value) =>
              value == null ? AppStrings.categoryFieldRequired : null,
        );
      },
    );
  }
}

class _CategoryMessage extends StatelessWidget {
  const _CategoryMessage({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.productCategoryLabel,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  color: AppColors.error,
                ),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retry,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
