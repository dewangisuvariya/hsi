import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/partner_club_detail_model.dart';

Future<List<PartnerClubDetailModel>> fetchClubPartners(int clubId) async {
  String url =
      "https://hsi.realrisktakers.com/api/fetch_manager_info?club_id=$clubId";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> partners = data["club_partners"] ?? [];

      // Map the list to AoildarfeloghsiModel objects
      return partners
          .map((partner) => PartnerClubDetailModel.fromJson(partner))
          .toList();
    } else {
      print("Failed to load data. Status Code: ${response.statusCode}");
      return [];
    }
  } catch (error) {
    print("Error fetching data: $error");
    return [];
  }
}
