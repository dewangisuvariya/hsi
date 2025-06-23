import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_in_screen.dart';

// Display the email Verified Success screen when the user's  Sign in successfully
class EmailVerifiedSuccessScreen extends StatefulWidget {
  const EmailVerifiedSuccessScreen({super.key});

  @override
  State<EmailVerifiedSuccessScreen> createState() =>
      _EmailVerifiedSuccessScreenState();
}

class _EmailVerifiedSuccessScreenState
    extends State<EmailVerifiedSuccessScreen> {
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
                              child: Image.asset(email, fit: BoxFit.contain),
                            ),
                            SizedBox(width: 14.w),
                            Flexible(
                              child: Text(
                                'Netfang staðfest',
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
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),

                  SizedBox(height: 16.h),
                  Container(
                    width: 150.w,
                    height: 80.h,

                    child: Image.asset(emailVerified, fit: BoxFit.contain),
                  ),
                  SizedBox(height: 34.h),
                  Text(
                    'Netfangið þitt hefur verið staðfest.',
                    style: emailOtpScreenTextStyle,
                  ),
                  SizedBox(height: 227.h),

                  CustomElevatedButton(
                    text: "Innskráning",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInScreen()),
                      );
                    },
                  ),
                  SizedBox(height: 34.h),

                  // Back to Login
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
