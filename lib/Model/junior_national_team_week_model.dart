class JuniorTeamResponse {
  final bool success;
  final String message;
  final List<Team> teams;
  final List<WeekHeading> weekHeadings;

  JuniorTeamResponse({
    required this.success,
    required this.message,
    required this.teams,
    required this.weekHeadings,
  });

  factory JuniorTeamResponse.fromJson(Map<String, dynamic> json) {
    return JuniorTeamResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      teams:
          (json['teams'] as List<dynamic>)
              .map((teamJson) => Team.fromJson(teamJson))
              .toList(),
      weekHeadings:
          (json['weekHeadings'] as List<dynamic>)
              .map((headingJson) => WeekHeading.fromJson(headingJson))
              .toList(),
    );
  }
}

class Team {
  final int id;
  final String tournamentName;
  final String tournamentType;
  final List<Coach> coaches;
  final List<JuniorTeamWeek> juniorTeamWeeks;

  Team({
    required this.id,
    required this.tournamentName,
    required this.tournamentType,
    required this.coaches,
    required this.juniorTeamWeeks,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      tournamentName: json['tournament_name'] ?? '',
      tournamentType: json['tournament_type'] ?? '',
      coaches:
          (json['coaches'] as List<dynamic>)
              .map((coachJson) => Coach.fromJson(coachJson))
              .toList(),
      juniorTeamWeeks:
          (json['juniorTeamWeeks'] as List<dynamic>)
              .map((weekJson) => JuniorTeamWeek.fromJson(weekJson))
              .toList(),
    );
  }
}

class Coach {
  final int id;
  final String image;
  final String name;
  final String email;
  final String telephone;

  Coach({
    required this.id,
    required this.image,
    required this.name,
    required this.email,
    required this.telephone,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] ?? 0,
      image: json['coach_image'] ?? '',
      name: json['coach_name'] ?? '',
      email: json['coach_email'] ?? '',
      telephone: json['coach_telephone'] ?? '',
    );
  }
}

class JuniorTeamWeek {
  final int id;
  final String planning;
  final String duration;
  final String image;
  final String startDate;
  final String endDate;

  JuniorTeamWeek({
    required this.id,
    required this.planning,
    required this.duration,
    required this.image,
    required this.startDate,
    required this.endDate,
  });

  factory JuniorTeamWeek.fromJson(Map<String, dynamic> json) {
    return JuniorTeamWeek(
      id: json['id'] ?? 0,
      planning: json['planning'] ?? '',
      duration: json['duration'] ?? '',
      image: json['image'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}

class WeekHeading {
  final int id;
  final String heading;
  final String description;

  WeekHeading({
    required this.id,
    required this.heading,
    required this.description,
  });

  factory WeekHeading.fromJson(Map<String, dynamic> json) {
    return WeekHeading(
      id: json['id'] ?? 0,
      heading: json['week_heading'] ?? '',
      description: json['week_description'] ?? '',
    );
  }
}
