import 'dart:convert';
import 'package:hsi/Model/change_password_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const String baseUrl = "https://hsi.realrisktakers.com/api";

  // Method to change password
  static Future<ChangePasswordResponse> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newConfirmPassword,
  }) async {
    try {
      // Get user ID from SharedPreferences
      final userId = await getUserId();
      if (userId == null) {
        throw Exception("User not logged in");
      }

      // Construct the URL with query parameters
      final url = Uri.parse('$baseUrl/change-password').replace(
        queryParameters: {
          'user_id': userId.toString(),
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_confirm_password': newConfirmPassword,
        },
      );

      // Make POST request
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      // Check response status
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return ChangePasswordResponse.fromJson(jsonResponse);
      } else {
        final errorResponse = json.decode(response.body);
        throw Exception(
          errorResponse['message'] ?? 'Failed to change password',
        );
      }
    } catch (e) {
      throw Exception('Error changing password: ${e.toString()}');
    }
  }

  // Helper method to get user ID from SharedPreferences
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }
}
