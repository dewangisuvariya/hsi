import 'dart:convert';
import 'package:hsi/Model/check_user_notification_status_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Import the model

class NotificationApiService {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<NotificationResponse?> fetchUserNotifications() async {
    final userId = await getUserId();
    if (userId == null) {
      print('User ID not found in SharedPreferences.');
      return null;
    }

    final url = Uri.parse(
      'https://hsi.realrisktakers.com/api/fetch-user-notifications?user_id=$userId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NotificationResponse.fromJson(jsonData);
      } else {
        print(
          'Failed to load notifications. Status code: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      return null;
    }
  }
}
