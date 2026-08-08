import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Search-results grid card: tall image with an optional countdown badge,
/// seller caption, name, and discounted price.
class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
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
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image + countdown ---
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(child: ProductImage(imageUrl: product.imageUrl)),
                  if (product.countdown != null)
                    Positioned(
                      top: 8.r,
                      right: 8.r,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: AppColors.tertiary,
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusS.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_rounded,
                                size: 12.r, color: AppColors.onTertiary),
                            SizedBox(width: 4.w),
                            Text(
                              product.countdown!,
                              style: TextStyle(
                                fontFamily: 'JetBrainsMono',
                                fontSize: 10.sp,
                                color: AppColors.onTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // --- Details ---
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingS.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.seller,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AppColors.outline,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${AppStrings.currencyEgp} ${product.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        SizedBox(width: 6.w),
                        Text(
                          product.oldPrice!.toStringAsFixed(2),
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 11.sp,
                            color: AppColors.outline,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
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
