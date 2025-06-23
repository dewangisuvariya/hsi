import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/national_team_detail_model.dart';

class ApiHelper {
  static Future<NationalTeamModel> fetchNationalTeamCategory(int id) async {
    final String url =
        'https://hsi.realrisktakers.com/api/fetch_national_team_category?id=$id';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return NationalTeamModel.fromJson(data);
        } else {
          throw Exception('Failed to load data: ${data['message']}');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
