class StrengthTrainingU15Response {
  final bool success;
  final String message;
  final List<StrengthTrainingDetail> details;

  StrengthTrainingU15Response({
    required this.success,
    required this.message,
    required this.details,
  });

  factory StrengthTrainingU15Response.fromJson(Map<String, dynamic> json) {
    return StrengthTrainingU15Response(
      success: json['success'],
      message: json['message'],
      details: List<StrengthTrainingDetail>.from(
        json['details'].map((x) => StrengthTrainingDetail.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class StrengthTrainingDetail {
  final int id;
  final int sportStrengthTrainingU15Id;
  final String videoHeading;
  final String videoSubHeading;
  final String videoUrl;

  StrengthTrainingDetail({
    required this.id,
    required this.sportStrengthTrainingU15Id,
    required this.videoHeading,
    required this.videoSubHeading,
    required this.videoUrl,
  });

  factory StrengthTrainingDetail.fromJson(Map<String, dynamic> json) {
    return StrengthTrainingDetail(
      id: json['id'],
      sportStrengthTrainingU15Id: json['sport_strength_training_u15_id'],
      videoHeading: json['video_heading'],
      videoSubHeading: json['video_sub_heading'],
      videoUrl: json['video_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "sport_strength_training_u15_id": sportStrengthTrainingU15Id,
    "video_heading": videoHeading,
    "video_sub_heading": videoSubHeading,
    "video_url": videoUrl,
  };
}
