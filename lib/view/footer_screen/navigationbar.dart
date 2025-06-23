import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/provider/AuthProvider.dart';
import 'package:hsi/view/Forgot%20Password/forgot_password_screen.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_in_screen.dart';
import 'package:provider/provider.dart';
import '../../provider/BackgroundColorProvider.dart';
import 'man_women_leagues.dart';
import 'favourite_screen.dart';
import 'home_screen.dart';
import 'news_screen.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({Key? key}) : super(key: key);

  @override
  _BottomNavBarWidgetState createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  int _currentIndex = 0;
  bool _isLoggedIn = true;
  bool _hideFooter = false;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  late final List<Widget> _screens;
  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onLogout: (destination) => _handleLogout(destination: destination),
      ),
      NewScreen(),
      FavoriteScreen(),
      ManWomenLeagues(),
    ];
  }

  // void _handleLogout() {
  //   setState(() {
  //     _isLoggedIn = false;
  //   });
  //   Navigator.of(context).pushAndRemoveUntil(
  //     MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
  //     (Route<dynamic> route) => false,
  //   );
  // }
  void _handleLogout({required String destination}) {
    setState(() {
      _isLoggedIn = false;
    });

    Widget targetScreen;

    switch (destination) {
      case 'login':
        targetScreen = SignInScreen(); // Replace with your actual login screen
        break;
      case 'forgotPassword':
        targetScreen = ForgotPasswordScreen(cameFromChangePassword: true);
        break;
      default:
        targetScreen = SignInScreen(); // Default to login screen
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => targetScreen),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
    );

    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentIndex].currentState!.maybePop();

        if (isFirstRouteInCurrentTab) {
          if (_currentIndex != 0) {
            setState(() => _currentIndex = 0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: backgroundColorProvider.backgroundColor,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
        bottomNavigationBar:
            _isLoggedIn && !_hideFooter
                ? (SafeArea(
                  child:
                      screenWidth > 400
                          ? _buildCompactBottomNavBar()
                          : _buildWideBottomNavBar(),
                ))
                : null,
      ),
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _currentIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute:
            (settings) =>
                MaterialPageRoute(builder: (context) => _screens[index]),
      ),
    );
  }

  // For wider screens (>400dp)
  Widget _buildWideBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              SizedBox(width: 16.w),
              _buildWideNavItem(0, homeScreen, "Heim", false),
              _buildWideNavItem(1, news, "Fréttir", false),
              _buildWideNavItem(2, favourite, "Uppáhalds", false),
              _buildWideNavItem(3, menWomen, "Meistaraflokkur", true),
              SizedBox(width: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWideNavItem(
    int index,
    String iconPath,
    String label,
    bool isWide,
  ) {
    bool isSelected = _currentIndex == index;
    double baseWidth = isWide ? 120 : 80;

    return Expanded(
      flex: isWide ? 3 : 2,
      child: InkWell(
        onTap: () => _handleTabSelection(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: isSelected ? baseWidth * 1.2 : baseWidth,
          // height: 40.h,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF005496).withOpacity(0.1)
                    : Colors.white,
            border:
                isSelected
                    ? const Border(
                      top: BorderSide(color: Color(0xFF005496), width: 3),
                    )
                    : null,
          ),
          child: _buildNavItemContent(iconPath, label, isSelected),
        ),
      ),
    );
  }

  // For smaller screens (<=400dp)
  Widget _buildCompactBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              SizedBox(width: 16.w),
              Expanded(child: _buildCompactNavItem(0, homeScreen, "Heim")),
              Expanded(child: _buildCompactNavItem(1, news, "Fréttir")),
              Expanded(child: _buildCompactNavItem(2, favourite, "Uppáhalds")),
              Expanded(
                child: _buildCompactNavItem(3, menWomen, "Meistaraflokkur"),
              ),
              // Add space after last item
              SizedBox(width: 16.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactNavItem(int index, String iconPath, String label) {
    bool isSelected = _currentIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _handleTabSelection(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          // height: 40.h,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? const Color(0xFF005496).withOpacity(0.1)
                    : Colors.white,
            border:
                isSelected
                    ? const Border(
                      top: BorderSide(color: Color(0xFF005496), width: 3),
                    )
                    : const Border(
                      top: BorderSide(color: Colors.white, width: 3),
                    ),
          ),
          child: _buildNavItemContent(iconPath, label, isSelected),
        ),
      ),
    );
  }

  // Shared content for both nav item types
  Widget _buildNavItemContent(String iconPath, String label, bool isSelected) {
    final bool isMenWomenIcon = iconPath == menWomen;
    final double iconWidth = isMenWomenIcon ? 45.w : 30.w;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath, width: iconWidth, height: 17.h),
        SizedBox(height: 1.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: isSelected ? const Color(0xFF005496) : Colors.black,
            fontFamily: "Poppins",
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _handleTabSelection(int index) {
    if (_currentIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentIndex = index);
    }
  }
}
