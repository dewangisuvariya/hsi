class StrengthTrainingLevelModel {
  final bool success;
  final String message;
  final List<StrengthTrainingLevel> levels;

  StrengthTrainingLevelModel({
    required this.success,
    required this.message,
    required this.levels,
  });

  factory StrengthTrainingLevelModel.fromJson(Map<String, dynamic> json) {
    return StrengthTrainingLevelModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      levels:
          (json['levels'] as List<dynamic>?)
              ?.map((item) => StrengthTrainingLevel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class StrengthTrainingLevel {
  final int id;
  final int sportStrengthTrainingU17U19Id;
  final String levelName;

  StrengthTrainingLevel({
    required this.id,
    required this.sportStrengthTrainingU17U19Id,
    required this.levelName,
  });

  factory StrengthTrainingLevel.fromJson(Map<String, dynamic> json) {
    return StrengthTrainingLevel(
      id: json['id'] as int? ?? 0,
      sportStrengthTrainingU17U19Id:
          json['sport_strength_training_u17_u19_id'] as int? ?? 0,
      levelName: json['level_name'] as String? ?? '',
    );
  }

  // Helper method to extract just the level number from level_name
  String get levelNumber {
    final parts = levelName.split('. ');
    return parts.isNotEmpty ? parts[0] : '';
  }

  // Helper method to extract just the level description from level_name
  String get levelDescription {
    final parts = levelName.split('. ');
    return parts.length > 1 ? parts[1] : levelName;
  }
}
