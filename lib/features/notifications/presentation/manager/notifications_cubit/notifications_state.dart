import 'package:equatable/equatable.dart';
import 'package:foodloop/features/notifications/data/models/notification_model.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;

  /// Set when a mark-as-read call failed; the list has already been rolled back.
  final String? actionError;

  const NotificationsLoaded({
    required this.notifications,
    this.actionError,
  });

  int get unreadCount =>
      notifications.where((item) => !item.isRead).length;

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    String? actionError,
    bool clearActionError = false,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      actionError: clearActionError ? null : actionError ?? this.actionError,
    );
  }

  @override
  List<Object?> get props => [notifications, actionError];
}

class NotificationsFail extends NotificationsState {
  final String message;
  const NotificationsFail({required this.message});

  @override
  List<Object?> get props => [message];
}
