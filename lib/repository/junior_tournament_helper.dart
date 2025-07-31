
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/junior_tournament_model.dart';


class TournamentDetailsHelper {
  static Future<TournamentDetailsResponse> fetchTournamentDetails(int teamId) async {
    final response = await http.get(
      Uri.parse('https://hsi.realrisktakers.com/api/fetch-tournament-details?team_id=$teamId'),
    );

    if (response.statusCode == 200) {
      return TournamentDetailsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tournament details');
    }
  }
}

class TournamentMatchesHelper {
  static Future<TournamentMatchesResponse> fetchTournamentMatches(int tournamentId) async {
    final response = await http.get(
      Uri.parse('https://hsi.realrisktakers.com/api/junior-tournament-match?tournament_id=$tournamentId'),
    );

    if (response.statusCode == 200) {
      return TournamentMatchesResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load tournament matches');
    }
  }
}