import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

class ReputationCard extends StatelessWidget {
  const ReputationCard({super.key, required this.store});

  final StoreDetailsModel store;

  @override
  Widget build(BuildContext context) {
    final maxCount = store.ratingDistribution.isEmpty
        ? 1
        : store.ratingDistribution
            .map((e) => e.count)
            .reduce((a, b) => a > b ? a : b)
            .clamp(1, double.maxFinite)
            .toInt();

    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.storeReputationTitle,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.outline,
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Large rating number ─────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: store.averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 48.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                        TextSpan(
                          text: '  ${AppStrings.storeRatingSuffix}',
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 14.sp,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
                  _StarRow(rating: store.averageRating),
                  SizedBox(height: 4.h),
                  Text(
                    '${store.totalReviews} ${AppStrings.storeVerifiedCustomers}',
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 11.sp,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppConstants.paddingM.w),

              // ── Distribution bars ───────────────────────────────────────
              Expanded(
                child: Column(
                  children: [
                    for (int star = 5; star >= 1; star--)
                      _RatingBar(
                        star: star,
                        count: store.ratingDistribution
                            .where((e) => e.stars == star)
                            .map((e) => e.count)
                            .firstOrNull ?? 0,
                        maxCount: maxCount,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = i < rating.floor();
        final half = !filled && i < rating;
        return Icon(
          half ? Icons.star_half_rounded : Icons.star_rounded,
          size: 16.r,
          color: filled || half
              ? AppColors.onTertiaryContainer
              : AppColors.outlineVariant,
        );
      }),
    );
  }
}

class _RatingBar extends StatelessWidget {
  const _RatingBar({
    required this.star,
    required this.count,
    required this.maxCount,
  });

  final int star;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final fraction = maxCount > 0 ? count / maxCount : 0.0;
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            '$star',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10.sp,
              color: AppColors.outline,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.star_rounded,
              size: 10.r, color: AppColors.onTertiaryContainer),
          SizedBox(width: 6.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
              child: LinearProgressIndicator(
                value: fraction.toDouble(),
                minHeight: 6.h,
                backgroundColor: AppColors.surfaceContainerHighest,
                color: star >= 4 ? AppColors.primary : AppColors.primaryLight,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          SizedBox(
            width: 20.w,
            child: Text(
              '$count',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 10.sp,
                color: AppColors.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
