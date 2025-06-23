import 'dart:io';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/provider/SelectedIndexProvider.dart';
import 'package:hsi/provider/UserProfileProvider.dart';
import 'package:hsi/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure Icelandic locale is loaded
  await initializeDateFormatting('is_IS', null);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder:
            (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => SelectedIndexProvider()),
                ChangeNotifierProvider(
                  create: (_) => BackgroundColorProvider(),
                ),
                ChangeNotifierProvider(
                  create: (context) => UserProfileProvider(),
                ),
              ],
              child: const MyApp(),
            ),
      ),
    );
  });
}

class BatteryOptimization {
  static Future<void> disableBatteryOptimization(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        const packageName =
            'com.your.package.name'; // Replace with your actual package name

        // Try standard Android intent first
        try {
          final intent = AndroidIntent(
            action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
            data: 'package:$packageName',
          );
          await intent.launch();
          return;
        } catch (e) {
          debugPrint("Standard intent failed: $e");
        }

        // Fallback for Samsung devices
        try {
          final samsungIntent = AndroidIntent(
            action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
            data: 'package:$packageName',
          );
          await samsungIntent.launch();
        } catch (e) {
          debugPrint("Samsung intent failed: $e");
          // Final fallback - open app info page
          if (await canLaunchUrl(
            Uri.parse("settings:app-info?package=$packageName"),
          )) {
            await launchUrl(
              Uri.parse("settings:app-info?package=$packageName"),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Please disable battery optimization for this app in settings",
                ),
              ),
            );
          }
        }
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to disable battery optimization: ${e.message}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final designSize =
            isLargeScreen ? const Size(744, 1133) : const Size(414, 736);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
