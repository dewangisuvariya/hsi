import 'dart:convert';
import 'package:hsi/Model/core_training_and_plyometric_video_details_model.dart';
import 'package:http/http.dart' as http;

class PlyometricVideoDetailsHelper {
  static Future<PlyometricVideoDetailsModel?> fetchVideoDetails(
    int detailId,
  ) async {
    final url = Uri.parse(
      'https://hsi.realrisktakers.com/api/fetch-core-training/plyometric-video-details?sport_core_training_plyometric_details_id=$detailId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return PlyometricVideoDetailsModel.fromJson(jsonBody);
      } else {
        print(
          'Failed to fetch plyometric video details. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception while fetching video details: $e');
    }

    return null;
  }
}
