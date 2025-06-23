import 'dart:convert';
import 'package:hsi/Model/resend_verification_model.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api/';

  // Enhanced GET request handler with timeout and headers
  static Future<dynamic> _get(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 30));

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on Exception catch (e) {
      throw Exception('Request failed: $e');
    }
  }

  // Improved response handler with detailed error messages
  static dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized: ${response.body}');
      case 403:
        throw Exception('Forbidden: ${response.body}');
      case 404:
        throw Exception('Not found: ${response.body}');
      case 500:
        throw Exception('Server error: ${response.body}');
      default:
        throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  // Forgot password method with improved error handling
  static Future<ResendVerificationResponse> forgotPassword(String email) async {
    try {
      // Validate email before making the request
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email address');
      }

      final response = await _get(
        'forgot-password?email=${Uri.encodeComponent(email)}',
      );

      if (response is Map<String, dynamic>) {
        return ResendVerificationResponse.fromJson(response);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to send reset code: ${e.toString()}');
    }
  }
}
