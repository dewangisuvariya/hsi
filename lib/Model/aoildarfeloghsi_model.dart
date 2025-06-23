class AoildarfeloghsiModel {
  int? clubId;
  String? name;
  String? image;

  AoildarfeloghsiModel({this.clubId, this.name, this.image});

  AoildarfeloghsiModel.fromJson(Map<String, dynamic> json) {
    clubId = json['club_id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['club_id'] = this.clubId;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}