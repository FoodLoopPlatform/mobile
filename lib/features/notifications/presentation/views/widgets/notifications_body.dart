import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/app_strings.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_state.dart';
import 'package:foodloop/features/notifications/presentation/views/widgets/notification_tile.dart';

class NotificationsBody extends StatefulWidget {
  const NotificationsBody({super.key});

  @override
  State<NotificationsBody> createState() => _NotificationsBodyState();
}

class _NotificationsBodyState extends State<NotificationsBody> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsLoaded && state.actionError != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.actionError!)));
        }
      },
      builder: (context, state) {
        if (state is NotificationsFail) {
          return _ErrorState(
            message: state.message,
            onRetry: () => context.read<NotificationsCubit>().loadNotifications(
                  forceRefresh: true,
                ),
          );
        }

        if (state is! NotificationsLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.notifications.isEmpty) return const _EmptyState();

        final cubit = context.read<NotificationsCubit>();
        final today = state.notifications
            .where((item) => item.isToday)
            .toList(growable: false);
        final earlier = state.notifications
            .where((item) => !item.isToday)
            .toList(growable: false);

        return RefreshIndicator(
          onRefresh: () => cubit.loadNotifications(forceRefresh: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingM.h,
              AppConstants.screenHorizontalPadding.w,
              AppConstants.paddingL.h,
            ),
            children: [
              if (state.unreadCount > 0)
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton.icon(
                    onPressed: cubit.markAllAsRead,
                    icon: Icon(Icons.done_all_rounded,
                        size: 18.r, color: AppColors.primary),
                    label: Text(
                      AppStrings.notificationsMarkAllRead,
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

              if (today.isNotEmpty) ...[
                _SectionCaption(AppStrings.notificationsToday),
                SizedBox(height: AppConstants.paddingS.h),
                for (final item in today) ...[
                  NotificationTile(
                    notification: item,
                    onTap: () => cubit.markAsRead(item.id),
                  ),
                  SizedBox(height: AppConstants.paddingS.h),
                ],
                SizedBox(height: AppConstants.paddingS.h),
              ],

              if (earlier.isNotEmpty) ...[
                _SectionCaption(AppStrings.notificationsEarlier),
                SizedBox(height: AppConstants.paddingS.h),
                for (final item in earlier) ...[
                  NotificationTile(
                    notification: item,
                    onTap: () => cubit.markAsRead(item.id),
                  ),
                  SizedBox(height: AppConstants.paddingS.h),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionCaption extends StatelessWidget {
  const _SectionCaption(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'DmSans',
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: AppColors.outline,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingXL.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none_rounded,
                size: 56.r, color: AppColors.outlineVariant),
            SizedBox(height: AppConstants.paddingM.h),
            Text(
              AppStrings.notificationsEmptyTitle,
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              AppStrings.notificationsEmptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'DmSans',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

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
            Icon(Icons.error_outline_rounded,
                size: 40.r, color: AppColors.error),
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
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retry,
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
