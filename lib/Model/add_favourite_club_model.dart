class AddFavoriteClubResponse {
  final bool success;
  final String message;

  AddFavoriteClubResponse({required this.success, required this.message});

  factory AddFavoriteClubResponse.fromJson(Map<String, dynamic> json) {
    return AddFavoriteClubResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
