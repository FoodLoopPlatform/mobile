import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Wide featured card used in the "Recommended for You" carousel.
class RecommendedProductCard extends StatelessWidget {
  const RecommendedProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260.w,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image + badge ---
            SizedBox(
              height: 150.h,
              child: Stack(
                children: [
                  Positioned.fill(child: ProductImage(imageUrl: product.imageUrl)),
                  if (product.badge != null)
                    Positioned(
                      top: 12.r,
                      right: 12.r,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusFull.r),
                        ),
                        child: Text(
                          product.badge!,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- Details ---
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingM.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.seller,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingS.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppStrings.currencyEgp} ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusS.r),
                        ),
                        child: Icon(Icons.add_shopping_cart_rounded,
                            size: 20.r, color: AppColors.textOnPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
