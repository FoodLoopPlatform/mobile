import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_outlined_button.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/add_product_step_indicator.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/verified_batch_tile.dart';
import 'package:foodloop/features/add_product/presentation/manager/add_product_cubit/add_product_cubit.dart';
import 'package:foodloop/features/add_product/presentation/manager/add_product_cubit/add_product_state.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';

class VerificationResultsBody extends StatelessWidget {
  const VerificationResultsBody({
    super.key,
    required this.draft,
    required this.batches,
    required this.onRetake,
  });

  final ProductDraft draft;
  final List<ExpirationBatch> batches;
  final VoidCallback onRetake;

  int get _verificationRate {
    if (batches.isEmpty) return 0;
    final totalConfidence = batches.fold(
      0.0,
      (sum, batch) => sum + batch.confidenceScore,
    );
    return ((totalConfidence / batches.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          // Success, go back to main nav
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product published successfully!')),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesNames.mainNav,
            (route) => false,
          );
          context.read<AddProductCubit>().resetState();
        } else if (state is AddProductFail) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AddProductLoading;
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
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
                          step: 3,
                          stepName: AppStrings.resultsStepName,
                        ),
                        SizedBox(height: AppConstants.paddingL.h),

                        Text(
                          AppStrings.resultsTitle,
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          AppStrings.resultsSubtitle,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: AppConstants.paddingL.h),

                        // --- Verified batches ---
                        // if (batches.isNotEmpty) ...[
                        //   _SectionCaption(AppStrings.verifiedBatchesTitle),
                        //   SizedBox(height: AppConstants.paddingS.h),
                        //   for (
                        //     var index = 0;
                        //     index < batches.length;
                        //     index++
                        //   ) ...[
                        //     VerifiedBatchTile(
                        //       batch: batches[index],
                        //       index: index,
                        //     ),
                        //     SizedBox(height: AppConstants.paddingS.h),
                        //   ],
                        //   SizedBox(height: AppConstants.paddingS.h),
                        // ],

                        // --- Verification rate ---
                        _VerificationRateCard(rate: _verificationRate),
                      ],
                    ),
                  ),
                ),

                // --- Bottom actions ---
                _ResultsActionBar(
                  onSaveDraft: () => Navigator.pop(context),
                  onPublish: isLoading
                      ? () {}
                      : () {
                          context.read<AddProductCubit>().publishProducts(
                            draft,
                            batches,
                          );
                        },
                ),
              ],
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'DmSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.outline,
      ),
    );
  }
}

class _VerificationRateCard extends StatelessWidget {
  const _VerificationRateCard({required this.rate});

  final int rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.tertiarySurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.verificationRateLabel,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.tertiary,
            ),
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$rate',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 44.sp,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: AppColors.tertiary,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Text(
                  '%',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppConstants.paddingS.h),
          Text(
            AppStrings.verificationRateHint,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 12.sp,
              color: AppColors.tertiary,
              height: 1.4,
            ),
          ),
          if (rate < 80) ...[
            SizedBox(height: AppConstants.paddingM.h),
            Container(
              padding: EdgeInsets.all(AppConstants.paddingS.r),
              decoration: BoxDecoration(
                color: AppColors.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16.r,
                    color: AppColors.error,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      AppStrings.ocrReviewWarning,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsActionBar extends StatelessWidget {
  const _ResultsActionBar({required this.onSaveDraft, required this.onPublish});

  final VoidCallback onSaveDraft;
  final VoidCallback onPublish;

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
          child: Row(
            children: [
              // Expanded(
              //   child: CustomOutlinedButton(
              //     label: AppStrings.saveAsDraft,
              //     onTap: onSaveDraft,
              //   ),
              // ),
              SizedBox(width: AppConstants.paddingS.w),
              Expanded(
                flex: 2,
                child: CustomButton(
                  label: AppStrings.confirmAndPublish,
                  suffixIcon: Icons.publish_rounded,
                  onTap: onPublish,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
