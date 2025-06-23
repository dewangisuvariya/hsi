class FavouriteTeamResponse {
  final bool success;
  final List<String> message;

  FavouriteTeamResponse({required this.success, required this.message});

  factory FavouriteTeamResponse.fromJson(Map<String, dynamic> json) {
    return FavouriteTeamResponse(
      success: json['success'] ?? false,
      message: List<String>.from(json['message'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
