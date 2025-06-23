import 'dart:convert';
import 'package:hsi/Model/user_profile_model.dart';
import 'package:hsi/repository/remove_favourite_club_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  static const String _baseUrl = "https://hsi.realrisktakers.com/api/";

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl + endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(_baseUrl + endpoint),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}

class UserProfileApi {
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<UserProfileResponse> fetchUserProfile() async {
    final userId = await getUserId();
    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final response = await ApiHelper.get('fetch-user-profile?user_id=$userId');
    return UserProfileResponse.fromJson(response);
  }

  static Future<RemoveFavoriteClubResponse> removeFavoriteClub(
    int clubId,
  ) async {
    final userId = await getUserId();
    if (userId == null) {
      throw Exception('User ID not found in SharedPreferences');
    }

    final response = await ApiHelper.delete(
      'remove-favourite-club?user_id=$userId&club_id=$clubId',
    );
    return RemoveFavoriteClubResponse.fromJson(response);
  }
}
