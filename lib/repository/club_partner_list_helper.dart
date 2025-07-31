// TODO Implement this library.
import 'dart:convert';
import 'package:hsi/Model/club_partner_list_model.dart';
import 'package:http/http.dart' as http;

class ClubPartnerApi {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';

  static Future<ClubPartnerResponse> fetchClubPartners() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/fetch_club_partner_list'),
        headers: {
          'Content-Type': 'application/json',
          // Add authorization if needed
          // 'Authorization': 'Bearer your_token',
        },
      );

      if (response.statusCode == 200) {
        return ClubPartnerResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load club partners: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load club partners: $e');
    }
  }
}
