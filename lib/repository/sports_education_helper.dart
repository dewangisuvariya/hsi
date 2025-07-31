import 'dart:convert';
import 'package:hsi/Model/sports_education_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://hsi.realrisktakers.com/api';

  Future<SportEducationModel?> fetchSportEducation() async {
    final url = Uri.parse('$baseUrl/sport-education');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return SportEducationModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sport education: $e');

      throw Exception('Error: $e');
    }
  }
}
