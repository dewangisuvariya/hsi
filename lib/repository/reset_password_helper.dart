import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordResetService {
  Future<PasswordResetResponse> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse(
        'https://hsi.realrisktakers.com/api/reset-password',
      ).replace(
        queryParameters: {
          'email': email,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return PasswordResetResponse.fromJson(jsonResponse);
      } else {
        // Handle different status codes appropriately
        final errorResponse = json.decode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to reset password');
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid server response: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

Future<PasswordResetResponse> resetPassword({
  required String email,
  required String newPassword,
  required String confirmPassword,
}) async {
  try {
    final url = Uri.parse(
      'https://hsi.realrisktakers.com/api/reset-password',
    ).replace(
      queryParameters: {
        'email': email,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return PasswordResetResponse.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to reset password: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error resetting password: $e');
  }
}

class PasswordResetResponse {
  final bool success;
  final String message;

  PasswordResetResponse({required this.success, required this.message});

  factory PasswordResetResponse.fromJson(Map<String, dynamic> json) {
    return PasswordResetResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
