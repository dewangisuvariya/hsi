class PlyometricDetailsModel {
  final bool success;
  final String message;
  final List<PlyometricData> data;

  PlyometricDetailsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PlyometricDetailsModel.fromJson(Map<String, dynamic> json) {
    return PlyometricDetailsModel(
      success: json['success'],
      message: json['message'],
      data:
          (json['data'] as List)
              .map((item) => PlyometricData.fromJson(item))
              .toList(),
    );
  }
}

class PlyometricData {
  final int id;
  final int plyometricId;
  final String pointDetail;

  PlyometricData({
    required this.id,
    required this.plyometricId,
    required this.pointDetail,
  });

  factory PlyometricData.fromJson(Map<String, dynamic> json) {
    return PlyometricData(
      id: json['id'],
      plyometricId: json['plyometric_id'],
      pointDetail: json['point_detail'],
    );
  }
}
