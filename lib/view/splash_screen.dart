import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'footer_screen/navigationbar.dart';
import 'Login & SignUp/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimationAndNavigate();
  }

  // Check if the user is logged in. If logged in, check whether rememberMe is stored in SharedPreferences. If rememberMe is true, skip the login screen; otherwise, show the login screen every time the user opens the app
  Future<void> _startAnimationAndNavigate() async {
    // Start fade-in
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _opacity = 1.0;
    });

    // Delay splash screen
    await Future.delayed(Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (rememberMe && isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BottomNavBarWidget()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: _opacity,
            child: Container(
              height: screenHeight * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Image.asset(
                    "assets/images/9781_HSI_Logo.png",
                    height: screenHeight * 0.15,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container(color: Colors.white)),
        ],
      ),
    );
  }
}
