import 'package:hsi/Model/useventeen-unineteen_videos_details_by_level_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class U17U19VideosApiHelper {
  static const String baseUrl = 'https://hsi.realrisktakers.com/api';

  static Future<VideoDetailsModel?> fetchU17U19Videos(int levelId) async {
    final url = Uri.parse(
      '$baseUrl/fetch-u17-u19-videos-details?level_id=$levelId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the JSON response into our model
        final jsonData = json.decode(response.body);
        return VideoDetailsModel.fromJson(jsonData);
      } else {
        print('Failed to fetch video details. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching video details: $e');
      return null;
    }
  }

  // Additional helper method to get videos grouped by type
  static Future<Map<String, List<VideoItem>>?> getGroupedVideos(
    int levelId,
  ) async {
    final videoDetails = await fetchU17U19Videos(levelId);

    if (videoDetails != null) {
      return {
        'warmUp': videoDetails.warmUpVideos,
        'exercise': videoDetails.exerciseVideos,
      };
    }
    return null;
  }

  // Helper method to get all videos combined
  static Future<List<VideoItem>?> getAllVideos(int levelId) async {
    final videoDetails = await fetchU17U19Videos(levelId);

    if (videoDetails != null) {
      return [...videoDetails.warmUpVideos, ...videoDetails.exerciseVideos];
    }
    return null;
  }
}
