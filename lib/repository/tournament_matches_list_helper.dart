import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/tournament_matches_list_model.dart';

class TournamentMatchesApi {
  static const String baseUrl = "https://hsi.realrisktakers.com/api";

  static Future<TournamentMatchesResponse> fetchTournamentMatches({
    required int tournamentId,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/fetch_tournament_matches_list?tournament_id=$tournamentId',
      ),
    );

    if (response.statusCode == 200) {
      return TournamentMatchesResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tournament matches');
    }
  }
}
