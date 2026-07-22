import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_personal_info_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_preferences_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_saved_addresses_card.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppConstants.screenHorizontalPadding.w,
        AppConstants.paddingS.h,
        AppConstants.screenHorizontalPadding.w,
        AppConstants.paddingL.h,
      ),
      child: Column(
        children: [
          const ProfilePersonalInfoCard(),
          SizedBox(height: AppConstants.paddingM.h),
          const ProfilePreferencesCard(),
          SizedBox(height: AppConstants.paddingM.h),
          const ProfileSavedAddressesCard(),
        ],
      ),
    );
  }
}
