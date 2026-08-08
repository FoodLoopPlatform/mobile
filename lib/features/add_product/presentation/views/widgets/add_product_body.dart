import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/validation.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/features/add_product/data/models/category_model.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/manager/category_cubit/category_cubit.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/add_product_step_indicator.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/product_category_field.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/product_photo_uploader.dart';

class AddProductBody extends StatefulWidget {
  const AddProductBody({super.key});

  @override
  State<AddProductBody> createState() => _AddProductBodyState();
}

class _AddProductBodyState extends State<AddProductBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _descriptionController = TextEditingController();

  List<File> _photos = [];
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategories();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    final draft = ProductDraft(
      name: _nameController.text.trim(),
      category: _selectedCategory,
      price: _priceController.text.trim(),
      // Falls back to a single unit if the field holds something unparsable.
      quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
      description: _descriptionController.text.trim(),
      photos: _photos,
    );

    Navigator.pushNamed(
      context,
      RoutesNames.expirationDetailsView,
      arguments: draft,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppConstants.screenHorizontalPadding.w,
                AppConstants.paddingM.h,
                AppConstants.screenHorizontalPadding.w,
                AppConstants.paddingL.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddProductStepIndicator(
                    step: 1,
                    stepName: AppStrings.addProductStepName,
                  ),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Headline ---
                  Text(
                    AppStrings.addProductHeadline,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppStrings.addProductSubtitle,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Photos ---
                  ProductPhotoUploader(
                    photos: _photos,
                    onPhotosChanged: (photos) =>
                        setState(() => _photos = photos),
                  ),
                  SizedBox(height: AppConstants.paddingL.h),

                  // --- Name ---
                  CustomTextField(
                    label: AppStrings.productNameLabel,
                    hint: AppStrings.productNameHint,
                    controller: _nameController,
                    prefixIcon: Icons.restaurant_menu_rounded,
                    validator: Validation.validateRequiredField,
                  ),
                  SizedBox(height: AppConstants.paddingM.h),

                  // --- Category (from GET /categories) ---
                  ProductCategoryField(
                    selected: _selectedCategory,
                    onChanged: (category) =>
                        setState(() => _selectedCategory = category),
                  ),
                  SizedBox(height: AppConstants.paddingM.h),

                  // --- Price + Quantity ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: AppStrings.productPriceLabel,
                          hint: AppStrings.productPriceHint,
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: Validation.validateRequiredField,
                        ),
                      ),
                      SizedBox(width: AppConstants.paddingS.w),
                      Expanded(
                        child: CustomTextField(
                          label: AppStrings.productQuantityLabel,
                          hint: '1',
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          validator: Validation.validateRequiredField,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppConstants.paddingM.h),

                  // --- Description ---
                  CustomTextField(
                    label: AppStrings.productDescriptionLabel,
                    hint: AppStrings.productDescriptionHint,
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
        ),

        // --- Bottom action bar ---
        _NextBar(onNext: _onNext),
      ],
    );
  }
}

class _NextBar extends StatelessWidget {
  const _NextBar({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
            AppConstants.screenHorizontalPadding.w,
            AppConstants.paddingM.h,
          ),
          child: CustomButton(
            label: AppStrings.addProductNextStep,
            suffixIcon: Icons.arrow_forward_rounded,
            onTap: onNext,
          ),
        ),
      ),
    );
  }
}
