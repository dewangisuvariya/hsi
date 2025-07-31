class TournamentDetailsResponse {
  final bool success;
  final String message;
  final List<TournamentDetail> tournamentDetails;

  TournamentDetailsResponse({
    required this.success,
    required this.message,
    required this.tournamentDetails,
  });

  factory TournamentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TournamentDetailsResponse(
      success: json['success'],
      message: json['message'],
      tournamentDetails:
          (json['tournamentDetails'] as List)
              .map((item) => TournamentDetail.fromJson(item))
              .toList(),
    );
  }
}

class TournamentDetail {
  final int tournamentId;
  final String tournamentName;

  TournamentDetail({required this.tournamentId, required this.tournamentName});

  factory TournamentDetail.fromJson(Map<String, dynamic> json) {
    return TournamentDetail(
      tournamentId: json['tournament_id'],
      tournamentName: json['tournament_name'],
    );
  }
}

// tournament_matches_model.dart
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
      success: json['success'],
      message: json['message'],
      matches:
          (json['matches'] as List)
              .map((item) => TournamentMatch.fromJson(item))
              .toList(),
    );
  }
}

class TournamentMatch {
  final int id;
  final String homeTeamName;
  final int homeTeamScore;
  final String awayTeamName;
  final int awayTeamScore;
  final String image;

  TournamentMatch({
    required this.id,
    required this.homeTeamName,
    required this.homeTeamScore,
    required this.awayTeamName,
    required this.awayTeamScore,
    required this.image,
  });

  factory TournamentMatch.fromJson(Map<String, dynamic> json) {
    return TournamentMatch(
      id: json['id'],
      homeTeamName: json['home_team_name'],
      homeTeamScore: json['home_team_score'],
      awayTeamName: json['away_team_name'],
      awayTeamScore: json['away_team_score'],
      image: json['image'],
    );
  }
}
