import 'dart:convert';
import 'package:hsi/Model/team_list_model.dart';
import 'package:http/http.dart' as http;

class MasterTeamApi {
  static const String _baseUrl = "https://hsi.realrisktakers.com/api/";

  static Future<MasterTeamResponse> fetchMasterTeams(int clubId) async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}fetch-master-team-list?club_id=$clubId'),
      );

      if (response.statusCode == 200) {
        return MasterTeamResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load master teams. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
