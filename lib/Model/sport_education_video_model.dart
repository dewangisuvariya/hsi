class SportEducationVideoDetailsModel {
  final bool success;
  final String message;
  final List<VideoDetail> videoDetails;

  SportEducationVideoDetailsModel({
    required this.success,
    required this.message,
    required this.videoDetails,
  });

  factory SportEducationVideoDetailsModel.fromJson(Map<String, dynamic> json) {
    return SportEducationVideoDetailsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      videoDetails:
          (json['videoDetails'] as List<dynamic>?)
              ?.map((e) => VideoDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VideoDetail {
  final int id;
  final int sportEducationDetailsId;
  final String videoTitle;
  final String videoSubtitle;
  final String videoLink;

  VideoDetail({
    required this.id,
    required this.sportEducationDetailsId,
    required this.videoTitle,
    required this.videoSubtitle,
    required this.videoLink,
  });

  factory VideoDetail.fromJson(Map<String, dynamic> json) {
    return VideoDetail(
      id: json['id'] ?? 0,
      sportEducationDetailsId: json['sport_education_details_id'] ?? 0,
      videoTitle: json['video_title'] ?? '',
      videoSubtitle: json['video_subtitle'] ?? '',
      videoLink: json['video_link'] ?? '',
    );
  }
}
