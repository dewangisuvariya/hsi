class TournamentMatchesResponse {
  final bool success;
  final String message;
  final List<TournamentMatch> matches;

  TournamentMatchesResponse({
    required this.success,
    required this.message,
    required this.matches,
  });

  factory TournamentMatchesResponse.fromJson(Map<String, dynamic> json) {
    return TournamentMatchesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      matches: (json['matches'] as List<dynamic>?)
          ?.map((e) => TournamentMatch.fromJson(e))
          .toList() ?? [],
    );
  }
}

class TournamentMatch {
  final int id;
  final String image;
  final String homeTeamName;
  final int homeTeamScore;
  final String awayTeamName;
  final int awayTeamScore;

  TournamentMatch({
    required this.id,
    required this.image,
    required this.homeTeamName,
    required this.homeTeamScore,
    required this.awayTeamName,
    required this.awayTeamScore,
  });

  factory TournamentMatch.fromJson(Map<String, dynamic> json) {
    return TournamentMatch(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      homeTeamName: json['home_team_name'] ?? '',
      homeTeamScore: json['home_team_score'] ?? 0,
      awayTeamName: json['away_team_name'] ?? '',
      awayTeamScore: json['away_team_score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'home_team_name': homeTeamName,
      'home_team_score': homeTeamScore,
      'away_team_name': awayTeamName,
      'away_team_score': awayTeamScore,
    };
  }
}