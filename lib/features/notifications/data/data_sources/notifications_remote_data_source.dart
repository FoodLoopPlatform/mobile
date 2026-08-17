import '../../../../core/api_helper/api_constants.dart';
import '../../../../core/api_helper/api_manager.dart';
import '../../../../core/api_helper/api_response.dart';
import '../../../../core/errors/errors.dart';
import '../models/notification_model.dart';

class NotificationsRemoteDataSource {
  final ApiManager _apiManager;

  NotificationsRemoteDataSource(this._apiManager);

  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiManager.get(ApiConstants.notificationsEndpoint);
    return _parseList(response.data);
  }

  /// `PATCH /notifications/{id}/read`
  Future<void> markAsRead(String id) async {
    final response =
        await _apiManager.patch(ApiConstants.notificationReadEndpoint(id));
    _ensureSuccess(response.data);
  }

  /// `PATCH /notifications/read-all`
  Future<void> markAllAsRead() async {
    final response =
        await _apiManager.patch(ApiConstants.notificationsReadAllEndpoint);
    _ensureSuccess(response.data);
  }

  /// Accepts a bare array or the usual `{success, data}` envelope, since the
  /// notifications response shape isn't documented.
  List<NotificationModel> _parseList(dynamic body) {
    if (body is List) return _mapList(body);

    if (body is Map<String, dynamic>) {
      final parsed = ApiResponse<List<NotificationModel>>.fromJson(
        body,
        (json) => _mapList(json),
      );
      if (!parsed.success) throw ServerError(parsed.errorMessage);
      return parsed.data ?? const [];
    }

    throw ServerError('Unexpected response from the server');
  }

  List<NotificationModel> _mapList(dynamic json) {
    // Some APIs nest the page under `items`/`data`.
    if (json is Map<String, dynamic>) {
      final nested = json['items'] ?? json['data'] ?? json['notifications'];
      if (nested is List) return _mapList(nested);
      return const [];
    }
    if (json is! List) return const [];
    return json
        .whereType<Map<String, dynamic>>()
        .map(NotificationModel.fromJson)
        .toList(growable: false);
  }

  /// Write endpoints may answer with an empty body — only an explicit
  /// `success: false` counts as a failure.
  void _ensureSuccess(dynamic body) {
    if (body is! Map<String, dynamic>) return;
    final parsed = ApiResponse<dynamic>.fromJson(body, (json) => json);
    if (!parsed.success) throw ServerError(parsed.errorMessage);
  }
}
