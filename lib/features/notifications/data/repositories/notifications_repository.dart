import 'package:dio/dio.dart';
import '../../../../core/errors/errors.dart';
import '../data_sources/notifications_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationsRepository {
  final NotificationsRemoteDataSource _remoteDataSource;

  NotificationsRepository(this._remoteDataSource);

  List<NotificationModel>? _cached;

  List<NotificationModel> get cached => _cached ?? const [];

  Future<List<NotificationModel>> getNotifications({
    bool forceRefresh = false,
  }) {
    return _guard(() async {
      if (_cached != null && !forceRefresh) return _cached!;
      _cached = await _remoteDataSource.getNotifications();
      return _cached!;
    });
  }

  Future<void> markAsRead(String id) {
    return _guard(() async {
      await _remoteDataSource.markAsRead(id);
      _cached = [
        for (final item in cached)
          if (item.id == id) item.copyWith(isRead: true) else item,
      ];
    });
  }

  Future<void> markAllAsRead() {
    return _guard(() async {
      await _remoteDataSource.markAllAsRead();
      _cached = [for (final item in cached) item.copyWith(isRead: true)];
    });
  }

  void clearCache() => _cached = null;

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      throw ServerError.fromDioError(e);
    } catch (e) {
      if (e is Errors) rethrow;
      throw ServerError('Unknown error occurred');
    }
  }
}
