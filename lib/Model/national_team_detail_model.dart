class NationalTeamModel {
  bool? success;
  String? message;
  List<TeamDetail>? teamDetails;

  NationalTeamModel({this.success, this.message, this.teamDetails});

  factory NationalTeamModel.fromJson(Map<String, dynamic> json) {
    return NationalTeamModel(
      success: json['success'],
      message: json['message'],
      teamDetails:
          (json['team_details'] as List<dynamic>?)
              ?.map((item) => TeamDetail.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'team_details': teamDetails?.map((item) => item.toJson()).toList(),
    };
  }
}

class TeamDetail {
  int? id;
  String? name;
  String? image;
  String? type;

  TeamDetail({this.id, this.name, this.image, this.type});

  factory TeamDetail.fromJson(Map<String, dynamic> json) {
    return TeamDetail(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image, 'type': type};
  }
}
