class LogActivityResponse {
  final bool success;
  final String message;

  LogActivityResponse({required this.success, required this.message});

  factory LogActivityResponse.fromJson(Map<String, dynamic> json) {
    return LogActivityResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
