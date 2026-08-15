import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/core/enums/account_type_enum.dart';
import 'package:foodloop/core/models/user_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_add_to_cart_bar.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_gallery.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_logistics_card.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_price_bento.dart';

class ProductDetailsBody extends StatefulWidget {
  const ProductDetailsBody({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailsBody> createState() => _ProductDetailsBodyState();
}

class _ProductDetailsBodyState extends State<ProductDetailsBody> {
  bool isCustomer = false;
  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  void _loadRole() async {
    final role = await SecureStorageHelper.getUserRole();
    if (mounted) {
      setState(() {
        isCustomer = role?.toLowerCase() == 'user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingS.h,
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingL.h,
            ),
            children: [
              ProductGallery(product: widget.product),
              SizedBox(height: AppConstants.paddingM.h),

              if (widget.product.inStock) const _InStockBadge(),
              SizedBox(height: AppConstants.paddingS.h),

              Text(
                widget.product.name,
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppConstants.paddingS.h),

              _SellerRow(product: widget.product),
              SizedBox(height: AppConstants.paddingL.h),

              ProductPriceBento(product: widget.product),
              SizedBox(height: AppConstants.paddingL.h),

              _DescriptionSection(product: widget.product),
              SizedBox(height: AppConstants.paddingM.h),

              const _NutritionChips(),
              SizedBox(height: AppConstants.paddingL.h),

              const ProductLogisticsCard(),
            ],
          ),
        ),

        // Only regular customers can add to cart — sellers/charities browse only.
        if (isCustomer) ProductAddToCartBar(product: widget.product),
      ],
    );
  }
}

class _InStockBadge extends StatelessWidget {
  const _InStockBadge();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
        ),
        child: Text(
          AppStrings.inStock,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

class _SellerRow extends StatelessWidget {
  const _SellerRow({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: Icon(Icons.spa_rounded, size: 16.r, color: AppColors.primary),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.seller,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.outlineVariant,
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 14.r,
                  color: AppColors.onTertiaryContainer,
                ),
                SizedBox(width: 2.w),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '(${product.reviews} ${AppStrings.reviewsCount})',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.productDetailsSection,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: AppColors.outline,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          product.description ?? '',
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 15.sp,
            height: 1.7,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _NutritionChips extends StatelessWidget {
  const _NutritionChips();

  static final List<(IconData, String)> _chips = [
    (Icons.verified_rounded, AppStrings.chipCertifiedOrganic),
    (Icons.energy_savings_leaf_rounded, AppStrings.chipZeroPlastic),
    (Icons.social_distance_rounded, AppStrings.chipWithinFiveMiles),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppConstants.paddingXS.w,
      runSpacing: AppConstants.paddingXS.h,
      children: [
        for (final (icon, label) in _chips)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16.r, color: AppColors.primaryLight),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
