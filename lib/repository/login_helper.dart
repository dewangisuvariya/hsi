import 'dart:convert';
import 'package:hsi/Model/login_model.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';

  // Method to login user
  static Future<LoginResponse> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Construct the URL with query parameters
      final url = Uri.parse(
        '$_baseUrl/login-user',
      ).replace(queryParameters: {'email': email, 'password': password});

      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Add any other required headers here
          // 'Authorization': 'Bearer your_token',
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        final jsonResponse = json.decode(response.body);
        return LoginResponse.fromJson(jsonResponse);
      } else {
        // Handle server errors
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      throw Exception('Failed to login: $e');
    }
  }
}
