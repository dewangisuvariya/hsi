import 'dart:convert';
import 'package:hsi/Model/toggle_favourite_team_model.dart';
import 'package:http/http.dart' as http;

class FavouriteTeamApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';

  Future<FavouriteTeamResponse> toggleFavouriteTeam({
    required int userId,
    required int clubId,
    required int teamId,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/toggle-favourite-team?user_id=$userId&club_id=$clubId&team_id=$teamId',
    );

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return FavouriteTeamResponse.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to toggle favourite team. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error toggling favourite team: $e');
    }
  }
}
