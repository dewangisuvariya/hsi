import 'package:http/http.dart' as http;

class SportInstructionsApiHelper {
  static const String baseUrl = 'https://hsi.realrisktakers.com/api';

  static Future<http.Response?> fetchSportInstructionDetails({
    required int instructionId,
    required String type,
  }) async {
    final url = Uri.parse(
      '$baseUrl/fetch-sport-instructions-details?sport_instruction_id=$instructionId&type=$type',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response;
      } else {
        print(
          'Failed to fetch sport instruction details. Status: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('Error fetching sport instruction details: $e');
      return null;
    }
  }
}
