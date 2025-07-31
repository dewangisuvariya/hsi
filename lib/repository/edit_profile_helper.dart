import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hsi/Model/edit_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiHelper {
  static const String _baseUrl = "https://hsi.realrisktakers.com/api/";
  static const int _timeoutSeconds = 30;

  static Future<Map<String, dynamic>> multipartPost(
    String endpoint, {
    required Map<String, String> fields,
    File? file,
    String fileFieldName = 'file',
    Map<String, String>? headers,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(_baseUrl + endpoint),
      );

      request.headers.addAll(headers ?? {});
      request.fields.addAll(fields);

      if (file != null && await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      var response = await request.send().timeout(
        Duration(seconds: _timeoutSeconds),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to upload: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on TimeoutException catch (e) {
      throw Exception('Request timed out: ${e.message}');
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl + endpoint),
        headers: headers ?? {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}

class UserEditProfileApi {
  static Future<EditProfileResponse> editUserProfile(
    EditProfileRequest request,
  ) async {
    try {
      if (request.profilePic != null) {
        final response = await ApiHelper.multipartPost(
          'edit-user-profile',
          fields: request.toFormFields(),
          file: request.profilePic,
          fileFieldName: 'profile_pic',
          headers: {
            'Authorization': 'Bearer YOUR_TOKEN', // Add if needed
          },
        );
        return EditProfileResponse.fromJson(response);
      } else {
        final response = await ApiHelper.post(
          'edit-user-profile',
          body: request.toJson(),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer YOUR_TOKEN', // Add if needed
          },
        );
        return EditProfileResponse.fromJson(response);
      }
    } catch (e) {
      debugPrint('Profile update error: $e');
      rethrow;
    }
  }
}
