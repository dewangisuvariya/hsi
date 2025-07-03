// import 'dart:io';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/firebase_options.dart';
// import 'package:hsi/provider/BackgroundColorProvider.dart';
// import 'package:hsi/provider/SelectedIndexProvider.dart';
// import 'package:hsi/provider/UserProfileProvider.dart';
// import 'package:hsi/view/splash_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:url_launcher/url_launcher.dart';

// void main() async {
//   FlutterError.onError = (errorDetails) {
//     FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
//   };

//   // Catch asynchronous errors
//   PlatformDispatcher.instance.onError = (error, stack) {
//     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//     return true;
//   };
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   // Initialize Crashlytics
//   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
//   // Ensure Icelandic locale is loaded
//   await initializeDateFormatting('is_IS', null);
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
//     _,
//   ) {
//     runApp(
//       DevicePreview(
//         enabled: !kReleaseMode,
//         builder:
//             (context) => MultiProvider(
//               providers: [
//                 ChangeNotifierProvider(create: (_) => SelectedIndexProvider()),
//                 ChangeNotifierProvider(
//                   create: (_) => BackgroundColorProvider(),
//                 ),
//                 ChangeNotifierProvider(
//                   create: (context) => UserProfileProvider(),
//                 ),
//               ],
//               child: const MyApp(),
//             ),
//       ),
//     );
//   });
// }

// class BatteryOptimization {
//   static Future<void> disableBatteryOptimization(BuildContext context) async {
//     try {
//       if (Platform.isAndroid) {
//         const packageName =
//             'com.your.package.name'; // Replace with your actual package name

//         // Try standard Android intent first
//         try {
//           final intent = AndroidIntent(
//             action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
//             data: 'package:$packageName',
//           );
//           await intent.launch();
//           return;
//         } catch (e) {
//           debugPrint("Standard intent failed: $e");
//         }

//         // Fallback for Samsung devices
//         try {
//           final samsungIntent = AndroidIntent(
//             action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
//             data: 'package:$packageName',
//           );
//           await samsungIntent.launch();
//         } catch (e) {
//           debugPrint("Samsung intent failed: $e");
//           // Final fallback - open app info page
//           if (await canLaunchUrl(
//             Uri.parse("settings:app-info?package=$packageName"),
//           )) {
//             await launchUrl(
//               Uri.parse("settings:app-info?package=$packageName"),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   "Please disable battery optimization for this app in settings",
//                 ),
//               ),
//             );
//           }
//         }
//       }
//     } on PlatformException catch (e) {
//       debugPrint("Failed to disable battery optimization: ${e.message}");
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
//     }
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final isLargeScreen = constraints.maxWidth > 600;
//         final designSize =
//             isLargeScreen ? const Size(744, 1133) : const Size(414, 736);

//         return ScreenUtilInit(
//           designSize: designSize,
//           minTextAdapt: true,
//           splitScreenMode: true,
//           builder: (context, _) {
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               home: const SplashScreen(),
//             );
//           },
//         );
//       },
//     );
//   }
// }
import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/firebase_options.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/provider/SelectedIndexProvider.dart';
import 'package:hsi/provider/UserProfileProvider.dart';
import 'package:hsi/provider/homeScreenProvider.dart';
import 'package:hsi/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  // Register channel buffers early to prevent discarded messages
  const StandardMethodCodec().decodeMethodCall;

  // Run in a guarded zone for complete error handling
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase with platform-specific options
      await _initializeFirebase();

      // Set up error handlers
      _setupErrorHandling();

      // Ensure Icelandic locale is loaded
      await initializeDateFormatting('is_IS', null);

      // Set preferred orientation
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

      runApp(
        DevicePreview(
          enabled: !kReleaseMode,
          builder:
              (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    create: (_) => SelectedIndexProvider(),
                  ),
                  ChangeNotifierProvider(
                    create: (_) => BackgroundColorProvider(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => UserProfileProvider(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => HomeScreenState(),
                  ),
                ],
                child: const MyApp(),
              ),
        ),
      );
    },
    (error, stack) {
      // Catch any errors occurring outside the Flutter framework
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configure Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Set user identifier if available (replace with your user ID system)
    // FirebaseCrashlytics.instance.setUserIdentifier("user123");

    // Add custom key for tracking (optional)
    // await FirebaseCrashlytics.instance.setCustomKey("flutter_version", Flutter.version);
  } catch (e, stack) {
    // If Firebase initialization fails, log the error
    debugPrint("Firebase initialization failed: $e");
    FirebaseCrashlytics.instance.recordError(e, stack, fatal: true);
    rethrow;
  }
}

void _setupErrorHandling() {
  // Handle Flutter framework errors
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);

    // Also log to console for local debugging
    if (kDebugMode) {
      FlutterError.presentError(errorDetails);
    }
  };

  // Handle asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true; // Prevents the error from being thrown again
  };

  // Catch any uncaught Dart exceptions
  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      final errorAndStacktrace = pair as List<dynamic>;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort,
  );
}

// class BatteryOptimization {
//   static Future<void> disableBatteryOptimization(BuildContext context) async {
//     try {
//       if (Platform.isAndroid) {
//         const packageName = 'com.handknattleikssamband.hsi';

//         // Try standard Android intent first
//         try {
//           final intent = AndroidIntent(
//             action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
//             data: 'package:$packageName',
//           );
//           await intent.launch();
//           return;
//         } catch (e) {
//           debugPrint("Standard intent failed: $e");
//           FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
//         }

//         // Fallback for Samsung devices
//         try {
//           final samsungIntent = AndroidIntent(
//             action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
//             data: 'package:$packageName',
//           );
//           await samsungIntent.launch();
//         } catch (e) {
//           debugPrint("Samsung intent failed: $e");
//           FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

//           // Final fallback - open app info page
//           if (await canLaunchUrl(
//             Uri.parse("settings:app-info?package=$packageName"),
//           )) {
//             await launchUrl(
//               Uri.parse("settings:app-info?package=$packageName"),
//             );
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                   "Please disable battery optimization for this app in settings",
//                 ),
//               ),
//             );
//           }
//         }
//       }
//     } on PlatformException catch (e) {
//       debugPrint("Failed to disable battery optimization: ${e.message}");
//       FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
//     }
//   }
// }

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
