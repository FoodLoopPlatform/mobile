import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_state.dart';

/// Bell action for app bars, badged with the unread count.
///
/// Stateful so it can kick off the first load — the cubit lives at app root
/// (shared with the notifications screen), and fetching there would fire before
/// the user is even signed in.
class NotificationBellButton extends StatefulWidget {
  const NotificationBellButton({super.key});

  @override
  State<NotificationBellButton> createState() => _NotificationBellButtonState();
}

class _NotificationBellButtonState extends State<NotificationBellButton> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().loadIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final unread =
            state is NotificationsLoaded ? state.unreadCount : 0;

        return IconButton(
          onPressed: () =>
              Navigator.pushNamed(context, RoutesNames.notificationsView),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_rounded,
                  size: 24.r, color: AppColors.textSecondary),
              if (unread > 0)
                PositionedDirectional(
                  top: -2,
                  end: -2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    constraints: BoxConstraints(minWidth: 16.r),
                    height: 16.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: AppColors.background, width: 1.5),
                    ),
                    child: Text(
                      unread > 9 ? '9+' : '$unread',
                      style: TextStyle(
                        fontFamily: 'DmSans',
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
