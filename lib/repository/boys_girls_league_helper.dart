import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/boys_girls_league_model.dart';

class BoysGirlsLeage {
  List<BoysGirlLeageModel> getData = [];

  Future<void> boyGirlLeageData() async {
    try {
      final response = await http.get(
        Uri.parse("https://hsi.realrisktakers.com/api/fetch_boy_girl_leagues"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> myList = jsonData["leagues"] ?? [];

        getData = myList.map((e) => BoysGirlLeageModel.fromJson(e)).toList();
        print("Data fetched: ${getData.length} items");
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
