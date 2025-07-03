import 'dart:convert';
import 'package:hsi/Model/log_activity_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogActivityApiHelper {
  static const String _baseUrl = "https://hsi.realrisktakers.com/api";

  static Future<LogActivityResponse?> logUserActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) {
        print("❌ No user_id found in SharedPreferences.");
        return null;
      }

      final Uri url = Uri.parse("$_baseUrl/log-activity?user_id=$userId");

      final response = await http.post(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return LogActivityResponse.fromJson(json);
      } else {
        print("❌ Failed to log activity. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error while logging activity: $e");
    }

    return null;
  }
}
