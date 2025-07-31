import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

final backgroundColor = Color(0xFFFAFAFA);
final backgroundColorContainer = Color(0xFF41a5ff);
final appBarColor = Color(0xFF292929);
final selectedDividerColor = Color(0xFFF28E2B);
final unselectedDividerColor = Colors.grey;
final loadingAnimationWidgetColor = Colors.blue;

// LeagueTile
final textColorLeagueTile = Color(0XFF292929);
final selectLeagueTileColor = Color(0xFFEDEDED);
final unselectLeagueTileColor = Color(0xFFFAFAFA);
final selectedCircleAvatarcolor = Color(0XFFA0A0A0);
final unselectedCircleAvatarcolor = Color(0XFFE6E6E6);
final pdfContainerColor = Color(0xFFF0F0F0);

// partner club
final selectedCart = Color(0XFF292929);
final unselectedCart = Color(0xFFEDEDED);

// success at majer tournaments
final containerSuccesAtMajorTorunamentColor = Color(0xFFE9E9E9);

// coaches screen for junior

final subTitleColor = Color(0xFF757575);
// home screen
final redButtonWithWhiteBorder = ElevatedButton.styleFrom(
  backgroundColor: const Color(0xFFFF141F),
  fixedSize: Size(103.w, 32.h),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(8.r),
    side: const BorderSide(color: Colors.white, width: 2),
  ),
  padding: EdgeInsets.zero,
);

final titleTextStyle = TextStyle(
  fontSize: 15.sp,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: "Poppins",
);

final drawerButtonStyle = TextStyle(
  fontSize: 14.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
);

final loadingAnimation = LoadingAnimationWidget.newtonCradle(
  color: loadingAnimationWidgetColor,
  size: 120,
);

Widget buildAnimatedDivider(int index, int? isSelected) {
  final selectedIndex = isSelected == index;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Divider(
      color:
          selectedIndex == index
              ? selectedDividerColor
              : unselectedDividerColor,
      thickness: selectedIndex == index ? 3 : 1,
      height: 4,
    ),
  );
}

final borderContainerDecoration = BoxDecoration(
  color: Color(0xFFFAFAFA),
  borderRadius: BorderRadius.circular(8.r),
  border: Border.all(color: Color(0xFFD9D9D9), width: 0.8),
);
// success at majer tournaments

final textStyleTournaments = TextStyle(
  fontWeight: FontWeight.w400,
  fontSize: 11.sp,
  fontFamily: "Poppins",
  color: Colors.black,
);

final tournamentNameTextStyle = TextStyle(
  fontSize: 18.sp,
  fontWeight: FontWeight.w600,
  fontFamily: "Poppins",
);

// handbook
final pdfButtonTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  fontFamily: "Poppins",
  color: Color(0xFF1E1E1E),
);
final pdfTitleTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
  color: Color(0xFF757575),
);
// coaches screen for junior

final coachesNameTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  color: Color(0xFF000000),
  fontFamily: 'Poppins',
);

final subTitleTextStyle = TextStyle(
  fontSize: 14.sp,
  color: subTitleColor,
  fontFamily: 'Poppins', // Use a font that supports special characters
);

final nameOfTournamentTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  color: Color(0xFF1E1E1E),
  fontFamily: 'Poppins',
);

final headingTextStyle = TextStyle(
  fontSize: 16.sp,
  fontFamily: 'Poppins',
  color: Color(0xFF757575),
);
// junior team week

final durationTextStyle = TextStyle(
  fontSize: 14.sp,
  color: Color(0xFF757575),
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
);
final planningTextStyle = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
  color: Color(0xFF000000),
);

final weekTeamHeadingTextStyle = TextStyle(
  fontSize: 15.sp,
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
  color: Color(0xFF1E1E1E),
);

// national team week  for man and women

final titleBarTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w600,
  color: Color(0xFF1E1E1E),
  fontFamily: "Poppins",
);
final titleOfCoachOrTeamTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  color: Color(0xFF000000),
  fontFamily: "Poppins",
);

final subtitleOfCoachOrTeamTextStyle = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w400,
  color: subTitleColor,
);
final subtitleOfCoachTextStyle = TextStyle(
  fontSize: 14.sp,
  color: Color(0xFF757575),
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
);

Widget errorImageContainer() {
  return Container(
    // color: Colors.black,
    child: Image.asset(
      errorImage,
      width: 30.w,
      height: 30.h,
      fit: BoxFit.fill,
      color: Colors.white,
    ),
  );
}
// appbar text style

final appBarTextStyle = TextStyle(
  fontSize: 20.sp,
  color: Colors.white,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
);

// partner club

final partnerClubCoachTitleTextStyle = TextStyle(
  fontSize: 12.sp,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: "Poppins",
);

final partnerClubCoachSubtitleTextStyle = TextStyle(
  fontSize: 10.sp,
  color: Colors.black,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
);

final descriptionTextStyle = TextStyle(
  fontSize: 14.sp,
  color: Color(0xFF1E1E1E),
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
);
//  men women tab screen

final menWoemTubScreenSubtitleTextStyle = TextStyle(
  fontSize: 12.sp,
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
);

final menWoemTubScreenTitleTextStyle = TextStyle(
  fontSize: 9.5.sp,
  color: Colors.white,
  fontWeight: FontWeight.w600,
  fontFamily: "Poppins",
);

final subtitleofAboutHsiTextStyle = TextStyle(
  fontSize: 14.sp,
  color: Color(0xFF1E1E1E),
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
);

final emailOtpScreenTextStyle = TextStyle(
  fontSize: 14.sp,
  color: Color(0xFF292929),
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
);

final userNameTextStyle = TextStyle(
  fontSize: 16.sp,
  color: Color(0xFF292929),
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
);
final profiletitleTextStyle = TextStyle(
  fontSize: 16.sp,
  color: Color(0xFF292929),
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
);
// sport eduction

final videoListTitleTextStyle = TextStyle(
  color: const Color(0XFF000000),
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
);

final videoSubtitleTextStyle = TextStyle(
  fontSize: 14.sp,
  fontWeight: FontWeight.w400,
  fontFamily: "Poppins",
  color: const Color(0xFF757575),
);

final videoTitleTextStyle = TextStyle(
  fontSize: 16.sp,
  fontWeight: FontWeight.w500,
  fontFamily: "Poppins",
  color: const Color(0xFF000000),
);
