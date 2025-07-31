class GeneralInfoResponse {
  final bool success;
  final String message;
  final List<GeneralInfo> generalInfo;
  final List<Club> clubs;
  final List<NationalTeam> nationalTeams;

  GeneralInfoResponse({
    required this.success,
    required this.message,
    required this.generalInfo,
    required this.clubs,
    required this.nationalTeams,
  });

  factory GeneralInfoResponse.fromJson(Map<String, dynamic> json) {
    return GeneralInfoResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      generalInfo:
          (json['general_info'] as List?)
              ?.map((item) => GeneralInfo.fromJson(item))
              .toList() ??
          [],
      clubs:
          (json['clubs'] as List?)
              ?.map((item) => Club.fromJson(item))
              .toList() ??
          [],
      nationalTeams:
          (json['national_teams'] as List?)
              ?.map((item) => NationalTeam.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class GeneralInfo {
  final int id;
  final String name;
  final String type;
  final String image;

  GeneralInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) {
    return GeneralInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'image': image,
  };
}

class Club {
  final int id;
  final String name;
  final String image;

  Club({required this.id, required this.name, required this.image});

  factory Club.fromJson(Map<String, dynamic> json) {
    return Club(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}

class NationalTeam {
  final int id;
  final String name;
  final String image;

  NationalTeam({required this.id, required this.name, required this.image});

  factory NationalTeam.fromJson(Map<String, dynamic> json) {
    return NationalTeam(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}
