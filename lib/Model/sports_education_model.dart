class SportEducationModel {
  final bool success;
  final String message;
  final List<SportEducationItem> details;

  SportEducationModel({
    required this.success,
    required this.message,
    required this.details,
  });

  factory SportEducationModel.fromJson(Map<String, dynamic> json) {
    return SportEducationModel(
      success: json['success'],
      message: json['message'],
      details: List<SportEducationItem>.from(
        json['details'].map((item) => SportEducationItem.fromJson(item)),
      ),
    );
  }
}

class SportEducationItem {
  final int id;
  final String name;
  final String image;

  SportEducationItem({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SportEducationItem.fromJson(Map<String, dynamic> json) {
    return SportEducationItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
