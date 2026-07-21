import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_assets.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/widgets/custom_button.dart';
import 'package:foodloop/core/widgets/custom_outlined_button.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // --- Top Bar ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo
                Row(
                  children: [
                    Container(
                      width: 28.r,
                      height: 28.r,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Icon(
                        Icons.loop_rounded,
                        color: AppColors.textOnPrimary,
                        size: 16.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                // Language selector
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(20.r),
                    color: AppColors.surface,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.language_rounded,
                        size: 14.r,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.english,
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 14.r,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // --- Hero Image Area ---
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.surfaceVariant,
              ),
              child: Image.asset(AppAssets.onBoardingImage),
            ),
          ),

          // --- Text & Buttons ---
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeHeadline,
                  style: TextStyle(
                    fontFamily: 'PlayfairDisplay',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(text: 'Turning '),
                      TextSpan(
                        text: 'surplus',
                        style: TextStyle(color: AppColors.primary),
                      ),
                      TextSpan(
                        text:
                            ' into opportunity. We connect businesses with excess food to consumers looking for ',
                      ),
                      TextSpan(
                        text: 'affordable, fresh',
                        style: TextStyle(color: AppColors.tertiary),
                      ),
                      TextSpan(text: ' options in real-time.'),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  label: AppStrings.createAccount,
                  onTap: () => Navigator.pushNamed(
                    context,
                    RoutesNames.createAccountView,
                  ),
                ),
                SizedBox(height: 12.h),
                CustomOutlinedButton(
                  label: AppStrings.login,
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesNames.loginView),
                ),
                SizedBox(height: 20.h),
                // Footer
                Center(
                  child: Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
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
