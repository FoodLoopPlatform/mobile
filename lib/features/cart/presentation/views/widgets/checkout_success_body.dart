import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/cart/data/models/order_response_model.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';

class CheckoutSuccessBody extends StatelessWidget {
  final OrderResponseModel response;

  const CheckoutSuccessBody({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
          horizontal: AppConstants.screenHorizontalPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),

          // ── Thank You heading ───────────────────────────────────────────
          Text(
            AppStrings.thankYouTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              height: 1.25,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            AppStrings.thankYouSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 13.sp,
              color: AppColors.neutral,
              height: 1.5,
            ),
          ),
          SizedBox(height: 32.h),

          // ── Order Reference card ────────────────────────────────────────
          _InfoCard(
            children: [
              _CardLabel(AppStrings.orderReference),
              SizedBox(height: 8.h),
              Text(
                '#${response.orderReference ?? 'FL-0000-0000'}',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    AppStrings.placedSuccessfully,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Estimated Ready Time card ───────────────────────────────────
          _InfoCard(
            children: [
              _CardLabel(AppStrings.estimatedReadyTime),
              SizedBox(height: 8.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${response.estimatedReadyMinutes ?? 15}',
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.minutes,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 16.sp,
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // ── Pickup Details card ─────────────────────────────────────────
          if (response.pickupName != null || response.pickupAddress != null)
            _InfoCard(
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: AppColors.primary, size: 18.r),
                    SizedBox(width: 6.w),
                    Text(
                      AppStrings.pickupDetails,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (response.pickupName != null)
                  Text(
                    response.pickupName!,
                    style: TextStyle(
                      fontFamily: 'PlayfairDisplay',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                if (response.pickupAddress != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    response.pickupAddress!,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      color: AppColors.neutral,
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                // Map placeholder
                Container(
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusM.r),
                  ),
                  child: Center(
                    child: Icon(Icons.map_outlined,
                        color: AppColors.neutralLight, size: 40.r),
                  ),
                ),
              ],
            ),

          SizedBox(height: 32.h),

          // ── Back to Home button ─────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: AppConstants.buttonHeight.h,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  RoutesNames.mainNav,
                  (route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull.r),
                ),
              ),
              icon: Icon(Icons.home_outlined,
                  color: AppColors.primary, size: 20.r),
              label: Text(
                AppStrings.backToHome,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }
}

// ── Reusable card ──────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _CardLabel extends StatelessWidget {
  final String text;
  const _CardLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 10.sp,
        color: AppColors.neutral,
        letterSpacing: 0.8,
      ),
    );
  }
}
