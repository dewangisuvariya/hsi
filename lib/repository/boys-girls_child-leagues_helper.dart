import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Model/boys_girls_child_league_model.dart';


class BoysGirlsLeagueHelper {
  Future<LeagueDetailModel> fetchLeagueDetails(int leagueId) async {
    try {
      final response = await http.get(
        Uri.parse('https://hsi.realrisktakers.com/api/fetch_boy_girl_child_leagues_detail/?id=$leagueId'),
      );

      if (response.statusCode == 200) {
        return LeagueDetailModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load league details: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on FormatException {
      throw Exception('Bad response format');
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
