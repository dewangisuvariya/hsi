import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/view/boys_girls_leagues/static/next_game_static_screen.dart';
import 'package:hsi/view/boys_girls_leagues/static/result_static_screen.dart';

import 'package:hsi/view/man_women_leagues/stand_screen.dart';

// load juniour boy category - Standings details from web server
// and display those within this screen
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class BoyGirlLeagueDetailScreen extends StatefulWidget {
  final int leagueId;
  final String leagueName;
  final String leaguesImage;

  const BoyGirlLeagueDetailScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
    required this.leaguesImage,
    required leagueImage,
  });

  @override
  State<BoyGirlLeagueDetailScreen> createState() =>
      _BoyGirlLeagueDetailScreenState();
}

class _BoyGirlLeagueDetailScreenState extends State<BoyGirlLeagueDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _pageController.addListener(_handlePageChange);
  }

  // For handling tab selection
  void _handleTabSelection() {
    if (_tabController.index != _currentPage) {
      setState(() {
        _currentPage = _tabController.index;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    }
  }

  // For handling page changes when a tab is selected, ensuring the tab index and page index are the same
  void _handlePageChange() {
    if (_pageController.page?.round() != _currentPage) {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
        _tabController.animateTo(_currentPage);
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _pageController.removeListener(_handlePageChange);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          if (isWideScreen) customTabbarTablet() else customTabbarMobile(),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: const [
                StaoanScreen(),
                NextGameStaticScreen(),
                ResultStaticScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding customTabbarMobile() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 6),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: unselectedCart,
        ),
        height: 40.h,
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = 0;
                    _tabController.animateTo(0);
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 181.w,
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == 0
                            ? selectedDividerColor
                            : unselectedCart,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'Staðan',
                      style: TextStyle(
                        color:
                            _currentPage == 0
                                ? Colors.white
                                : selectedDividerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = 1;
                    _tabController.animateTo(1);
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 181.w,
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == 1
                            ? selectedDividerColor
                            : unselectedCart,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'Úrslit',
                      style: TextStyle(
                        color:
                            _currentPage == 1
                                ? Colors.white
                                : selectedDividerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = 2;
                    _tabController.animateTo(2);
                    _pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 181.w,
                  margin: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == 2
                            ? selectedDividerColor
                            : unselectedCart,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'Næstu leikir',
                      style: TextStyle(
                        color:
                            _currentPage == 2
                                ? Colors.white
                                : selectedDividerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding customTabbarTablet() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6, right: 145, left: 145),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: unselectedCart,
        ),
        height: 40.h,
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = 0;
                    _tabController.animateTo(0);
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 181.w,
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == 0
                            ? selectedDividerColor
                            : unselectedCart,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'Staðan',
                      style: TextStyle(
                        color:
                            _currentPage == 0
                                ? Colors.white
                                : selectedDividerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = 1;
                    _tabController.animateTo(1);
                    _pageController.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 181.w,
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == 1
                            ? selectedDividerColor
                            : unselectedCart,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'Úrslit',
                      style: TextStyle(
                        color:
                            _currentPage == 1
                                ? Colors.white
                                : selectedDividerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 18.w),
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentPage = 2;
                    _tabController.animateTo(2);
                    _pageController.animateToPage(
                      2,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  });
                },
                child: Container(
                  height: 30.h,
                  width: 181.w,
                  margin: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color:
                        _currentPage == 2
                            ? selectedDividerColor
                            : unselectedCart,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Center(
                    child: Text(
                      'Næstu leikir',
                      style: TextStyle(
                        color:
                            _currentPage == 2
                                ? Colors.white
                                : selectedDividerColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
