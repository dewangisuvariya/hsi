import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../Model/sign_up_model.dart';

class UserApi {
  static const String _baseUrl = 'https://hsi.realrisktakers.com/api';

  static Future<RegisterUserResponse> registerUser(
    RegisterUserRequest request,
  ) async {
    // final prefs = await SharedPreferences.getInstance();
    // int? userId = prefs.getInt('user_id');

    // if (userId == null) {}

    try {
      // Create multipart request
      var uri = Uri.parse('$_baseUrl/register-user');
      var requestMultipart = http.MultipartRequest('POST', uri);

      // Convert all fields to String and add them
      final fields = request.toJson();
      final stringFields = fields.map<String, String>(
        (key, value) => MapEntry(key, value.toString()),
      );
      requestMultipart.fields.addAll(stringFields);

      // Add profile picture if exists
      if (request.profilePic != null) {
        var file = await http.MultipartFile.fromPath(
          'profile_pic',
          request.profilePic!.path,
          contentType: MediaType('image', 'jpeg'),
        );
        requestMultipart.files.add(file);
      }

      // Add headers if needed
      requestMultipart.headers.addAll({
        'Accept': 'application/json',
        // 'Authorization': 'Bearer your_token', // Add if required
      });

      // Send request
      var streamedResponse = await requestMultipart.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Handle response
      if (response.statusCode == 200) {
        return RegisterUserResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to register user. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }
}
