import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../utils/app_strings.dart';
import '../utils/constants.dart';
import 'custom_button.dart';

/// Full-screen offline / connection-lost state with a retry action.
///
/// Drop it in as a body (or inside any container) when a request fails on a
/// network error: `ConnectionLostView(onRetry: cubit.load)`.
class ConnectionLostView extends StatelessWidget {
  const ConnectionLostView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppConstants.screenHorizontalPadding.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _OfflineIllustration(),
            SizedBox(height: AppConstants.paddingXL.h),

            // --- Status chip ---
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
              ),
              child: Text(
                AppStrings.systemStatusOffline,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.onTertiaryContainer,
                ),
              ),
            ),
            SizedBox(height: AppConstants.paddingM.h),

            // --- Title ---
            Text(
              AppStrings.connectionLostTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppConstants.paddingS.h),

            // --- Subtitle ---
            Text(
              AppStrings.connectionLostSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 15.sp,
                height: 1.6,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppConstants.paddingL.h),

            // --- Retry ---
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 280.w),
              child: CustomButton(
                label: AppStrings.retry,
                suffixIcon: Icons.refresh_rounded,
                color: AppColors.primaryLight,
                onTap: onRetry,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflineIllustration extends StatelessWidget {
  const _OfflineIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240.r,
      height: 240.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // --- Soft glow ---
          Container(
            width: 220.r,
            height: 220.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.secondaryContainer.withValues(alpha: 0.35),
                  AppColors.secondaryContainer.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // --- Organic blob ---
          Container(
            width: 200.r,
            height: 200.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(80.r),
                bottomRight: Radius.circular(40.r),
                bottomLeft: Radius.circular(120.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off_rounded,
                    size: 72.r, color: AppColors.tertiary),
                SizedBox(height: AppConstants.paddingS.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Dot(color: AppColors.error),
                    SizedBox(width: 6.w),
                    _Dot(color: AppColors.outlineVariant),
                    SizedBox(width: 6.w),
                    _Dot(color: AppColors.outlineVariant),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.r,
      height: 8.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
