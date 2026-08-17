import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/core/utils/constants.dart';
import 'package:foodloop/features/notifications/data/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationModel notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppConstants.paddingM.r),
        decoration: BoxDecoration(
          // Unread reads as a filled card; read ones recede.
          color: isUnread ? AppColors.surface : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppConstants.radiusL.r),
          border: Border.all(
            color: isUnread
                ? AppColors.primary.withValues(alpha: 0.25)
                : AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: _background,
                borderRadius: BorderRadius.circular(AppConstants.radiusM.r),
              ),
              child: Icon(_icon, size: 20.r, color: _foreground),
            ),
            SizedBox(width: AppConstants.paddingS.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            fontSize: 14.sp,
                            fontWeight:
                                isUnread ? FontWeight.w700 : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isUnread) ...[
                        SizedBox(width: 6.w),
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.relativeTime,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10.sp,
                      color: AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.order:
        return Icons.receipt_long_rounded;
      case NotificationType.offer:
        return Icons.local_offer_rounded;
      case NotificationType.system:
        return Icons.info_rounded;
    }
  }

  Color get _background {
    switch (notification.type) {
      case NotificationType.order:
        return AppColors.primarySurface;
      case NotificationType.offer:
        return AppColors.tertiarySurface;
      case NotificationType.system:
        return AppColors.surfaceContainerHigh;
    }
  }

  Color get _foreground {
    switch (notification.type) {
      case NotificationType.order:
        return AppColors.primary;
      case NotificationType.offer:
        return AppColors.tertiary;
      case NotificationType.system:
        return AppColors.textSecondary;
    }
  }
}
