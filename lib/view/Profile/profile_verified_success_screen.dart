import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/view/Profile/profile_display_screen.dart';
import 'package:hsi/view/footer_screen/home_screen.dart';

// Display the Profile Verified Success screen when the user's profile is updated successfully
class ProfileVerifiedSuccessScreen extends StatefulWidget {
  const ProfileVerifiedSuccessScreen({super.key});

  @override
  State<ProfileVerifiedSuccessScreen> createState() =>
      _ProfileVerifiedSuccessScreenState();
}

class _ProfileVerifiedSuccessScreenState
    extends State<ProfileVerifiedSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            height: 104.h,
            decoration: BoxDecoration(
              color: appBarColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 8.0.h,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        icon: Image.asset(backArrow, height: 34.h, width: 80.w),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 12,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36.98.w,
                              height: 36.h,
                              child: Image.asset(
                                profileUserVector,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Flexible(
                              child: Text(
                                'Prófíll staðfest',
                                textAlign: TextAlign.center,
                                style: appBarTextStyle.copyWith(
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 2, child: SizedBox()),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Container(
                    width: 150.w,
                    height: 80.h,

                    child: Image.asset(profileUser, fit: BoxFit.contain),
                  ),
                  SizedBox(height: 34.h),
                  Text(
                    'Prófílnum þínum hefur verið breytt.',
                    style: emailOtpScreenTextStyle,
                  ),
                  SizedBox(height: 217.h),

                  CustomElevatedButton(
                    text: "Farðu í prófíl",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDisplayScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
