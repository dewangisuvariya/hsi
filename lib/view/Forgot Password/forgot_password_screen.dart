import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/custom/custom_text_form_field.dart';
import 'package:hsi/view/Forgot%20Password/otp_verify_forgot_password_screen.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_in_screen.dart';
import '../../repository/forgot_password_helper.dart';

// Load forgot password details from the web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ForgotPasswordScreen extends StatefulWidget {
  // Add a parameter to track where the screen was navigated from
  final bool cameFromChangePassword;

  const ForgotPasswordScreen({super.key, this.cameFromChangePassword = false});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _message;
  bool _isError = false;

  // Load data from ForgotPasswordHelper class via the web service.
  Future<void> _sendResetCode() async {
    // Validate email
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      setState(() {
        _message = 'Please enter a valid email address';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
      _isError = false;
    });

    try {
      final response = await ApiHelper.forgotPassword(_emailController.text);

      if (response.success) {
        // Only navigate if successful
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpVerifyForgotPasswordScreen(
                    email: _emailController.text,
                  ),
            ),
          );
        }
      } else {
        // Show API error message if success is false
        if (mounted) {
          setState(() {
            _message = response.message;

            _isError = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _message = 'No account found attached with this email address.';
          _isError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  // create structure of the screen

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable default back behavior
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => SignInScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 104.h,
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  // Navigate to SignInScreen when back arrow is pressed
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignInScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                icon: Image.asset(
                                  backArrow,
                                  height: 34.h,
                                  width: 80.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.h,
                                    child: Image.asset(
                                      forgotPassword,
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return errorImageContainer();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 13.w),
                                  Flexible(
                                    child: Text(
                                      'Gleymt lykilorð',
                                      textAlign: TextAlign.center,
                                      style: appBarTextStyle.copyWith(
                                        fontSize: 20.sp,
                                      ),
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 2, child: Container()),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Vinsamlegast sláðu inn netfangið þitt til að fá staðfestingarkóða.',
                                style: emailOtpScreenTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 40.h),
                              CustomTextField(
                                hintText: "Tölvupóstur*",
                                iconPath: email,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              if (_message != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Text(
                                    "Enginn reikningur fannst tengdur þessu netfangi.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Color(0xFFFF0000),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              _message != null
                                  ? SizedBox(height: 205.h)
                                  : SizedBox(height: 250.h),

                              CustomElevatedButton(
                                text: "Endurstilla lykilorð",
                                onPressed: _sendResetCode,
                              ),

                              SizedBox(height: 16.h),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignInScreen(),
                                    ),
                                    (route) => false,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      arrowLeft,
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                    SizedBox(width: 9.w),
                                    Text(
                                      'Til baka í innskráningu',
                                      style: durationTextStyle.copyWith(
                                        fontSize: 13.sp,
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
            if (_isLoading)
              Positioned.fill(child: Center(child: loadingAnimation)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
