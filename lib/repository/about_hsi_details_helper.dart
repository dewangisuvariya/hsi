// about_hsi_details_helper.dart
import 'dart:convert';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:http/http.dart' as http;

class AboutHsiDetailsHelper {
  static Future<AboutHsiDetailsResponse> fetchAboutHsiDetails(
    int subSectionId,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://hsi.realrisktakers.com/api/about-hsi-details?sub_section_id=$subSectionId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return AboutHsiDetailsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load about HSI details. Status code: ${response.statusCode}',
      );
    }
  }
}
