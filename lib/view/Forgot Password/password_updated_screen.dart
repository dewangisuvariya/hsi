import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_in_screen.dart';

// Display the password update Success screen when the user's password is updated successfully
class PasswordUpdatedScreen extends StatefulWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  State<PasswordUpdatedScreen> createState() => _PasswordUpdatedScreenState();
}

class _PasswordUpdatedScreenState extends State<PasswordUpdatedScreen> {
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
                        onPressed: () => Navigator.pop(context),
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
                                resetPasswordImage,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Flexible(
                              child: Text(
                                'Lykilorð uppfært',
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
          // Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),

                  SizedBox(height: 16.h),
                  Container(
                    width: 200.w,
                    height: 110.h,

                    child: Image.asset(resetPasswordOne, fit: BoxFit.contain),
                  ),
                  SizedBox(height: 34.h),
                  Text(
                    'Lykilorðið þitt hefur verið uppfært.',
                    style: emailOtpScreenTextStyle,
                  ),
                  SizedBox(height: 212.h),

                  CustomElevatedButton(
                    text: "Innskráning",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
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
