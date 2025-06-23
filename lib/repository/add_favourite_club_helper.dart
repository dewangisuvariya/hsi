import 'dart:convert';
import 'package:hsi/Model/add_favourite_club_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const String _baseUrl = "https://hsi.realrisktakers.com/api/";

  // Create a persistent HttpClient that won't follow redirects automatically
  static final _httpClient = http.Client();

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(_baseUrl + endpoint),
        headers: headers,
        body: body,
      );

      // Handle redirect manually if needed
      if (response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          return await post(
            redirectUrl.replaceFirst(_baseUrl, ''),
            headers: headers,
            body: body,
          );
        }
      }

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}

class FavoriteClubApi {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<AddFavoriteClubResponse> addFavoriteClub({
    required int clubId,
    required List<int> teamIds,
  }) async {
    final userId = await getUserId();
    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final teamIdsString = teamIds.join(',');
    final response = await ApiHelper.post(
      'add-favourite-club?user_id=$userId&club_id=$clubId&team_ids=$teamIdsString',
    );

    return AddFavoriteClubResponse.fromJson(response);
  }
}
