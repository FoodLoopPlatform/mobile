import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Compact discounted-deal card with a countdown, used in "Nearby Deals".
class NearbyDealCard extends StatelessWidget {
  const NearbyDealCard({
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
        width: 150.w,
        padding: EdgeInsets.all(AppConstants.paddingXS.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image + discount ---
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              child: SizedBox(
                height: 110.h,
                width: double.infinity,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ProductImage(imageUrl: product.imageUrl, iconSize: 24.r),
                    ),
                    if (product.discountPercent != null)
                      Positioned(
                        bottom: 6.r,
                        right: 6.r,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.9),
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusS.r),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppConstants.paddingXS.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.seller,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 10.sp,
                      color: AppColors.outline,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${AppStrings.currencyEgp} ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      if (product.oldPrice != null)
                        Text(
                          product.oldPrice!.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 10.sp,
                            color: AppColors.outline,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  if (product.countdown != null) ...[
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 12.r, color: AppColors.error),
                        SizedBox(width: 4.w),
                        Text(
                          product.countdown!,
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 10.sp,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
