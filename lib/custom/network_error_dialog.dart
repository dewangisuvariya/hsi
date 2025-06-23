// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class NetworkErrorDialog extends StatelessWidget {
//   final VoidCallback onOk;

//   const NetworkErrorDialog({Key? key, required this.onOk}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: const Color(0xFF292929),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
//       titlePadding: const EdgeInsets.all(10),
//       contentPadding: const EdgeInsets.all(10),
//       title: Image.asset(
//         "assets/images/warning 1.png",
//         height: 61.h,
//         width: 61.w,
//       ),
//       content: Text(
//         'Network error, please try again',
//         style: TextStyle(
//           fontSize: 14.sp,
//           color: Colors.white,
//           fontWeight: FontWeight.w500,
//           fontFamily: "Poppins",
//         ),
//         textAlign: TextAlign.center,
//       ),
//       actionsAlignment: MainAxisAlignment.center,
//       actionsPadding: const EdgeInsets.only(bottom: 16.0),
//       actions: [
//         ElevatedButton(
//           onPressed: onOk,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF42A5FF),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 24.0,
//               vertical: 8.0,
//             ),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(3.r),
//             ),
//             fixedSize: Size(100.w, 32.h),
//           ),
//           child: Text(
//             'Ok',
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.white,
//               fontWeight: FontWeight.w600,
//               fontFamily: "Poppins",
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void showNetworkErrorDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // Prevent closing by tapping outside
//       builder:
//           (context) => NetworkErrorDialog(onOk: () => Navigator.pop(context)),
//     );
//   }
// }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';

// // class NetworkErrorDialog extends StatelessWidget {
// //   final VoidCallback onOk;

// //   const NetworkErrorDialog({Key? key, required this.onOk}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return AlertDialog(
// //       backgroundColor: const Color(0xFF292929),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
// //       titlePadding: const EdgeInsets.all(10),
// //       contentPadding: const EdgeInsets.all(10),
// //       title: Image.asset(
// //         "assets/images/warning 1.png",
// //         height: 61.h,
// //         width: 61.w,
// //       ),
// //       content: Text(
// //         'Network error, please try again',
// //         style: TextStyle(
// //           fontSize: 14.sp,
// //           color: Colors.white,
// //           fontWeight: FontWeight.w500,
// //           fontFamily: "Poppins",
// //         ),
// //         textAlign: TextAlign.center,
// //       ),
// //       actionsAlignment: MainAxisAlignment.center,
// //       actionsPadding: const EdgeInsets.only(bottom: 16.0),
// //       actions: [
// //         ElevatedButton(
// //           onPressed: () {
// //             Navigator.of(context).pop(); // Close the dialog first
// //             onOk(); // Then call the callback
// //           },
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: const Color(0xFF42A5FF),
// //             padding: const EdgeInsets.symmetric(
// //               horizontal: 24.0,
// //               vertical: 8.0,
// //             ),
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(3.r),
// //             ),
// //             fixedSize: Size(100.w, 32.h),
// //           ),
// //           child: Text(
// //             'Ok',
// //             style: TextStyle(
// //               fontSize: 14.sp,
// //               color: Colors.white,
// //               fontWeight: FontWeight.w600,
// //               fontFamily: "Poppins",
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// // }
