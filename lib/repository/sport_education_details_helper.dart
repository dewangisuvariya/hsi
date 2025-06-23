import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hsi/Model/sport_education_details_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<SportEducationDetailsModel?> fetchSportEducationDetails({
    required int sportEducationId,
    required String type,
  }) async {
    final url = Uri.parse(
      "https://hsi.realrisktakers.com/api/fetch-sport-education-details",
    ).replace(
      queryParameters: {
        'sport_education_id': sportEducationId.toString(),
        'type': type,
      },
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        debugPrint("Details API Response: $jsonData");

        if (jsonData is Map<String, dynamic>) {
          return SportEducationDetailsModel.fromJson(jsonData);
        } else {
          debugPrint("Unexpected response format");
          return null;
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}
