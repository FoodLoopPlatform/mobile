import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/store_profile/presentation/manager/store_profile_cubit/store_profile_cubit.dart';
import 'package:foodloop/features/store_profile/presentation/manager/store_profile_cubit/store_profile_state.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/recent_reviews_section.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/reputation_card.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/store_badges_status_row.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/store_header_card.dart';
import 'package:foodloop/features/store_profile/presentation/views/widgets/store_information_card.dart';

class StoreProfileBody extends StatelessWidget {
  const StoreProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreProfileCubit, StoreProfileState>(
      builder: (context, state) {
        if (state is StoreProfileLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (state is StoreProfileError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.paddingL.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 48.r, color: AppColors.error),
                  SizedBox(height: AppConstants.paddingM.h),
                  Text(
                    AppStrings.storeLoadingError,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: AppConstants.paddingM.h),
                  TextButton.icon(
                    onPressed: () =>
                        context.read<StoreProfileCubit>().fetchStoreProfile(
                              (context
                                      .read<StoreProfileCubit>()
                                      .state as StoreProfileError)
                                  .message,
                            ),
                    icon: const Icon(Icons.refresh_rounded,
                        color: AppColors.primary),
                    label: Text(
                      AppStrings.retry,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontFamily: 'DmSans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is StoreProfileLoaded) {
          return ListView(
            padding: EdgeInsets.only(bottom: AppConstants.paddingXL.h),
            children: [
              StoreHeaderCard(store: state.store),
              SizedBox(height: AppConstants.paddingM.h),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.screenHorizontalPadding.w),
                child: Column(
                  children: [
                    StoreBadgesStatusRow(store: state.store),
                    SizedBox(height: AppConstants.paddingM.h),
                    ReputationCard(store: state.store),
                    SizedBox(height: AppConstants.paddingM.h),
                    StoreInformationCard(store: state.store),
                    SizedBox(height: AppConstants.paddingM.h),
                    RecentReviewsSection(state: state),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
