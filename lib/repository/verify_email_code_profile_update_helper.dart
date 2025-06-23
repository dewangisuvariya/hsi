import 'package:hsi/Model/email_verification_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerificationHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api/';

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<EmailVerificationResult> verifyEmail({
    required int verificationCode,
  }) async {
    final userId = await getUserId();
    if (userId == null) {
      return EmailVerificationResult.failure('User not found');
    }

    final url = Uri.parse(
      '${_baseUrl}verify-email-code?user_id=$userId&email_verification_code=$verificationCode',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final decodedResponse = EmailVerificationResponse.fromJson(
          json.decode(response.body),
        );

        if (decodedResponse.success) {
          return EmailVerificationResult.success();
        } else {
          return EmailVerificationResult.failure(decodedResponse.message);
        }
      } else {
        return EmailVerificationResult.failure(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      return EmailVerificationResult.failure('Network error: $e');
    }
  }
}

class EmailVerificationResult {
  final bool isSuccess;
  final String? errorMessage;

  EmailVerificationResult._({required this.isSuccess, this.errorMessage});

  factory EmailVerificationResult.success() =>
      EmailVerificationResult._(isSuccess: true);

  factory EmailVerificationResult.failure(String errorMessage) =>
      EmailVerificationResult._(isSuccess: false, errorMessage: errorMessage);
}
