class SupportMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final String? attachment;
  final DateTime createdAt;

  const SupportMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    this.attachment,
    required this.createdAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String? ?? '',
      message: json['message'] as String,
      attachment: json['attachment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class SupportTicketModel {
  final String id;
  final String userId;
  final String userEmail;
  final String userFullName;
  final String category;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  // Only populated in detail view (GET /support-tickets/{id})
  final List<SupportMessageModel>? messages;

  const SupportTicketModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.userFullName,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.messages,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String? ?? '',
      userFullName: json['userFullName'] as String? ?? '',
      category: json['category'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      messages: json['messages'] != null
          ? (json['messages'] as List<dynamic>)
              .map((e) =>
                  SupportMessageModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
