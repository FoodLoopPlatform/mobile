import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_state.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_personal_info_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_preferences_card.dart';
import 'package:foodloop/features/profile/presentation/views/widgets/profile_saved_addresses_card.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && state.actionError != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.actionError!)));
        }
      },
      builder: (context, state) {
        if (state is ProfileFail) {
          return _ProfileError(
            message: state.message,
            onRetry: () => context.read<ProfileCubit>().loadProfile(),
          );
        }

        if (state is! ProfileLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: () =>
              context.read<ProfileCubit>().loadProfile(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingS.h,
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingL.h,
            ),
            child: Column(
              children: [
                ProfilePersonalInfoCard(profile: state.profile),
                SizedBox(height: AppConstants.paddingM.h),
                const ProfilePreferencesCard(),
                SizedBox(height: AppConstants.paddingM.h),
                ProfileSavedAddressesCard(addresses: state.addresses),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingL.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 40.r, color: AppColors.error),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
