class SportEducationDetailsModel {
  final bool success;
  final String message;
  final List<SportEducationDetailItem> details;

  SportEducationDetailsModel({
    required this.success,
    required this.message,
    required this.details,
  });

  factory SportEducationDetailsModel.fromJson(Map<String, dynamic> json) {
    return SportEducationDetailsModel(
      success: json['status'] as bool? ?? false, // Handle null case
      message: json['message'] as String? ?? '',
      details:
          (json['details'] as List<dynamic>?)
              ?.map((item) => SportEducationDetailItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SportEducationDetailItem {
  final int id;
  final String type;
  final int sportEducationId;
  final String? name;
  final String? instructionDetail;
  final String? instructionImage;
  final String? sportImage;
  final String? plyometricDetail;
  final String? plyometricImage;
  SportEducationDetailItem({
    required this.id,
    required this.sportEducationId,
    required this.type,
    this.name,
    this.instructionDetail,
    this.instructionImage,
    this.sportImage,
    this.plyometricDetail,
    this.plyometricImage,
  });

  factory SportEducationDetailItem.fromJson(Map<String, dynamic> json) {
    return SportEducationDetailItem(
      id: json['id'] ?? 0,
      sportEducationId: json['sport_education_id'] ?? 0,
      type: json['type'] ?? "",
      name: json['name'] ?? "",
      instructionDetail: json['instruction_detail'] ?? "",
      instructionImage: json['instruction_image'] ?? "",
      plyometricDetail: json['plyometric_detail'] ?? "",
      plyometricImage: json['plyometric_image'] ?? "",
      sportImage: json['image'] ?? "",
    );
  }
}
