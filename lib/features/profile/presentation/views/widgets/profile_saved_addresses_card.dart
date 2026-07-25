import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_address_tile.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_section_title.dart';

class ProfileSavedAddressesCard extends StatelessWidget {
  const ProfileSavedAddressesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionTitle(
            title: AppStrings.savedAddressesTitle,
            trailing: const _AddNewButton(),
          ),
          SizedBox(height: AppConstants.paddingM.h),

          // --- Address list ---
          const ProfileAddressTile(
            icon: Icons.home_rounded,
            title: AppStrings.addressHomeTitle,
            line1: AppStrings.addressHomeLine1,
            line2: AppStrings.addressHomeLine2,
            isDefault: true,
          ),
          SizedBox(height: AppConstants.paddingS.h),
          const ProfileAddressTile(
            icon: Icons.work_outline_rounded,
            title: AppStrings.addressOfficeTitle,
            line1: AppStrings.addressOfficeLine1,
            line2: AppStrings.addressOfficeLine2,
          ),
          SizedBox(height: AppConstants.paddingL.h),

          // --- Empty-state hint ---
          const _AddressesHint(),
        ],
      ),
    );
  }
}

class _AddNewButton extends StatelessWidget {
  const _AddNewButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 18.r, color: AppColors.textOnPrimary),
            SizedBox(width: 6.w),
            Text(
              AppStrings.addNew,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressesHint extends StatelessWidget {
  const _AddressesHint();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
          height: 1,
        ),
        SizedBox(height: AppConstants.paddingL.h),
        Opacity(
          opacity: 0.4,
          child: Column(
            children: [
              Icon(Icons.map_outlined, size: 48.r, color: AppColors.primary),
              SizedBox(height: 8.h),
              SizedBox(
                width: 200.w,
                child: Text(
                  AppStrings.addressEmptyHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    fontSize: 12.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
