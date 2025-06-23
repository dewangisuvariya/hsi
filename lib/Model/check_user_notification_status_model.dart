// class NotificationResponse {
//   final bool success;
//   final String message;
//   final NotificationData data;

//   NotificationResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   factory NotificationResponse.fromJson(Map<String, dynamic> json) {
//     return NotificationResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: NotificationData.fromJson(json['data'] ?? {}),
//     );
//   }
// }

// class NotificationData {
//   final int userId;
//   final int count;
//   final List<Notification> notifications;

//   NotificationData({
//     required this.userId,
//     required this.count,
//     required this.notifications,
//   });

//   factory NotificationData.fromJson(Map<String, dynamic> json) {
//     var notificationsList = json['notifications'] as List? ?? [];
//     return NotificationData(
//       userId: json['user_id'] ?? 0,
//       count: json['count'] ?? 0,
//       notifications:
//           notificationsList
//               .map((notification) => Notification.fromJson(notification))
//               .toList(),
//     );
//   }
// }

// class Notification {
//   final int notificationId;
//   final String message;
//   final String icon;
//   final String url;
//   final int isRead;

//   Notification({
//     required this.notificationId,
//     required this.message,
//     required this.icon,
//     required this.url,
//     required this.isRead,
//   });

//   factory Notification.fromJson(Map<String, dynamic> json) {
//     return Notification(
//       notificationId: json['notification_id'] ?? 0,
//       message: json['message'] ?? '',
//       icon: json['icon'] ?? '',
//       url: json['url'] ?? '',
//       isRead: json['is_read'] ?? 0,
//     );
//   }
//   bool get isReadBool => isRead == 1;
// }
class NotificationResponse {
  final bool success;
  final String message;
  final NotificationData data;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationData {
  final int userId;
  final int count;
  final List<Notification> notifications;

  NotificationData({
    required this.userId,
    required this.count,
    required this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    var notificationsList = json['notifications'] as List? ?? [];
    return NotificationData(
      userId: json['user_id'] ?? 0,
      count: json['count'] ?? 0,
      notifications:
          notificationsList
              .map((notification) => Notification.fromJson(notification))
              .toList(),
    );
  }
}

class Notification {
  final int notificationId;
  final String message;
  final String icon;
  final String url;
  final int isRead;

  Notification({
    required this.notificationId,
    required this.message,
    required this.icon,
    required this.url,
    required this.isRead,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notification_id'] ?? 0,
      message: json['message'] ?? '',
      icon: json['icon'] ?? '',
      url: json['url'] ?? '',
      isRead: json['is_read'] ?? 0,
    );
  }

  bool get isReadBool => isRead == 1;
}
