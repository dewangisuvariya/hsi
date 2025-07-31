// class StrengthTrainingGroupModel {
//   final bool success;
//   final String message;
//   final List<StrengthTrainingGroup> entries;

//   StrengthTrainingGroupModel({
//     required this.success,
//     required this.message,
//     required this.entries,
//   });

//   factory StrengthTrainingGroupModel.fromJson(Map<String, dynamic> json) {
//     return StrengthTrainingGroupModel(
//       success: json['success'] as bool? ?? false,
//       message: json['message'] as String? ?? '',
//       entries:
//           (json['entries'] as List<dynamic>?)
//               ?.map((item) => StrengthTrainingGroup.fromJson(item))
//               .toList() ??
//           [],
//     );
//   }
// }

// class StrengthTrainingGroup {
//   final int id;
//   final int sportStrengthTrainingId;
//   final String heading;
//   final String subHeading;
//   final String image;

//   StrengthTrainingGroup({
//     required this.id,
//     required this.sportStrengthTrainingId,
//     required this.heading,
//     required this.subHeading,
//     required this.image,
//   });

//   factory StrengthTrainingGroup.fromJson(Map<String, dynamic> json) {
//     return StrengthTrainingGroup(
//       id: json['id'] as int? ?? 0,
//       sportStrengthTrainingId: json['sport_strength_training_id'] as int? ?? 0,
//       heading: json['heading'] as String? ?? '',
//       subHeading: json['sub_heading'] as String? ?? '',
//       image: json['image'] as String? ?? '',
//     );
//   }
// }
class StrengthTrainingGroupModel {
  final bool success;
  final String message;
  final List<StrengthTrainingGroup> entries;

  StrengthTrainingGroupModel({
    required this.success,
    required this.message,
    required this.entries,
  });

  factory StrengthTrainingGroupModel.fromJson(Map<String, dynamic> json) {
    return StrengthTrainingGroupModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      entries:
          (json['entries'] as List<dynamic>?)
              ?.map((item) => StrengthTrainingGroup.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class StrengthTrainingGroup {
  final int id;
  final int sportStrengthTrainingId;
  final String? teamName; // For U19 and U17
  final String? teamImage; // For U19 and U17
  final String? heading; // For U15
  final String? subHeading; // For U15
  final String? image; // For U15

  StrengthTrainingGroup({
    required this.id,
    required this.sportStrengthTrainingId,
    this.teamName,
    this.teamImage,
    this.heading,
    this.subHeading,
    this.image,
  });

  factory StrengthTrainingGroup.fromJson(Map<String, dynamic> json) {
    return StrengthTrainingGroup(
      id: json['id'] as int? ?? 0,
      sportStrengthTrainingId: json['sport_strength_training_id'] as int? ?? 0,
      teamName: json['team_name'] as String?,
      teamImage: json['team_image'] as String?,
      heading: json['heading'] as String?,
      subHeading: json['sub_heading'] as String?,
      image: json['image'] as String?,
    );
  }

  // Helper getters to simplify access to the fields regardless of type
  String get name => teamName ?? heading ?? '';
  String get imageUrl => teamImage ?? image ?? '';
  String get description => subHeading ?? '';
}
