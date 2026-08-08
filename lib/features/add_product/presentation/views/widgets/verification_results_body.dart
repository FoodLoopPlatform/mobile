import 'package:flutter/material.dart';
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

  int get _verifiedUnits =>
      batches.fold(0, (sum, batch) => sum + batch.quantity);

  /// Units from step 1 that no batch accounts for. Never negative — entering
  /// more units across batches than the original quantity isn't an "issue".
  int get _unverifiedUnits {
    final remaining = draft.quantity - _verifiedUnits;
    return remaining > 0 ? remaining : 0;
  }

  int get _verificationRate {
    if (draft.quantity <= 0) return 0;
    final rate = (_verifiedUnits / draft.quantity) * 100;
    return rate.clamp(0, 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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

                // --- Total verified ---
                _TotalVerifiedCard(units: _verifiedUnits),
                SizedBox(height: AppConstants.paddingL.h),

                // --- Verified batches ---
                if (batches.isNotEmpty) ...[
                  _SectionCaption(AppStrings.verifiedBatchesTitle),
                  SizedBox(height: AppConstants.paddingS.h),
                  for (var index = 0; index < batches.length; index++) ...[
                    VerifiedBatchTile(batch: batches[index], index: index),
                    SizedBox(height: AppConstants.paddingS.h),
                  ],
                  SizedBox(height: AppConstants.paddingS.h),
                ],

                // --- Issues (only when units are unaccounted for) ---
                if (_unverifiedUnits > 0) ...[
                  _SectionCaption(AppStrings.issuesTitle),
                  SizedBox(height: AppConstants.paddingS.h),
                  _IssueCard(
                    unverifiedUnits: _unverifiedUnits,
                    onRetake: onRetake,
                  ),
                  SizedBox(height: AppConstants.paddingL.h),
                ],

                // --- Verification rate ---
                _VerificationRateCard(rate: _verificationRate),
              ],
            ),
          ),
        ),

        // --- Bottom actions ---
        _ResultsActionBar(
          onSaveDraft: () => Navigator.pop(context),
          onPublish: () {},
        ),
      ],
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

class _TotalVerifiedCard extends StatelessWidget {
  const _TotalVerifiedCard({required this.units});

  final int units;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.totalVerifiedLabel,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '$units ${AppStrings.unitsWord}',
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48.r,
            height: 48.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondaryContainer,
            ),
            child: Icon(
              Icons.verified_rounded,
              size: 24.r,
              color: AppColors.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.unverifiedUnits, required this.onRetake});

  final int unverifiedUnits;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.error,
            ),
            child: Icon(
              Icons.no_photography_outlined,
              size: 20.r,
              color: AppColors.textOnPrimary,
            ),
          ),
          SizedBox(width: AppConstants.paddingS.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppStrings.issueUnverifiedTitle}: $unverifiedUnits',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onErrorContainer,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.issueUnverifiedMessage,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    color: AppColors.onErrorContainer,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: AppConstants.paddingS.h),
                GestureDetector(
                  onTap: onRetake,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingM.w,
                      vertical: AppConstants.paddingS.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusM.r,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 16.r,
                          color: AppColors.textOnPrimary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppStrings.retakeImage,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
              Expanded(
                child: CustomOutlinedButton(
                  label: AppStrings.saveAsDraft,
                  onTap: onSaveDraft,
                ),
              ),
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
