class LandslioModel {
int? id;
String? name;
String? image;

LandslioModel({this.id, this.name, this.image});

LandslioModel.fromJson(Map<String, dynamic> json) {
id = json['id'];
name = json['name'];
image = json['image'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['id'] = this.id;
data['name'] = this.name;
data['image'] = this.image;
return data;
}
}