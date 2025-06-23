class MasterTeamResponse {
  final bool success;
  final String message;
  final List<MasterTeam> masterTeams;

  MasterTeamResponse({
    required this.success,
    required this.message,
    required this.masterTeams,
  });

  factory MasterTeamResponse.fromJson(Map<String, dynamic> json) {
    return MasterTeamResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      masterTeams:
          (json['masterTeams'] as List<dynamic>)
              .map((team) => MasterTeam.fromJson(team))
              .toList(),
    );
  }
}

class MasterTeam {
  final int id;
  final String teamName;
  final String teamImage;

  MasterTeam({
    required this.id,
    required this.teamName,
    required this.teamImage,
  });

  factory MasterTeam.fromJson(Map<String, dynamic> json) {
    return MasterTeam(
      id: json['id'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamImage: json['team_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'team_name': teamName, 'team_image': teamImage};
  }
}
