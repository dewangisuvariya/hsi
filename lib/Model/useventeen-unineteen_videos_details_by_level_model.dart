class VideoDetailsModel {
  final bool success;
  final String message;
  final String levelId;
  final List<VideoItem> warmUpVideos;
  final List<VideoItem> exerciseVideos;

  VideoDetailsModel({
    required this.success,
    required this.message,
    required this.levelId,
    required this.warmUpVideos,
    required this.exerciseVideos,
  });

  factory VideoDetailsModel.fromJson(Map<String, dynamic> json) {
    return VideoDetailsModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      levelId:
          json['level_id']?.toString() ?? '0', // Handle both string and number
      warmUpVideos:
          (json['warm_up_videos'] as List<dynamic>?)
              ?.map((item) => VideoItem.fromJson(item))
              .toList() ??
          [],
      exerciseVideos:
          (json['exercise_videos'] as List<dynamic>?)
              ?.map((item) => VideoItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class VideoItem {
  final int id;
  final int levelId;
  final String heading;
  final String subHeading;
  final String videoUrl;
  final String type;

  VideoItem({
    required this.id,
    required this.levelId,
    required this.heading,
    required this.subHeading,
    required this.videoUrl,
    required this.type,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    return VideoItem(
      id: json['id'] as int? ?? 0,
      levelId: json['level_id'] as int? ?? 0,
      heading: json['heading'] as String? ?? '',
      subHeading: json['sub_heading'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  // Helper method to check if this is a warm-up video
  bool get isWarmUp => type.toLowerCase() == 'warmup';

  // Helper method to check if this is an exercise video
  bool get isExercise => type.toLowerCase() == 'exercise';

  // Helper method to extract the main exercise name (before colon if present)
  String get mainExerciseName {
    final parts = heading.split(':');
    return parts.first.trim();
  }

  // Helper method to extract the exercise details (after colon if present)
  String get exerciseDetails {
    final parts = heading.split(':');
    return parts.length > 1 ? parts[1].trim() : '';
  }
}
