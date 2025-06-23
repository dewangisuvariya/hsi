class LeagueDetailModel {
  final bool success;
  final String message;
  final List<LeagueDetail> leagueDetails;

  LeagueDetailModel({
    required this.success,
    required this.message,
    required this.leagueDetails,
  });

  factory LeagueDetailModel.fromJson(Map<String, dynamic> json) {
    return LeagueDetailModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      leagueDetails: (json['league_details'] as List)
          .map((item) => LeagueDetail.fromJson(item))
          .toList(),
    );
  }
}

class LeagueDetail {
  final int id;
  final int leagueId;
  final String name;
  final String image;

  LeagueDetail({
    required this.id,
    required this.leagueId,
    required this.name,
    required this.image,
  });

  factory LeagueDetail.fromJson(Map<String, dynamic> json) {
    return LeagueDetail(
      id: json['id'] ?? 0,
      leagueId: json['league_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
