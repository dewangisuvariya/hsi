// junior_team_api_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/junior_national_team_week_model.dart';

class JuniorTeamApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';

  Future<JuniorTeamResponse> fetchJuniorTeamData(int juniorTeamId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get-junior-team-data?junior_team_id=$juniorTeamId'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return JuniorTeamResponse.fromJson(jsonData);
    } else {
      throw Exception(
        'Failed to load junior team data. Status code: ${response.statusCode}',
      );
    }
  }
}
