import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/landslio_model.dart';

class LandslioCompitionRepo {
  List<LandslioModel> getData = [];

  Future<List<LandslioModel>> getTeamList() async {
    try {
      final response = await http.get(
        Uri.parse("https://hsi.realrisktakers.com/api/fetch_national_team_list"),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> myList = jsonData["data"] ?? [];
        getData = myList.map((e) => LandslioModel.fromJson(e)).toList();
        return getData;
      } else {
        print("Data is Not Found In This URL");
        return [];
      }
    } catch (e) {
      print("Data not found: $e");
      return [];
    }
  }
}
