class SportInstructionsResponse {
  final bool success;
  final String message;
  final Instruction instruction;
  final List<ImportantPoint>? importantPoints;
  final List<InstructionDetail>? details;

  SportInstructionsResponse({
    required this.success,
    required this.message,
    required this.instruction,
    this.importantPoints,
    this.details,
  });

  factory SportInstructionsResponse.fromJson(Map<String, dynamic> json) {
    return SportInstructionsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      instruction: Instruction.fromJson(json['instruction']),
      importantPoints:
          json['important_points'] != null
              ? (json['important_points'] as List)
                  .map((point) => ImportantPoint.fromJson(point))
                  .toList()
              : null,
      details:
          json['details'] != null
              ? List<InstructionDetail>.from(
                json['details'].map((x) => InstructionDetail.fromJson(x)),
              )
              : null,
    );
  }
}

class Instruction {
  final int id;
  final String title;

  Instruction({required this.id, required this.title});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return Instruction(id: json['id'] as int, title: json['title'] as String);
  }
}

class ImportantPoint {
  final int id;
  final int sportInstructionsId;
  final String point;

  ImportantPoint({
    required this.id,
    required this.sportInstructionsId,
    required this.point,
  });

  factory ImportantPoint.fromJson(Map<String, dynamic> json) {
    return ImportantPoint(
      id: json['id'] as int,
      sportInstructionsId: json['sport_instructions_id'] as int,
      point: json['point'] as String,
    );
  }
}

class InstructionDetail {
  final int id;
  final int sportInstructionsId;
  final String heading;
  final String details;

  InstructionDetail({
    required this.id,
    required this.sportInstructionsId,
    required this.heading,
    required this.details,
  });

  factory InstructionDetail.fromJson(Map<String, dynamic> json) {
    return InstructionDetail(
      id: json['id'],
      sportInstructionsId: json['sport_instructions_id'],
      heading: json['heading'],
      details: json['details'],
    );
  }
}
