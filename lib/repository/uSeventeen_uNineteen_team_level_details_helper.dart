import 'dart:convert';
import 'package:hsi/Model/uSeventeen_uNineteen_team_level_details_model.dart';
import 'package:http/http.dart' as http;

class U17U19LevelApiHelper {
  static const String baseUrl = 'https://hsi.realrisktakers.com/api';

  static Future<StrengthTrainingLevelModel?> fetchU17U19Levels(
    int trainingId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/fetch-u17-u19-level-details?strength_training_u17_u19_id=$trainingId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return StrengthTrainingLevelModel.fromJson(jsonData);
      } else {
        print('Failed to load levels. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching level data: $e');
      return null;
    }
  }
}
