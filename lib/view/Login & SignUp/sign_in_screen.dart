import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/custom/custom_password_text_from_field.dart';
import 'package:hsi/custom/custom_text_form_field.dart';
import 'package:hsi/repository/login_helper.dart';
import 'package:hsi/view/Forgot%20Password/forgot_password_screen.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_up_screen.dart';
import 'package:hsi/view/footer_screen/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Display the user sign in screen details
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  bool _rememberMe = true;

  @override
  void dispose() {
    emailInputController.dispose();
    passwordInputController.dispose();
    super.dispose();
  }

  // Load data from the LoginHelper class via the web service.
  void loginUser() async {
    try {
      final response = await ApiHelper.loginUser(
        email: emailInputController.text,
        password: passwordInputController.text,
      );

      if (response.success) {
        // Save login state
        print(
          'Login Response: Success=${response.success}, UserID=${response.userId}',
        );
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLoggedIn', true);
        await prefs.setBool('rememberMe', _rememberMe);
        if (response.userId != null) {
          await prefs.setInt('user_id', response.userId!);
          print('Saved UserID to SharedPreferences: ${response.userId}');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login successful.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            ),
          );
        }
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => BottomNavBarWidget()),
          );
        }
        print('Login successful!');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed'),
              duration: const Duration(seconds: 1),
              backgroundColor: Colors.red,
            ),
          );
        }
        print('Login failed: ${response.message}');
        // You can show this message to the user
        if (response.message == 'Please verify your email first.') {
          // Navigate to email verification screen
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error: $e');
    } finally {
      if (mounted) {}
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 220.h,
              decoration: BoxDecoration(
                color: backgroundColorContainer,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(26.r),
                  bottomLeft: Radius.circular(26.r),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 72.h),
                    Image.asset(hsiLogo, width: 107.w, height: 74.55.h),
                    SizedBox(height: 12.h),
                    Text(
                      "HANDKNATTLEIKSSAMBAND ÍSLANDS",
                      style: titleTextStyle,
                    ),
                    SizedBox(height: 38.h),
                    SizedBox(height: 30.h),
                    Text(
                      "Innskráning",
                      style: TextStyle(
                        fontSize: 22.sp,
                        color: selectedDividerColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "Tölvupóstur*",
                            iconPath: email,
                            controller: emailInputController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 18.h),
                          CustomPasswordField(
                            hintText: "Lykilorð*",
                            iconPath: lock,
                            controller: passwordInputController,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 15.w,
                                    height: 15.r,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      activeColor: const Color(0xFF0B80FF),
                                      checkColor: Colors.white,
                                      side: BorderSide(
                                        color: subTitleColor,
                                        width: 1,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text(
                                    "Mundu eftir mér",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: subTitleColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Gleymt lykilorð?",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: selectedDividerColor,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 70.h),
                          CustomElevatedButton(
                            text: "Innskráning",
                            onPressed: loginUser,
                          ),
                          SizedBox(height: 33.h),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: subTitleColor,
                                fontFamily: "Poppins",
                              ),
                              children: [
                                TextSpan(text: "Ertu ekki með aðgang? "),
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => RegistrationPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Skráning",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: selectedDividerColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 33.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
