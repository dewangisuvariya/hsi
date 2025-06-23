class HSIStatisticModel {
  final bool success;
  final String message;
  final List<HSIStatisticItem> statistics;

  HSIStatisticModel({
    required this.success,
    required this.message,
    required this.statistics,
  });

  factory HSIStatisticModel.fromJson(Map<String, dynamic> json) {
    return HSIStatisticModel(
      success: json['success'],
      message: json['message'],
      statistics: List<HSIStatisticItem>.from(
        json['statistics'].map((item) => HSIStatisticItem.fromJson(item)),
      ),
    );
  }
}

class HSIStatisticItem {
  final int id;
  final String name;
  final String image;

  HSIStatisticItem({required this.id, required this.name, required this.image});

  factory HSIStatisticItem.fromJson(Map<String, dynamic> json) {
    return HSIStatisticItem(
      id: json['id'],
      name: json['name'],
      image: json['iamge'], // Note: field is 'iamge' in the API
    );
  }
}
