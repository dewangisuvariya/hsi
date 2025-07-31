import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/custom/custom_password_text_from_field.dart';
import 'package:hsi/repository/reset_password_helper.dart';
import 'package:hsi/view/Forgot%20Password/password_updated_screen.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_in_screen.dart';

// Load reset password details from the web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPasswordMismatchError = false;
  // Pass data to ResetPasswordHelper via the web service when the user wants to verify the code
  Future<void> _submitForm() async {
    // Check if passwords match first
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _showPasswordMismatchError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showPasswordMismatchError = false;
    });

    try {
      final service = PasswordResetService();
      final response = await service.resetPassword(
        email: widget.email,
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (response.success) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordUpdatedScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              onPressed: () => Navigator.pop(context),
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
                                    resetPasswordImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return errorImageContainer();
                                    },
                                  ),
                                ),
                                SizedBox(width: 13.w),
                                Flexible(
                                  child: Text(
                                    'Endurstilla lykilorðið',
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),

                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Lykilorðið þitt verður að vera að minnsta kosti 6 stafir að lengd',

                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Color(0xFF757575),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13.h),
                        CustomPasswordField(
                          hintText: "Nýtt lykilorð*",
                          iconPath: lock,
                          controller: _passwordController,
                        ),
                        SizedBox(height: 18.h),
                        CustomPasswordField(
                          hintText: "Staðfestu lykilorð*",
                          iconPath: lock,
                          controller: _confirmPasswordController,
                        ),
                        if (_showPasswordMismatchError)
                          Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Text(
                              "Lykilorðið verður að vera svipað.",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        SizedBox(
                          height: _showPasswordMismatchError ? 185.h : 210.h,
                        ),
                        CustomElevatedButton(
                          text: "Uppfæra",
                          onPressed: _submitForm,
                        ),
                        SizedBox(height: 33.h),
                        TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(arrowLeft, width: 20.w, height: 20.h),
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
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
