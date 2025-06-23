import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api/';

  // Enhanced GET request handler
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

  // Response handler
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

  // Verify OTP for forgot password
  static Future<VerificationResponse> verifyForgotPasswordCode({
    required String email,
    required String code,
  }) async {
    try {
      // Validate inputs
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Please enter a valid email address');
      }
      if (code.isEmpty || code.length != 4) {
        throw Exception('Please enter a valid 4-digit code');
      }

      final response = await _get(
        'verify-forgot-code?email=${Uri.encodeComponent(email)}&code=${Uri.encodeComponent(code)}',
      );

      return VerificationResponse.fromJson(response);
    } catch (e) {
      throw Exception('Failed to verify code: ${e.toString()}');
    }
  }
}

class VerificationResponse {
  final bool isSuccess;
  final String? errorMessage;

  VerificationResponse({required this.isSuccess, this.errorMessage});

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      isSuccess: json['success'] ?? false,
      errorMessage: json['message'],
    );
  }
}
