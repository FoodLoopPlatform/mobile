import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';

/// "Step 1 of 3" caption plus the progress track above the form.
class AddProductStepIndicator extends StatelessWidget {
  const AddProductStepIndicator({
    super.key,
    this.step = 1,
    this.totalSteps = 3,
  });

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.addProductStepLabel,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.primary,
              ),
            ),
            Text(
              AppStrings.addProductStepName,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
        SizedBox(height: AppConstants.paddingS.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusFull.r),
          child: LinearProgressIndicator(
            value: step / totalSteps,
            minHeight: 4.h,
            backgroundColor: AppColors.surfaceContainerHighest,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
