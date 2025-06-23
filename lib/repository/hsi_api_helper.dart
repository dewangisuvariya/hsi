import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/hsi_model.dart';

class ApiHelper {
  static final ApiHelper _instance = ApiHelper._privateConstructor();
  ApiHelper._privateConstructor();
  static ApiHelper get instance => _instance;

  Future<List<AboutHsiSection>> fetchAboutHsiSections() async {
    try {
      final response = await http.get(
        Uri.parse("https://hsi.realrisktakers.com/api/about-hsi-sections"),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> sections = jsonData["data"] ?? [];
        return sections.map((e) => AboutHsiSection.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
