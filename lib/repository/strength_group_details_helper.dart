import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hsi/Model/strength_group_details_model.dart';
import 'package:http/http.dart' as http;

class StrengthTrainingGroupService {
  Future<StrengthTrainingGroupModel?> fetchStrengthTrainingGroups({
    required int strengthTrainingId,
    required String type,
  }) async {
    final url = Uri.parse(
      "https://hsi.realrisktakers.com/api/fetch-strength-group",
    ).replace(
      queryParameters: {
        'strength_training_id': strengthTrainingId.toString(),
        'type': type,
      },
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        debugPrint("Strength Group API Response: $jsonData");

        return StrengthTrainingGroupModel.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load data. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("Error fetching strength training groups: $e");
      return null;
    }
  }
}
