import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    // Captured up front — `context` is gone once we navigate away.
    final authCubit = context.read<AuthCubit>();
    final profileCubit = context.read<ProfileCubit>();
    final notificationsCubit = context.read<NotificationsCubit>();
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          AppStrings.logout,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          AppStrings.logoutConfirmMessage,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppStrings.logout,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await authCubit.logout();
    // Wipe the cached profile/addresses so the next sign-in starts clean.
    profileCubit.reset();
    notificationsCubit.reset();

    navigator.pushNamedAndRemoveUntil(
      RoutesNames.loginView,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: BorderSide(color: AppColors.error.withValues(alpha: 0.4)),
          padding: EdgeInsets.symmetric(vertical: AppConstants.paddingM.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
          ),
        ),
        icon: Icon(Icons.logout_rounded, size: 20.r, color: AppColors.error),
        label: Text(
          AppStrings.logout,
          style: TextStyle(
            fontFamily: 'DmSans',
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
