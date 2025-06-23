import 'dart:convert';
import 'package:hsi/Model/email_verification_model.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api/';

  static Future<EmailVerificationResponse> verifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      final url = Uri.parse('${_baseUrl}verify-email?email=$email&otp=$otp');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return EmailVerificationResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to verify email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error verifying email: $e');
    }
  }

  // static Future<EmailVerificationResponse> resendEmailOtp({required String email}) async {
  //   final url = Uri.parse(
  //     'https://hsi.realrisktakers.com/api/verify-email?email=$email',
  //   );

  //   final response = await http.get(url);

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return EmailVerificationResponse.fromJson(json);
  //   } else {
  //     return EmailVerificationResponse(success: false, message: 'Failed to resend OTP');
  //   }
  // }
}
