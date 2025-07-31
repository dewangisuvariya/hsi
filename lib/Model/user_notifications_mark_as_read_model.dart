class MarkNotificationReadResponse {
  final bool success;
  final String message;
  final MarkNotificationReadData data;

  MarkNotificationReadResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MarkNotificationReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkNotificationReadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MarkNotificationReadData.fromJson(json['data'] ?? {}),
    );
  }
}

class MarkNotificationReadData {
  final int userId;
  final int notificationId;
  final bool isRead;

  MarkNotificationReadData({
    required this.userId,
    required this.notificationId,
    required this.isRead,
  });

  factory MarkNotificationReadData.fromJson(Map<String, dynamic> json) {
    return MarkNotificationReadData(
      userId: json['user_id'] ?? 0,
      notificationId: json['notification_id'] ?? 0,
      isRead: (json['is_read'] ?? 0) == 1,
    );
  }
}
