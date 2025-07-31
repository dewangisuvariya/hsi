import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/national_team_category_model.dart';

class NationalTeamDetailsApi {
  static Future<NationalTeamDetailsResponse> fetchNationalTeamDetails({
    required int id,
    required String type,
  }) async {
    final response = await http.get(
      Uri.parse(
        'https://hsi.realrisktakers.com/api/fetch_child_category_of_national_team_details?id=$id&type=$type',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return NationalTeamDetailsResponse.fromJson(data);
    } else {
      throw Exception('Failed to load national team details');
    }
  }
}
