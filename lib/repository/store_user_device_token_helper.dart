// // import 'package:http/http.dart' as http;
// // import 'dart:convert';

// // class DeviceTokenService {
// //   final String baseUrl;

// //   DeviceTokenService({this.baseUrl = 'http://127.0.0.1:8000'});

// //   Future<DeviceTokenResponse> storeDeviceToken({
// //     required int userId,
// //     required String deviceToken,
// //     required String osType,

// //   }) async {
// //     try {
// //       final uri = Uri.parse('$baseUrl/api/store-device-token').replace(
// //         queryParameters: {
// //           'user_id': userId.toString(),
// //           'device_token': deviceToken,
// //           'os_type': osType,
// //         },
// //       );

// //       final response = await http.get(uri);

// //       if (response.statusCode == 200) {
// //         return DeviceTokenResponse.fromJson(
// //           json.decode(response.body) as Map<String, dynamic>,
// //         );
// //       } else {
// //         throw Exception(
// //           'Failed to store device token. Status code: ${response.statusCode}',
// //         );
// //       }
// //     } catch (e) {
// //       throw Exception('Error storing device token: $e');
// //     }
// //   }
// // }

// // class DeviceTokenResponse {
// //   final bool success;
// //   final String message;

// //   DeviceTokenResponse({required this.success, required this.message});

// //   factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) {
// //     return DeviceTokenResponse(
// //       success: json['success'] ?? false,
// //       message: json['message'] ?? '',
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {'success': success, 'message': message};
// //   }
// // }
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class DeviceTokenService {
//   final String baseUrl;

//   DeviceTokenService({this.baseUrl = 'http://127.0.0.1:8000'});

//   Future<DeviceTokenResponse> storeDeviceToken({
//     required int userId,
//     required String deviceToken,
//     required String osType,
//   }) async {
//     try {
//       // Get user ID from SharedPreferences as a fallback (optional)
//       final prefs = await SharedPreferences.getInstance();
//       final storedUserId = prefs.getInt('user_id');

//       print('Storing device token with:');
//       print('API User ID: $userId');
//       print('Stored User ID: $storedUserId');
//       print('Device Token: $deviceToken');
//       print('OS Type: $osType');

//       final uri = Uri.parse('$baseUrl/api/store-device-token').replace(
//         queryParameters: {
//           'user_id': userId.toString(),
//           'device_token': deviceToken,
//           'os_type': osType,
//         },
//       );

//       print('Making request to: ${uri.toString()}');

//       final response = await http.get(uri);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         return DeviceTokenResponse.fromJson(
//           json.decode(response.body) as Map<String, dynamic>,
//         );
//       } else {
//         throw Exception(
//           'Failed to store device token. Status code: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       print('Error in storeDeviceToken: $e');
//       throw Exception('Error storing device token: $e');
//     }
//   }
// }

// class DeviceTokenResponse {
//   final bool success;
//   final String message;

//   DeviceTokenResponse({required this.success, required this.message});

//   factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) {
//     return DeviceTokenResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {'success': success, 'message': message};
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeviceTokenService {
  final String baseUrl;

  DeviceTokenService({this.baseUrl = 'https://hsi.realrisktakers.com'});

  Future<DeviceTokenResponse> storeDeviceToken({
    required int userId,
    required String deviceToken,
    required String osType,
  }) async {
    try {
      debugPrint('Storing token for user $userId');
      debugPrint('Token: $deviceToken');
      debugPrint('OS: $osType');

      final uri = Uri.parse('$baseUrl/api/store-device-token').replace(
        queryParameters: {
          'user_id': userId.toString(),
          'device_token': deviceToken,
          'os_type': osType,
        },
      );

      debugPrint('API Endpoint: ${uri.toString()}');

      final response = await http.get(uri);

      debugPrint('Response Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return DeviceTokenResponse.fromJson(
          json.decode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Token Storage Error: $e');
      rethrow;
    }
  }
}

class DeviceTokenResponse {
  final bool success;
  final String message;

  DeviceTokenResponse({required this.success, required this.message});

  factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) {
    return DeviceTokenResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
