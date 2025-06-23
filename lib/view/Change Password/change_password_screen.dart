import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/custom/custom_password_text_from_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/change_password_helper.dart';

// load password from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ChangePasswordScreen extends StatefulWidget {
  final Function(String)? onLogout;

  const ChangePasswordScreen({super.key, this.onLogout});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  dynamic userProfile;
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPasswordMatchError = false;
  bool _isLoading = false;

  // When the user changes the password, call the ChangePasswordHelper method and pass the data to it
  Future<void> _changePassword() async {
    // First check if all fields are filled
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your current password'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a new password'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please confirm your new password'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _showPasswordMatchError = true;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showPasswordMatchError = false;
    });

    try {
      final response = await ApiHelper.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _passwordController.text,
        newConfirmPassword: _confirmPasswordController.text,
      );

      setState(() => _isLoading = false);

      if (response.success) {
        _showSuccessDialog(response.message);
      } else {
        // Handle different error messages
        if (response.message ==
            "New password and confirm password do not match.") {
          setState(() {
            _showPasswordMatchError = true;
          });
        } else {
          _showErrorDialog(response.message);
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(e.toString());
    }
  }

  // Display a dialog box when the password is changed successfully.
  void _showSuccessDialog(String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: selectedCart,
          title: Image.asset(showSuccess, width: 73.w, height: 65.91.h),
          content: Text(
            textAlign: TextAlign.center,
            "Lykilorðið þitt hefur verið breytt með góðum árangri.",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    backgroundColor: Color(0xFF42a5ff),
                    foregroundColor: Colors.white,
                    minimumSize: Size(100.w, 35.39.h),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Allt í lagi"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Display a dialog box when the current password is incorrect
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: selectedCart,
          title: Image.asset(showError, width: 73.w, height: 64.01.h),
          content: Text(
            textAlign: TextAlign.center,
            "Núverandi lykilorð þitt er ógilt. Vinsamlegast sláðu inn gilt lykilorð.",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    backgroundColor: Color(0xFF42a5ff),
                    foregroundColor: Colors.white,
                    minimumSize: Size(100.w, 35.39.h),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Allt í lagi"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // When the user presses the 'Gleymt lykilorð?' (Forgot Password) button, log out from the app
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('rememberMe');
    setState(() {
      userProfile = null;
      print("User logged out successfully");
    });

    widget.onLogout!('forgotPassword');
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
                                    changePassword,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return errorImageContainer();
                                    },
                                  ),
                                ),
                                SizedBox(width: 13.w),
                                Flexible(
                                  child: Text(
                                    'Breyta lykilorði',
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
                      SizedBox(height: 46.h),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Text(
                              'Lykilorðið þitt verður að vera að minnsta kosti 6 stafir að lengd ',
                              style: emailOtpScreenTextStyle,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),

                            SizedBox(height: 34.h),
                            CustomPasswordField(
                              hintText: "Núverandi lykilorð*",
                              iconPath: lock,
                              controller: _currentPasswordController,
                            ),
                            SizedBox(height: 18.h),
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: logout,

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
                            if (_showPasswordMatchError)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  'Nýja lykilorðið og staðfesta lykilorðið verða að vera svipuð.',
                                  style: TextStyle(
                                    color: Color(0xFFFF0000),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            _showPasswordMatchError
                                ? SizedBox(height: 53.h)
                                : SizedBox(height: 75.h),
                            CustomElevatedButton(
                              text: "Breyta lykilorði",
                              onPressed: _changePassword,
                            ),
                            SizedBox(height: 20.h),
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
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }
}
