import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/repository/resend_verification_helper.dart';
import 'package:hsi/repository/verify_email_code_profile_update_helper.dart';
import 'package:hsi/view/Profile/profile_verified_success_screen.dart';
import 'package:pinput/pinput.dart';

// Load email and verification code from the web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ProfileOtpVerifyScreen extends StatefulWidget {
  final String email;

  const ProfileOtpVerifyScreen({super.key, required this.email});

  @override
  State<ProfileOtpVerifyScreen> createState() => _ProfileOtpVerifyScreenState();
}

class _ProfileOtpVerifyScreenState extends State<ProfileOtpVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isInvalidOtp = false;
  int _resendTime = 60;
  Timer? _timer;
  Timer? _resendTimer;
  bool _isResending = false;
  bool _isVerifying = false;
  @override
  void initState() {
    super.initState();
    _resendTime = 60;
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();

    _timer?.cancel();
    _resendTimer?.cancel();
    super.dispose();
  }

  // If the user's verification code is expired, show a timer when the user resends the code
  void _startResendTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTime > 0) {
        if (mounted) {
          // Check if widget is still mounted
          setState(() {
            _resendTime--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }
  // When the user's verification code expires, allow them to resend the verification code.
  // When the user wants to resend the verification code, pass the data to the ResendVerificationHelper class via the web service

  Future<void> _resendOtp() async {
    if (_resendTime > 0 || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      final response = await VerificationApi.resendVerificationCodeProfile(
        widget.email,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));

        if (response.success) {
          setState(() {
            _resendTime = 60;
            _startResendTimer();
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to resend code. Please try again.")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  // Pass data to VerifyEmailCodeProfileUpdateHelper via the web service when the user wants to verify the code
  void _verifyOtp() async {
    // Clear previous error when user tries again
    setState(() {
      _isInvalidOtp = false;
    });

    // Basic validation - check if OTP is 4 digits
    if (_otpController.text.length != 4) {
      setState(() {
        _isInvalidOtp = true;
      });
      return;
    }

    // Prevent multiple verification attempts
    if (_isVerifying) return;

    setState(() {
      _isVerifying = true;
    });

    try {
      final verificationCode = int.tryParse(_otpController.text);
      if (verificationCode == null) {
        setState(() {
          _isInvalidOtp = true;
        });
        return;
      }

      final result = await EmailVerificationHelper().verifyEmail(
        verificationCode: verificationCode,
      );

      if (result.isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileVerifiedSuccessScreen(),
          ),
        );
      } else {
        if (mounted) {
          setState(() {
            _isInvalidOtp = true;
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? "Verification failed")),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInvalidOtp = true;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });
      }
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45.w,
      height: 45.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: subTitleColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: _formKey,
        child: Column(
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
                          icon: Image.asset(
                            backArrow,
                            height: 34.h,
                            width: 80.w,
                          ),
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
                                  forgotPasswordOtp,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Flexible(
                                child: Text(
                                  'Staðfesting prófíls',
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
                    SizedBox(height: 30.h),

                    Text(
                      'Við höfum sent staðfestingarkóða á ${widget.email} til að samþykkja breytingar á prófílnum. ',
                      style: emailOtpScreenTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),
                    // OTP Input
                    Pinput(
                      length: 4,
                      controller: _otpController,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: defaultPinTheme.copyWith(
                        decoration: defaultPinTheme.decoration!.copyWith(
                          border: Border.all(color: Colors.blue),
                        ),
                      ),
                      errorPinTheme: defaultPinTheme.copyWith(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      // onCompleted: (pin) => _verifyOtp(),
                    ),
                    SizedBox(height: 16.h),
                    // Error Message
                    if (_isInvalidOtp)
                      Text(
                        'Ógilt einnota aðgangskóða. Reyndu aftur.',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color(0xFFFF0000),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    _isInvalidOtp
                        ? SizedBox(height: 23.h)
                        : SizedBox(height: 35.h),

                    Text(
                      'Senda aftur inn${_resendTime}s',
                      style: emailOtpScreenTextStyle.copyWith(fontSize: 13.sp),
                    ),

                    SizedBox(height: 85.h),

                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: subTitleColor,
                          fontFamily: "Poppins",
                        ),
                        children: [
                          TextSpan(text: "Fékk ekki kóða?  "),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: _resendOtp,
                              child: Text(
                                "Endursenda",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: selectedDividerColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 85.h),
                    // Submit Button
                    CustomElevatedButton(
                      text: "Halda áfram",
                      onPressed: _verifyOtp,
                    ),
                    SizedBox(height: 20.h),

                    // Back to Login
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
