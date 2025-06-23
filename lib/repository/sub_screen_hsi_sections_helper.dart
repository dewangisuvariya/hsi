// In your API helper or repository
import 'dart:convert';

import 'package:hsi/Model/sub_sectiono_about_hsi_model.dart';
import 'package:http/http.dart' as http;

Future<GeneralInfoResponse> fetchGeneralInfo(int sectionId) async {
  final response = await http.get(
    Uri.parse(
      'https://hsi.realrisktakers.com/api/general-info?section_id=$sectionId',
    ),
  );

  if (response.statusCode == 200) {
    return GeneralInfoResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load general info');
  }
}
