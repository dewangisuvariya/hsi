import 'dart:convert';
import 'package:hsi/Model/notices_model.dart';
import 'package:http/http.dart' as http;

class NoticeApiHelper {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api/';

  Future<NoticeResponse> fetchNotices() async {
    try {
      final response = await http.get(Uri.parse('${_baseUrl}fetch-notices'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return NoticeResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load notices: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch notices: $e');
    }
  }
}
