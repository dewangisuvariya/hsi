import 'dart:convert';
import 'package:hsi/Model/user_notifications_mark_as_read_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<MarkNotificationReadResponse?> markNotificationAsRead(
    int notificationId,
  ) async {
    final userId = await getUserId();
    if (userId == null) {
      print('User ID not found in SharedPreferences.');
      return null;
    }

    final url = Uri.parse(
      'https://hsi.realrisktakers.com/api/notification/mark-read?user_id=$userId&notification_id=$notificationId',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MarkNotificationReadResponse.fromJson(jsonData);
      } else {
        print(
          'Failed to mark notification as read. Status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('Error marking notification as read: $e');
      return null;
    }
  }
}
