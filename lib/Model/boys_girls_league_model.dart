class BoysGirlLeageModel {
  int? id;
  String? leaguesName;
  String? leaguesImage;

  BoysGirlLeageModel({this.id, this.leaguesName, this.leaguesImage});

  BoysGirlLeageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaguesName = json['leagues_name'];
    leaguesImage = json['leagues_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leagues_name'] = this.leaguesName;
    data['leagues_image'] = this.leaguesImage;
    return data;
  }
}
