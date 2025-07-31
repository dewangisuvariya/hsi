import 'dart:convert';
import 'package:hsi/Model/live_feed_model.dart';
import 'package:http/http.dart' as http;

class LiveFeedApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api/';

  Future<LiveFeedResponse> fetchLiveFeed() async {
    try {
      final response = await http.get(
        Uri.parse('${_baseUrl}fetch-live-feed'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return LiveFeedResponse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load live feed. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch live feed: $e');
    }
  }

  // Cached version with expiry (optional)
  Future<LiveFeedResponse> fetchLiveFeedCached({
    Duration cacheDuration = const Duration(minutes: 5),
  }) async {
    // Implement your caching logic here if needed
    // This is just a placeholder showing the concept
    return fetchLiveFeed();
  }
}
