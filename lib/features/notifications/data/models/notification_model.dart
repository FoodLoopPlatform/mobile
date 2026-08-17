import 'package:equatable/equatable.dart';
import 'package:foodloop/core/utils/app_strings.dart';

/// Drives the tile's icon and accent colour.
enum NotificationType {
  order,
  offer,
  system;

  static NotificationType fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'order':
        return NotificationType.order;
      case 'offer':
        return NotificationType.offer;
      default:
        return NotificationType.system;
    }
  }
}

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.type = NotificationType.system,
    this.isRead = false,
  });

  /// Key names aren't pinned to an endpoint yet, so the usual spellings are
  /// accepted — see the note in `sample_notifications.dart`.
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? json['subject'] ?? '',
      body: json['body'] ?? json['message'] ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
              DateTime.now(),
      type: NotificationType.fromString(json['type']?.toString()),
      isRead: json['isRead'] ?? false,
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }

  bool get isToday {
    final now = DateTime.now();
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  /// Coarse relative time — enough for a feed, and avoids pulling in `intl`.
  String get relativeTime {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return AppStrings.timeJustNow;
    if (diff.inMinutes < 60) {
      return AppStrings.timeMinutesAgo.replaceFirst('%', '${diff.inMinutes}');
    }
    if (diff.inHours < 24) {
      return AppStrings.timeHoursAgo.replaceFirst('%', '${diff.inHours}');
    }
    return AppStrings.timeDaysAgo.replaceFirst('%', '${diff.inDays}');
  }

  @override
  List<Object?> get props => [id, title, body, createdAt, type, isRead];
}
