import 'dart:convert';
import 'package:hsi/Model/resend_verification_model.dart';
import 'package:http/http.dart' as http;

class VerificationApi {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';
  // create user
  static Future<ResendVerificationResponse> resendVerificationCode(
    String email,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/resend-verification-code?email=$email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ResendVerificationResponse.fromJson(json.decode(response.body));
      } else {
        // Handle different status codes if needed
        return ResendVerificationResponse(
          success: false,
          message: 'Failed to resend code. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ResendVerificationResponse(success: false, message: 'Error: $e');
    }
  }

  // update profile
  static Future<ResendVerificationResponse> resendVerificationCodeProfile(
    String email,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_baseUrl/resend-verification-code-update-profile?email=$email',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ResendVerificationResponse.fromJson(json.decode(response.body));
      } else {
        // Handle different status codes if needed
        return ResendVerificationResponse(
          success: false,
          message: 'Failed to resend code. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ResendVerificationResponse(success: false, message: 'Error: $e');
    }
  }
  // forgot password

  static Future<ResendVerificationResponse>
  resendVerificationCodeForgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_baseUrl/resend-verification-code-forgot-password?email=$email',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return ResendVerificationResponse.fromJson(json.decode(response.body));
      } else {
        // Handle different status codes if needed
        return ResendVerificationResponse(
          success: false,
          message: 'Failed to resend code. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ResendVerificationResponse(success: false, message: 'Error: $e');
    }
  }
}
