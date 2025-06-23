import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/coach_model.dart';

class CoachHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';

  // Fetch coach list by club ID
  static Future<List<Coach>> fetchCoachList(int clubId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/fetch_coach_list?club_id=$clubId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Coach>.from(data['coaches'].map((x) => Coach.fromJson(x)));
      } else {
        throw Exception('Failed to load coaches: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch coaches: $e');
    }
  }
}