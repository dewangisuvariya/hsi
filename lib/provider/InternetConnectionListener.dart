// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:hsi/provider/ConnectivityServiceProvider.dart';

// import 'package:provider/provider.dart';

// class NavigationService {
//   static final NavigationService _instance = NavigationService._internal();

//   NavigationService._internal();

//   factory NavigationService() => _instance;

//   final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

//   dynamic goBack({dynamic popValue}) {
//     return navigationKey.currentState?.pop(popValue);
//   }

//   Future<dynamic> navigateTo(Widget page, {dynamic arguments}) async {
//     return navigationKey.currentState?.push(
//       MaterialPageRoute(builder: (_) => page),
//     );
//   }

//   Future<dynamic> replaceWith(Widget page, {dynamic arguments}) async {
//     return navigationKey.currentState?.pushReplacement(
//       MaterialPageRoute(builder: (_) => page),
//     );
//   }

//   void popToFirst() {
//     navigationKey.currentState?.popUntil((route) => route.isFirst);
//   }
// }

// void NoInternetScreen(BuildContext context) {
//   showDialog(
//     context: context,
//     builder:
//         (context) => AlertDialog(
//           backgroundColor: const Color(0xFF292929),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           titlePadding: const EdgeInsets.all(10),
//           contentPadding: const EdgeInsets.all(10),
//           title: Image.asset(
//             "assets/images/warning 1.png",
//             height: 61.h,
//             width: 61.w,
//           ),
//           content: Text(
//             'Network error, please try again',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.white,
//               fontWeight: FontWeight.w500,
//               fontFamily: "Poppins",
//             ),
//             textAlign: TextAlign.center,
//           ),
//           actionsAlignment: MainAxisAlignment.center,
//           actionsPadding: const EdgeInsets.only(bottom: 16.0),
//           actions: [
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF42A5FF),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24.0,
//                   vertical: 8.0,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(3.r),
//                 ),
//                 fixedSize: Size(100.w, 32.h),
//               ),
//               child: Text(
//                 'Ok',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontFamily: "Poppins",
//                 ),
//               ),
//             ),
//           ],
//         ),
//   );
// }

// mixin ConnectionAwareWidget<T extends StatefulWidget> on State<T> {
//   bool _isConnected = true;
//   bool _shouldReloadOnReconnect = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkInitialConnection();
//     _setupConnectionListener();
//   }

//   void setShouldReloadOnReconnect(bool shouldReload) {
//     if (mounted) {
//       setState(() {
//         _shouldReloadOnReconnect = shouldReload;
//       });
//     }
//   }

//   Future<void> _checkInitialConnection() async {
//     final isConnected = await InternetConnectionCheckerPlus().hasConnection;
//     if (mounted) {
//       setState(() {
//         _isConnected = isConnected;
//       });
//     }
//     if (!isConnected) {
//       _handleOffline();
//     }
//   }

//   void _setupConnectionListener() {
//     InternetConnectionCheckerPlus().onStatusChange.listen((status) {
//       final isConnected = status == InternetConnectionStatus.connected;

//       if (isConnected != _isConnected && mounted) {
//         setState(() {
//           _isConnected = isConnected;
//         });

//         if (isConnected) {
//           _handleOnline();
//         } else {
//           _handleOffline();
//         }
//       }
//     });
//   }

//   void _handleOnline() {
//     debugPrint('Connection restored - reloading data');
//     _loadData();
//   }

//   void _handleOffline() {
//     debugPrint('Connection lost');
//   }

//   Future<void> _loadData() async {
//     // Implement this in your screen
//     // This should be an async method that fetches data from the API
//   }
// }
