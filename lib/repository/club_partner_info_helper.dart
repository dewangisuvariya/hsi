import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/club_partner_info model.dart';

class ClubPartnerApiHelper {
  static Future<ClubPartnersResponse> fetchManagerInfo(int clubId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://hsi.realrisktakers.com/api/fetch_manager_info?club_id=$clubId',
        ),
      );

      if (response.statusCode == 200) {
        return ClubPartnersResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load manager info. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch manager info: $e');
    }
  }
}
