// import 'dart:convert';
// import 'package:http/http.dart'as http;

// import '../Model/aoildarfeloghsi_model.dart';


// class AoildarfeloghsiRepo {
//   List<AoildarfeloghsiModel> getData = [];

//   Future<List<AoildarfeloghsiModel>> clubPartnerList() async {
//     try {
//       final response = await http.get(
//         Uri.parse("https://hsi.realrisktakers.com/api/fetch_club_partner_list"),
//       );
//       if (response.statusCode == 200) {
//         Map<String, dynamic> jsonData = jsonDecode(response.body);
//         List<dynamic> myList = jsonData["data"] ?? [];
//         getData = myList.map((e) => AoildarfeloghsiModel.fromJson(e)).toList();
//         return getData;
//       } else {
//         print("Data is Not Found In This URL");
//         return [];
//       }
//     } catch (e) {
//       print("Data not found: $e");
//       return [];
//     }
//   }
// }