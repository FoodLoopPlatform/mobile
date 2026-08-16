import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/add_product/data/models/expiration_batch.dart';
import 'package:foodloop/features/add_product/presentation/views/widgets/expiration_date_field.dart';

class VerifiedBatchTile extends StatelessWidget {
  const VerifiedBatchTile({
    super.key,
    required this.batch,
    required this.index,
  });

  final ExpirationBatch batch;

  /// Zero-based position, rendered as a 1-based batch label.
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingM.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
            ),
            child: Icon(
              Icons.event_available_rounded,
              size: 20.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppConstants.paddingS.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ExpirationDateField.formatDate(batch.date),
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${batch.quantity} ${AppStrings.unitsConfirmed}',
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
            ),
            child: Text(
              '${AppStrings.batchPrefix} ${index + 1}',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
