class NationalTeamDetailsResponse {
  final bool success;
  final String message;
  final List<InfoSection> infoSections;
  final List<Coach> coaches;
  final List<NationalTeamWeek> nationalTeamWeeks;
  final List<dynamic> majorTournaments;
  final List<JuniorTeam> juniorTeams;
  final List<JuniorTeamHandbook> juniorTeamHandbook;
  final List<SuccessTournamentJuniorTeam> successTournamentJuniorTeams;
  final dynamic tournamentHeadingDetails;

  NationalTeamDetailsResponse({
    required this.success,
    required this.message,
    required this.infoSections,
    required this.coaches,
    required this.nationalTeamWeeks,
    required this.majorTournaments,
    required this.juniorTeams,
    required this.juniorTeamHandbook,
    required this.successTournamentJuniorTeams,
    required this.tournamentHeadingDetails,
  });

  factory NationalTeamDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NationalTeamDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      infoSections:
          (json['infoSections'] as List<dynamic>?)
              ?.map((e) => InfoSection.fromJson(e))
              .toList() ??
          [],
      coaches:
          (json['coaches'] as List<dynamic>?)
              ?.map((e) => Coach.fromJson(e))
              .toList() ??
          [],
      nationalTeamWeeks:
          (json['nationalTeamWeeks'] as List)
              .map((i) => NationalTeamWeek.fromJson(i))
              .toList(),
      majorTournaments:
          (json['majorTournaments'] as List<dynamic>?)
              ?.map((e) => MajorTournament.fromJson(e))
              .toList() ??
          [],
      juniorTeams:
          (json['juniorTeams'] as List<dynamic>?)
              ?.map((e) => JuniorTeam.fromJson(e))
              .toList() ??
          [],
      juniorTeamHandbook:
          (json['juniorTeamHandbook'] as List<dynamic>?)
              ?.map((e) => JuniorTeamHandbook.fromJson(e))
              .toList() ??
          [],
      successTournamentJuniorTeams:
          (json['successTournamentJuniorTeams'] as List<dynamic>?)
              ?.map((e) => SuccessTournamentJuniorTeam.fromJson(e))
              .toList() ??
          [],
      tournamentHeadingDetails: json['tournamentHeadingDetails'],
    );
  }
}

class InfoSection {
  final int id;
  final String image;
  final String details;
  final String instagramLink;
  final String facebookLink;
  final String twitterLink;

  InfoSection({
    required this.id,
    required this.image,
    required this.details,
    required this.instagramLink,
    required this.facebookLink,
    required this.twitterLink,
  });

  factory InfoSection.fromJson(Map<String, dynamic> json) {
    return InfoSection(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      details: json['details'] ?? '',
      instagramLink: json['instagram_link'] ?? '',
      facebookLink: json['facebook_link'] ?? '',
      twitterLink: json['twitter_link'] ?? '',
    );
  }
}

class Coach {
  final int id;
  final String image;
  final String name;
  final String year;

  Coach({
    required this.id,
    required this.image,
    required this.name,
    required this.year,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      year: json['year'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'name': name, 'year': year};
  }
}

class MajorTournament {
  final int id;
  final String name;
  final int coachId;
  final String? coachName;
  final String? coachImage;

  MajorTournament({
    required this.id,
    required this.name,
    required this.coachId,
    this.coachName,
    this.coachImage,
  });

  factory MajorTournament.fromJson(Map<String, dynamic> json) {
    return MajorTournament(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      coachId: json['coach_id'] ?? 0,
      coachName: json['coach_name'],
      coachImage: json['coach_image'],
    );
  }
}

class NationalTeamWeek {
  int id;
  String name;
  String startDate;
  String endDate;
  String image;
  final String planning;
  final String duration;

  NationalTeamWeek({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.planning,
    required this.duration,
    required this.image,
  });

  factory NationalTeamWeek.fromJson(Map<String, dynamic> json) {
    return NationalTeamWeek(
      id: json['id'],
      name: json['name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      planning: json['planning'] ?? '',
      duration: json['duration'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start_date': startDate,
      'end_date': endDate,
      'planning': planning,
      'duration': duration,
      'image': image,
    };
  }
}
// class NationalTeamWeek {
//   final int id;
//   final String planning;
//   final String duration;
//   final String image;
//   final String startDate;
//   final String endDate;

//   NationalTeamWeek({
//     required this.id,
//     required this.planning,
//     required this.duration,
//     required this.image,
//     required this.startDate,
//     required this.endDate,
//   });

//   factory NationalTeamWeek.fromJson(Map<String, dynamic> json) {
//     return NationalTeamWeek(
//       id: json['id'] ?? 0,
//       planning: json['planning'] ?? '',
//       duration: json['duration'] ?? '',
//       image: json['image'] ?? '',
//       startDate: json['start_date'] ?? '',
//       endDate: json['end_date'] ?? '',
//     );
//   }
// }

class JuniorTeamTournament {
  final int id;
  final String categoryImage;
  final String categoryName;

  JuniorTeamTournament({
    required this.id,
    required this.categoryImage,
    required this.categoryName,
  });

  factory JuniorTeamTournament.fromJson(Map<String, dynamic> json) {
    return JuniorTeamTournament(
      id: json['id'] ?? 0,
      categoryImage: json['category_image'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }
}

class TournamentHeading {
  final int id;
  final String heading;
  final String description;

  TournamentHeading({
    required this.id,
    required this.heading,
    required this.description,
  });

  factory TournamentHeading.fromJson(Map<String, dynamic> json) {
    return TournamentHeading(
      id: json['id'] ?? 0,
      heading: json['tournament_heading'] ?? '',
      description: json['tournament_description'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tournament_heading': heading,
      'tournament_description': description,
    };
  }
}

class SuccessTournamentResponse {
  final bool success;
  final String message;
  final List<SuccessTournamentJuniorTeam> juniorTeams;
  final TournamentHeading? headingDetails;

  SuccessTournamentResponse({
    required this.success,
    required this.message,
    required this.juniorTeams,
    required this.headingDetails,
  });

  factory SuccessTournamentResponse.fromJson(Map<String, dynamic> json) {
    return SuccessTournamentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      juniorTeams:
          (json['successTournamentJuniorTeams'] as List<dynamic>?)
              ?.map((e) => SuccessTournamentJuniorTeam.fromJson(e))
              .toList() ??
          [],
      headingDetails:
          json['tournamentHeadingDetails'] != null
              ? TournamentHeading.fromJson(json['tournamentHeadingDetails'])
              : null,
    );
  }
}

class JuniorTeam {
  final int id;
  final String junior_name;
  final String junior_image;

  JuniorTeam({
    required this.id,
    required this.junior_name,
    required this.junior_image,
  });

  factory JuniorTeam.fromJson(Map<String, dynamic> json) {
    return JuniorTeam(
      id: json['id'] ?? 0,
      junior_name: json['junior_name'] ?? '',
      junior_image: json['junior_image'] ?? '',
    );
  }
}

class SuccessTournamentJuniorTeam {
  final int id;
  final String categoryImage;
  final String categoryName;

  SuccessTournamentJuniorTeam({
    required this.id,
    required this.categoryImage,
    required this.categoryName,
  });

  factory SuccessTournamentJuniorTeam.fromJson(Map<String, dynamic> json) {
    return SuccessTournamentJuniorTeam(
      id: json['id'] ?? 0,
      categoryImage: json['category_image'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }
}

class JuniorTeamHandbook {
  final int id;
  final String description;
  final String handbookFile;

  JuniorTeamHandbook({
    required this.id,
    required this.description,
    required this.handbookFile,
  });

  factory JuniorTeamHandbook.fromJson(Map<String, dynamic> json) {
    return JuniorTeamHandbook(
      id: json['id'] ?? 0,
      description: json['description'] ?? '',
      handbookFile: json['handbook_file'] ?? '',
    );
  }
}
