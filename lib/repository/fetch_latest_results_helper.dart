import 'dart:convert';
import 'package:hsi/Model/fetch_latest_results_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://hsi.realrisktakers.com/api";

  static Future<LatestMatchResultModel?> fetchLatestResults() async {
    final url = Uri.parse("$baseUrl/fetch-latest-results");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return LatestMatchResultModel.fromJson(data);
      } else {
        print("Failed to load data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    }
  }
}
