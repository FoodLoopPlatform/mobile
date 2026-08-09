import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_cubit.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_state.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_body.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationCubit, LocalizationState>(
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.profileTitle,
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_rounded,
                color: AppColors.textSecondary,
                size: 24.r,
              ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
        body: ProfileBody(),
      ),
    );
  }
}
