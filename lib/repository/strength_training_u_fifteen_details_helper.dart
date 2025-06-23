import 'dart:convert';
import 'package:hsi/Model/strength_training_u_fifteen_details_model.dart';
import 'package:http/http.dart' as http;

class StrengthTrainingU15Api {
  static const String _baseUrl = "https://hsi.realrisktakers.com/api/";

  Future<StrengthTrainingU15Response> fetchStrengthTrainingDetails(
    int id,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${_baseUrl}fetch-strength-training-u15-details?strength_training_u15_id=$id",
      ),
    );

    if (response.statusCode == 200) {
      return StrengthTrainingU15Response.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load strength training details');
    }
  }
}
