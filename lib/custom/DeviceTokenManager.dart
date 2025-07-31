import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';

class DeviceTokenManager {
  static final Uuid _uuid = Uuid();

  static Future<String> generateDeviceToken() async {
    try {
      // Try to get a unique device identifier first
      final deviceId = await _getDeviceIdentifier();
      if (deviceId.isNotEmpty) {
        return deviceId;
      }

      // Fallback to UUID if no device identifier is available
      return _uuid.v4(); // Generates a random UUID
    } catch (e) {
      // Final fallback to a simple timestamp-based ID
      return 'device_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  static Future<String> _getDeviceIdentifier() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Android ID (unique to device)
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? ''; // IDFV (vendor-specific)
    }

    return ''; // No device-specific ID available
  }

  static Future<String> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release} (${androidInfo.model})';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion} (${iosInfo.utsname.machine})';
    }
    return 'Unknown Device';
  }
}
