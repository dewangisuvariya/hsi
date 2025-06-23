import 'dart:convert';
import 'package:hsi/Model/statistics_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://hsi.realrisktakers.com/api';

  Future<HSIStatisticModel?> fetchHSIStatistics() async {
    final url = Uri.parse('$baseUrl/hsi-statistics-details');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return HSIStatisticModel.fromJson(jsonResponse);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching HSI statistics: $e');
      return null;
    }
  }
}
