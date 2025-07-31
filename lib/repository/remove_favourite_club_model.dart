class RemoveFavoriteClubResponse {
  final bool success;
  final String message;

  RemoveFavoriteClubResponse({required this.success, required this.message});

  factory RemoveFavoriteClubResponse.fromJson(Map<String, dynamic> json) {
    return RemoveFavoriteClubResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
