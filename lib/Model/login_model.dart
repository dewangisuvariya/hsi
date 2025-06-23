class LoginResponse {
  final bool success;
  final String message;
  final int? userId;

  LoginResponse({required this.success, required this.message, this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      userId: json['user_id'] ?? json['data']?['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'user_id': userId};
  }
}
