import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/store_profile/data/models/store_details_model.dart';

class StoreInformationCard extends StatelessWidget {
  const StoreInformationCard({super.key, required this.store});

  final StoreDetailsModel store;

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
          Text(
            AppStrings.storeInformationTitle,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.outline,
            ),
          ),
          SizedBox(height: AppConstants.paddingM.h),

          // Description
          if (store.description.isNotEmpty) ...[
            Text(
              store.description,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                height: 1.7,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: AppConstants.paddingM.h),
            Divider(color: AppColors.border, height: 1),
            SizedBox(height: AppConstants.paddingM.h),
          ],

          _InfoRow(
            icon: Icons.location_on_rounded,
            label: AppStrings.storeAddressLabel,
            value: store.fullAddress,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          _InfoRow(
            icon: Icons.phone_rounded,
            label: AppStrings.storeContactLabel,
            value: store.phone,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          _InfoRow(
            icon: Icons.email_rounded,
            label: AppStrings.storeContactLabel,
            value: store.email,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          _InfoRow(
            icon: Icons.tag_rounded,
            label: AppStrings.storeIdLabel,
            value: store.id,
            isMonospace: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isMonospace = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isMonospace;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          ),
          child: Icon(icon, size: 14.r, color: AppColors.primary),
        ),
        SizedBox(width: AppConstants.paddingS.w),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: isMonospace ? 'JetBrainsMono' : 'DmSans',
              fontSize: isMonospace ? 11.sp : 13.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
