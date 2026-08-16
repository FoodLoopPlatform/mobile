import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/store_profile/presentation/manager/store_profile_cubit/store_profile_cubit.dart';
import 'package:foodloop/features/store_profile/presentation/manager/store_profile_cubit/store_profile_state.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/review_item_widget.dart';

class RecentReviewsSection extends StatelessWidget {
  const RecentReviewsSection({super.key, required this.state});

  final StoreProfileLoaded state;

  @override
  Widget build(BuildContext context) {
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
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.storeRecentReviewsTitle,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.outline,
                ),
              ),
              Text(
                '${state.store.totalReviews} ${AppStrings.storeTotalReviews}',
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),

          // Review items
          if (state.reviews.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppConstants.paddingL.h),
              child: Center(
                child: Text(
                  AppStrings.storeNoReviews,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    color: AppColors.outline,
                  ),
                ),
              ),
            )
          else
            ...state.reviews.map((r) => ReviewItemWidget(review: r)),

          // Load more button
          if (state.hasMoreReviews || state.isLoadingMoreReviews)
            Padding(
              padding: EdgeInsets.only(top: AppConstants.paddingM.h),
              child: SizedBox(
                width: double.infinity,
                child: state.isLoadingMoreReviews
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppConstants.paddingS.h),
                          child: const CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    : OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusM.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onPressed: () =>
                            context.read<StoreProfileCubit>().loadMoreReviews(),
                        child: Text(
                          AppStrings.storeLoadMoreReviews,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
