import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/widgets/product_image.dart';

/// Square grid tile used in the "Trending Now" section.
class TrendingItemCard extends StatelessWidget {
  const TrendingItemCard({
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
        padding: EdgeInsets.all(AppConstants.paddingS.r),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
              child: SizedBox(
                height: 90.h,
                width: double.infinity,
                child: ProductImage(imageUrl: product.imageUrl, iconSize: 24.r),
              ),
            ),
            SizedBox(height: AppConstants.paddingS.h),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              product.tagline ?? product.seller,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
