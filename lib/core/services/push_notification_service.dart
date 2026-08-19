import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/utils/app_colors.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:foodloop/main.dart';

/// Handles all Firebase Cloud Messaging logic:
/// - Requesting permission
/// - Syncing the device token with the backend after login
/// - Showing a SnackBar for foreground notifications and refreshing the badge
class PushNotificationService {
  PushNotificationService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Call once at app startup (after Firebase.initializeApp).
  static Future<void> initialize() async {
    // Request permission (iOS; on Android this is a no-op until API 33+)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground message handler — show SnackBar and refresh badge.
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  /// Posts the FCM token to the backend.
  /// Call this immediately after a successful login or on auto-login.
  static Future<void> syncDeviceToken(ApiManager apiManager) async {
    try {
      final token = await _messaging.getToken();
      if (token == null) return;

      final platform = Platform.isIOS ? 'ios' : 'android';

      await apiManager.post(
        ApiConstants.deviceTokenEndpoint,
        {
          'token': token,
          'platform': platform,
        },
      );

      debugPrint('[FCM] Device token synced: $token');
    } catch (e) {
      // Non-fatal — the user is still logged in even if token sync fails.
      debugPrint('[FCM] Device token sync failed: $e');
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final title = notification.title ?? '';
    final body = notification.body ?? '';

    // Refresh the notification badge via the globally provided cubit.
    final context = navigatorKey.currentContext;
    if (context != null) {
      try {
        context.read<NotificationsCubit>().loadNotifications(forceRefresh: true);
      } catch (_) {
        // Cubit may not be available yet (e.g., on the login screen) — safe to ignore.
      }

      // Show a top toast using Overlay
      final overlay = navigatorKey.currentState?.overlay;
      if (overlay == null) return;
      
      late OverlayEntry entry;
      entry = OverlayEntry(
        builder: (context) {
          return Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notifications_active_rounded, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'DmSans',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          if (body.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              body,
                              style: const TextStyle(
                                fontFamily: 'DmSans',
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => entry.remove(),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      overlay.insert(entry);
      Future.delayed(const Duration(seconds: 4), () {
        if (entry.mounted) {
          entry.remove();
        }
      });
    }
  }
}
