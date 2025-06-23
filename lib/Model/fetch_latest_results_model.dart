class LatestMatchResultModel {
  final bool success;
  final String message;
  final List<MatchResult> results;

  LatestMatchResultModel({
    required this.success,
    required this.message,
    required this.results,
  });

  factory LatestMatchResultModel.fromJson(Map<String, dynamic> json) {
    return LatestMatchResultModel(
      success: json['success'],
      message: json['message'],
      results: List<MatchResult>.from(
        json['results'].map((x) => MatchResult.fromJson(x)),
      ),
    );
  }
}

class MatchResult {
  final int id;
  final String teamName;
  final String awayClubName;
  final String awayClubImage;
  final int awayClubScore;
  final String homeClubName;
  final String homeClubImage;
  final int homeClubScore;
  final String matchDateTime;
  final String url;

  MatchResult({
    required this.id,
    required this.teamName,
    required this.awayClubName,
    required this.awayClubImage,
    required this.awayClubScore,
    required this.homeClubName,
    required this.homeClubImage,
    required this.homeClubScore,
    required this.matchDateTime,
    required this.url,
  });

  factory MatchResult.fromJson(Map<String, dynamic> json) {
    return MatchResult(
      id: json['id'],
      teamName: json['team_name'],
      awayClubName: json['away_club_name'],
      awayClubImage: json['away_club_image'],
      awayClubScore: json['away_club_score'],
      homeClubName: json['home_club_name'],
      homeClubImage: json['home_club_image'],
      homeClubScore: json['home_club_score'],
      matchDateTime: json['match_date_time'],
      url: json['url'],
    );
  }
}
