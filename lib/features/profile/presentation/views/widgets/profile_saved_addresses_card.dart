import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_address_tile.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_section_title.dart';

class ProfileSavedAddressesCard extends StatelessWidget {
  const ProfileSavedAddressesCard({super.key, required this.addresses});

  final List<AddressModel> addresses;

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

          // --- Address list (from GET /users/me/addresses) ---
          for (final address in addresses) ...[
            ProfileAddressTile(
              icon: _iconFor(address.addressType),
              title: _titleFor(address.addressType),
              line1: address.buildingNo != null
                  ? '${address.street}, ${address.buildingNo}'
                  : address.street,
              line2: '${address.district}, ${address.city}',
              isDefault: address.isDefault,
              onEdit: () => Navigator.pushNamed(
                context,
                RoutesNames.addAddressView,
                arguments: address,
              ),
              onDelete: () =>
                  context.read<ProfileCubit>().deleteAddress(address.id),
            ),
            SizedBox(height: AppConstants.paddingS.h),
          ],
          SizedBox(height: AppConstants.paddingM.h),

          // --- Empty-state hint ---
          const _AddressesHint(),
        ],
      ),
    );
  }

  IconData _iconFor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return Icons.home_rounded;
      case AddressType.company:
        return Icons.work_outline_rounded;
      case AddressType.other:
        return Icons.place_outlined;
    }
  }

  String _titleFor(AddressType type) {
    switch (type) {
      case AddressType.home:
        return AppStrings.addressHomeTitle;
      case AddressType.company:
        return AppStrings.addressOfficeTitle;
      case AddressType.other:
        return AppStrings.addressOtherTitle;
    }
  }
}

class _AddNewButton extends StatelessWidget {
  const _AddNewButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, RoutesNames.addAddressView),
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
