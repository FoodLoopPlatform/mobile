import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodloop/core/errors/errors.dart';
import 'package:foodloop/features/notifications/data/repositories/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(const NotificationsInitial());

  Future<void> loadNotifications({bool forceRefresh = false}) async {
    emit(const NotificationsLoading());
    try {
      final notifications = await _repository.getNotifications(
        forceRefresh: forceRefresh,
      );
      emit(NotificationsLoaded(notifications: notifications));
    } on Errors catch (e) {
      emit(NotificationsFail(message: e.errMessage));
    } catch (e) {
      emit(NotificationsFail(message: e.toString()));
    }
  }

  /// Loads once. Safe to call from every widget that needs the unread count.
  Future<void> loadIfNeeded() async {
    if (state is NotificationsInitial) await loadNotifications();
  }

  Future<void> markAsRead(String id) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    final target = current.notifications.where((item) => item.id == id);
    // Already read — no need to spend a request on it.
    if (target.isEmpty || target.first.isRead) return;

    final optimistic = [
      for (final item in current.notifications)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ];
    emit(current.copyWith(notifications: optimistic, clearActionError: true));

    await _write(current, () => _repository.markAsRead(id));
  }

  Future<void> markAllAsRead() async {
    final current = state;
    if (current is! NotificationsLoaded) return;
    if (current.unreadCount == 0) return;

    final optimistic = [
      for (final item in current.notifications) item.copyWith(isRead: true),
    ];
    emit(current.copyWith(notifications: optimistic, clearActionError: true));

    await _write(current, () => _repository.markAllAsRead());
  }

  /// Clears the feed on logout so the next user doesn't inherit it.
  void reset() {
    _repository.clearCache();
    emit(const NotificationsInitial());
  }

  /// Restores [previous] with the error attached when a write fails, so the
  /// optimistic change is rolled back rather than left half-applied.
  Future<void> _write(
    NotificationsLoaded previous,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } on Errors catch (e) {
      emit(previous.copyWith(actionError: e.errMessage));
    } catch (e) {
      emit(previous.copyWith(actionError: e.toString()));
    }
  }
}
