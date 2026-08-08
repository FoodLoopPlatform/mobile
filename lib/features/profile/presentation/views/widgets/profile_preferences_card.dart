import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/core/widgets/custom_switch.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_section_title.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_cubit.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_state.dart';

class ProfilePreferencesCard extends StatelessWidget {
  const ProfilePreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileSectionTitle(title: AppStrings.preferencesTitle),
          SizedBox(height: AppConstants.paddingM.h),

          // --- Language ---
          const _LanguageRow(),
          SizedBox(height: AppConstants.paddingM.h),

          // --- Notifications ---
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Text(
              AppStrings.notificationsLabel.toUpperCase(),
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.outline,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          _NotificationRow(label: AppStrings.orderUpdatesLabel, enabled: true),
          _NotificationRow(label: AppStrings.latestOffersLabel, enabled: false),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingS.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.language_rounded,
            size: 22.r,
            color: AppColors.primaryLight,
          ),
          SizedBox(width: 12.w),
          Text(
            AppStrings.languageLabel,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          const _LanguageSelector(),
        ],
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppConstants.radiusS.r),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    context.read<LocalizationCubit>().changeLanguage('en'),
                child: _LanguageChip(
                  label: AppStrings.languageEn,
                  selected: state.locale == 'en',
                ),
              ),
              GestureDetector(
                onTap: () =>
                    context.read<LocalizationCubit>().changeLanguage('ar'),
                child: _LanguageChip(
                  label: AppStrings.languageAr,
                  selected: state.locale == 'ar',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppConstants.radiusS.r - 2),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'DmSans',
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'DmSans',
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
          CustomSwitch(value: enabled),
        ],
      ),
    );
  }
}
