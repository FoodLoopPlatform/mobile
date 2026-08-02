import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Hero image with a savings badge and a flash-deal countdown overlay.
class ProductGallery extends StatelessWidget {
  const ProductGallery({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        child: Stack(
          children: [
            Positioned.fill(child: ProductImage(imageUrl: product.imageUrl)),

            // --- Savings badge ---
            if (product.discountPercent != null)
              Positioned(
                top: 12.r,
                right: 12.r,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_offer_rounded,
                          size: 14.r, color: AppColors.onTertiaryContainer),
                      SizedBox(width: 4.w),
                      Text(
                        '${AppStrings.saveBadgePrefix} ${product.discountPercent}%',
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // --- Flash deal countdown ---
            if (product.countdown != null)
              Positioned(
                left: 12.r,
                right: 12.r,
                bottom: 12.r,
                child: Container(
                  padding: EdgeInsets.all(AppConstants.paddingS.r),
                  decoration: BoxDecoration(
                    color: AppColors.errorContainer.withValues(alpha: 0.92),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusM.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_rounded,
                          size: 22.r, color: AppColors.onErrorContainer),
                      SizedBox(width: AppConstants.paddingS.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.flashDealExpires,
                            style: TextStyle(
                              fontFamily: 'DmSans',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                              color: AppColors.onErrorContainer
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            product.countdown!,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
