import 'dart:convert';
import 'package:hsi/Model/core_training_and_plyometric_details_model.dart';
import 'package:http/http.dart' as http;

class PlyometricDetailsHelper {
  static Future<PlyometricDetailsModel?> fetchPlyometricDetails(
    int plyometricId,
  ) async {
    final url = Uri.parse(
      'https://hsi.realrisktakers.com/api/fetch-core-training/plyometric-details?plyometric_id=$plyometricId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return PlyometricDetailsModel.fromJson(jsonBody);
      } else {
        print(
          'Failed to load plyometric details. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching plyometric details: $e');
    }

    return null;
  }
}
