import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/men_women_leage_model.dart';

class MenWomenLeagues {
  List<MenWomenLeaguesModel> getdata = [];

  Future<List<MenWomenLeaguesModel>> mwlData() async {
    try {
      final response = await http.get(
        Uri.parse("https://hsi.realrisktakers.com/api/fetch_men_women_leagues"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        if (jsonData['success'] == true && jsonData['leagues'] != null) {
          List<dynamic> myList = jsonData["leagues"];
          getdata =
              myList.map((e) => MenWomenLeaguesModel.fromJson(e)).toList();
          return getdata;
        } else {
          throw Exception('API responded with success: false or no leagues');
        }
      } else {
        throw Exception(
          'Failed to load men women details. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("Fetch error: $e");
      throw Exception('Failed to load men women details');
    }
  }
}
