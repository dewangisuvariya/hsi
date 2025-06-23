class ResendVerificationResponse {
  final bool success;
  final String message;

  ResendVerificationResponse({required this.success, required this.message});

  factory ResendVerificationResponse.fromJson(Map<String, dynamic> json) {
    return ResendVerificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
