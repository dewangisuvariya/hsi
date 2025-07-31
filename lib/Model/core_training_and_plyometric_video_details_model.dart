class PlyometricVideoDetailsModel {
  final bool success;
  final String message;
  final List<PlyometricVideo> videos;

  PlyometricVideoDetailsModel({
    required this.success,
    required this.message,
    required this.videos,
  });

  factory PlyometricVideoDetailsModel.fromJson(Map<String, dynamic> json) {
    return PlyometricVideoDetailsModel(
      success: json['success'],
      message: json['message'],
      videos:
          (json['videos'] as List)
              .map((item) => PlyometricVideo.fromJson(item))
              .toList(),
    );
  }
}

class PlyometricVideo {
  final int id;
  final int plyometricDetailId;
  final String videoHeading;
  final String videoSubHeading;
  final String videoUrl;

  PlyometricVideo({
    required this.id,
    required this.plyometricDetailId,
    required this.videoHeading,
    required this.videoSubHeading,
    required this.videoUrl,
  });

  factory PlyometricVideo.fromJson(Map<String, dynamic> json) {
    return PlyometricVideo(
      id: json['id'],
      plyometricDetailId: json['plyometric_detail_id'],
      videoHeading: json['video_heading'],
      videoSubHeading: json['video_sub_heading'],
      videoUrl: json['video_url'],
    );
  }

  // Optional: Add a method to convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plyometric_detail_id': plyometricDetailId,
      'video_heading': videoHeading,
      'video_sub_heading': videoSubHeading,
      'video_url': videoUrl,
    };
  }
}
