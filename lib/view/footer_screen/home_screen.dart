import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/check_user_notification_status_model.dart';
import 'package:hsi/Model/fetch_latest_results_model.dart';
import 'package:hsi/Model/notices_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/repository/Check_user_notification_status_helper.dart';
import 'package:hsi/repository/latest_results_helper.dart';
import 'package:hsi/repository/log_activity_helper.dart';
import 'package:hsi/repository/notices_helper.dart';
import 'package:hsi/repository/user_notifications_mark_as_read_helper.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/video_player_screen.dart';
import 'package:hsi/view/Profile/profile_display_screen.dart';
import 'package:hsi/view/home_screen/Live_feed_widget.dart';
import 'package:hsi/view/slide_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../buttontpedscreen/sports_education_screen.dart';
import '../buttontpedscreen/statistics_screen.dart';
import '../buttontpedscreen/boy_girl_leagues_screen.dart';
import '../buttontpedscreen/hsi_screen.dart';
import 'package:intl/intl.dart';

// load home screen details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HomeScreen extends StatefulWidget {
  final Function(String)? onLogout;

  const HomeScreen({Key? key, this.onLogout}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int? _selectedIndex;

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Notice> notices = [];
  bool isLoading = true;
  bool _hideFooter = false;
  NotificationResponse? _notificationResponse;

  @override
  void initState() {
    super.initState();
    fetchNotices();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowNotifications();
      _logUserActivity();
    });
  }

  // Add this new method to log user activity
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logUserActivity(); // Log user activity when dependencies change
  }

  @override
  void dispose() {
    super.dispose();
    _hideFooter = true; // Hide footer when disposing the widget
  }

  // Log user activity using the LogActivityApiHelper class.
  Future<void> _logUserActivity() async {
    try {
      await LogActivityApiHelper.logUserActivity();
    } catch (e) {
      print("Error logging user activity: $e");
    }
  }

  // Load data from the checkUserNotificationStatusHelper class via the web service.
  Future<void> _checkAndShowNotifications() async {
    final notificationResponse =
        await NotificationApiService.fetchUserNotifications();

    if (notificationResponse != null &&
        notificationResponse.success &&
        notificationResponse.data.count > 0 &&
        mounted) {
      setState(() {
        _notificationResponse = notificationResponse;
      });
      _showNotificationDialog(); // Added parentheses here
    }
  }

  void _showNotificationDialog() {
    if (_notificationResponse == null || !mounted) return;
    print('Attempting to show notification dialog'); // Debug line
    if (_notificationResponse == null || !mounted) {
      print(
        'Dialog not shown: ${_notificationResponse == null ? "null response" : "not mounted"}',
      );
      return;
    }

    final notification = _notificationResponse!.data.notifications.first;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: selectedCart,
          title: Image.network(
            notification.icon,
            width: 73.w,
            height: 65.91.h,
            fit: BoxFit.contain,
            errorBuilder:
                (context, error, stackTrace) =>
                    Icon(Icons.notifications, size: 60),
          ),
          content: Text(
            textAlign: TextAlign.center,
            notification.message,
            maxLines: 15,
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

                  onPressed: () async {
                    Navigator.of(context).pop();

                    // Step 1: Call the API to mark the notification as read
                    final response =
                        await NotificationService.markNotificationAsRead(
                          notification.notificationId,
                        );

                    if (response != null && response.success == true) {
                      print('Notification marked as read successfully.');
                    } else {
                      print('Failed to mark notification as read.');
                    }

                    // Step 2: Open the URL
                    final Uri url = Uri.parse(notification.url);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      print('Could not launch ${notification.url}');
                    }
                  },

                  child: Text("Okay"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Load data from the NoticeHelper class via the web service.
  Future<void> fetchNotices() async {
    try {
      final noticeResponse = await NoticeApiHelper().fetchNotices();

      setState(() {
        notices = noticeResponse.notices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error fetching notices: $e');
    }
  }

  Future<bool> _handleWillPop() async {
    // Show confirmation dialog if on HomeScreen (index 3)
    bool? shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            contentPadding: EdgeInsets.all(30),
            backgroundColor: appBarColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.r),
            ),
            content: Text(
              'Ertu viss um að þú viljir hætta?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: "Montserrat",
                wordSpacing: 1,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColorContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  minimumSize: Size(110.w, 32.h),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Já',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFA0A0A0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  minimumSize: Size(110.w, 32.h),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'Nei',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ],
          ),
    );

    return shouldExit ?? false;
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        drawer: SlideMenu(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: isLargeScreen ? 360.h : 220.h,
                    color: backgroundColorContainer,
                  ),
                  Column(
                    children: [
                      SizedBox(height: isLargeScreen ? 50.h : 43.h),
                      // Responsive header
                      isLargeScreen
                          ? _buildLargeScreenHeader()
                          : _buildSmallScreenHeader(),

                      SizedBox(height: isLargeScreen ? 12.h : 4.h),

                      // Menu button
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding:
                                    isLargeScreen
                                        ? EdgeInsets.only(left: 94.0)
                                        : EdgeInsets.only(left: 34.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          // Use the properly encoded URL
                                          const url =
                                              'https://www.youtube.com/c/HS%C3%8D_iceland';

                                          // Directly launch the URL with error handling
                                          await launchUrl(
                                            Uri.parse(url),
                                            mode:
                                                LaunchMode
                                                    .externalApplication, // Opens in YouTube app if installed
                                          );
                                        } catch (e) {
                                          // Show error message if launch fails
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Could not open YouTube channel',
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          // For debugging:
                                          debugPrint(
                                            'Failed to launch URL: $e',
                                          );
                                        }
                                      },
                                      child: Image.asset(
                                        youtube,
                                        width: isLargeScreen ? 34.w : 24.w,
                                        height: isLargeScreen ? 34.w : 24.w,
                                      ),
                                    ),
                                    SizedBox(width: isLargeScreen ? 10.w : 6.w),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          // Use the properly encoded URL
                                          const url =
                                              'https://www.instagram.com/hsi_iceland/';

                                          // Directly launch the URL with error handling
                                          await launchUrl(
                                            Uri.parse(url),
                                            mode:
                                                LaunchMode
                                                    .externalApplication, // Opens in YouTube app if installed
                                          );
                                        } catch (e) {
                                          // Show error message if launch fails
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Could not open YouTube channel',
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          // For debugging:
                                          debugPrint(
                                            'Failed to launch URL: $e',
                                          );
                                        }
                                      },

                                      child: Image.asset(
                                        instagramHome,
                                        width: isLargeScreen ? 34.w : 24.w,
                                        height: isLargeScreen ? 34.w : 24.w,
                                      ),
                                    ),
                                    SizedBox(width: isLargeScreen ? 10.w : 6.w),
                                    GestureDetector(
                                      onTap: () async {
                                        try {
                                          // Use the properly encoded URL
                                          const url =
                                              'https://www.tiktok.com/@hsiiceland';

                                          // Directly launch the URL with error handling
                                          await launchUrl(
                                            Uri.parse(url),
                                            mode:
                                                LaunchMode
                                                    .externalApplication, // Opens in YouTube app if installed
                                          );
                                        } catch (e) {
                                          // Show error message if launch fails
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Could not open YouTube channel',
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          // For debugging:
                                          debugPrint(
                                            'Failed to launch URL: $e',
                                          );
                                        }
                                      },

                                      child: Image.asset(
                                        tiktok,
                                        width: isLargeScreen ? 34.w : 24.w,
                                        height: isLargeScreen ? 34.w : 24.w,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              height: isLargeScreen ? 44.h : 26.h,
                              // width: isLargeScreen ? 160.w : 100.w,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF141F),
                                  fixedSize:
                                      isLargeScreen
                                          ? Size(160.w, 44.h)
                                          : Size(103.w, 26.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  // padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                  // FirebaseCrashlytics.instance.crash();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      imageButton,
                                      height: isLargeScreen ? 11.h : 7.h,
                                      width: isLargeScreen ? 11.w : 7.w,
                                    ),
                                    SizedBox(width: isLargeScreen ? 10.w : 6.w),
                                    Text(
                                      "Í beinni",
                                      style: drawerButtonStyle.copyWith(
                                        fontSize: isLargeScreen ? 22.sp : 11.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProfileDisplayScreen(
                                          onLogout: widget.onLogout,
                                        ),
                                  ),
                                );
                              },
                              child: Image.asset(
                                account,
                                width: isLargeScreen ? 44.w : 24.w,
                                height: isLargeScreen ? 44.w : 24.w,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isLargeScreen ? 10.h : 6.h),

                      // Banner image
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: textColorLeagueTile,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withOpacity(0.26),
                              offset: const Offset(2, 2),
                              blurRadius: 6,
                              spreadRadius: 0,
                            ),
                          ],

                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        width: isLargeScreen ? 600.w : 355.w,
                        height: isLargeScreen ? 300.h : 155.h,

                        child: LiveFeedWidget(),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: isLargeScreen ? 16.h : 9.h),

              isLargeScreen
                  ? _buildLargeScreenButtons(isLargeScreen)
                  : _buildSmallScreenButtons(isLargeScreen),

              if (!isLoading && notices.isNotEmpty)
                _buildNoticeContainer(isLargeScreen, notices.first),
              SizedBox(height: isLargeScreen ? 30.h : 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nýjustu úrslit",
                      style: TextStyle(
                        fontSize: isLargeScreen ? 20.sp : 14.sp,
                        color: Color(0xFF292929),
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                    Text(
                      "Fleiri úrslit",
                      style: TextStyle(
                        fontSize: isLargeScreen ? 18.sp : 14.sp,
                        color: Color(0xFFF28E2B),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Divider(color: Color(0xFFE3E3E3), thickness: 1.5),
              ),
              // SizedBox(height: isLargeScreen ? 30.h : 4.h),
              SizedBox(
                height: isLargeScreen ? 100.h : 78.h,
                child: MatchListView(),
              ),
              SizedBox(height: isLargeScreen ? 30.h : 4.h),
            ],
          ),
        ),
      ),
    );
  }

  // Display the header of this screen when on a mobile device
  Widget _buildSmallScreenHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(hsiLogo, width: 50.w, height: 37.h),
        SizedBox(width: 5.w),
        Text("HANDKNATTLEIKSSAMBAND ÍSLANDS", style: titleTextStyle),
      ],
    );
  }
  // Display the header of this screen when on a tablet device.

  Widget _buildLargeScreenHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(hsiLogo, width: 76.w, height: 75.h),
        SizedBox(width: 20.w),
        Text(
          "HANDKNATTLEIKSSAMBAND ÍSLANDS",
          style: titleTextStyle.copyWith(fontSize: 26.sp),
        ),
      ],
    );
  }

  // Display the  column of HomeScreen buttons on this screen when on a mobile device
  Widget _buildSmallScreenButtons(bool isLargeScreen) {
    return Column(
      children: [
        customButton(
          context: context,
          title: "Mótamál - yngri flokkar",
          icon: nationalTeam,
          route: BoyGirlLeaguesScreen(),
          selected: _selectedIndex == 0,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 0,
          isLargeScreen: false,
        ),
        SizedBox(height: 6.h),
        customButton(
          context: context,
          title: "Tölfræði",
          icon: barChart,
          route: StatisticsScreen(),
          selected: _selectedIndex == 1,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 1,
          isLargeScreen: false,
        ),
        SizedBox(height: 6.h),
        customButton(
          context: context,
          title: "Íþróttafræðsla HSÍ",
          icon: data,
          route: DagatalHsiScreen(),
          selected: _selectedIndex == 2,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 2,
          isLargeScreen: false,
        ),
        SizedBox(height: 6.h),
        customButton(
          context: context,
          title: "HSÍ",
          icon: hsi,
          route: AboutHsiScreen(),
          selected: _selectedIndex == 3,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 3,
          isLargeScreen: false,
        ),
      ],
    );
  }

  // Display the  column of HomeScreen buttons on this screen when on a tablet device
  Widget _buildLargeScreenButtons(bool isLargeScreen) {
    return Column(
      children: [
        customButton(
          context: context,
          title: "Motamal - yngri flokkar",
          icon: nationalTeam,
          route: BoyGirlLeaguesScreen(),
          selected: _selectedIndex == 0,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 0,
          isLargeScreen: true,
        ),
        SizedBox(height: 10.h),
        customButton(
          context: context,
          title: "Tölfræði",
          icon: barChart,
          route: StatisticsScreen(),
          selected: _selectedIndex == 1,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 1,
          isLargeScreen: true,
        ),
        SizedBox(height: 10.h),
        customButton(
          context: context,
          title: "Íþróttafræðsla HSÍ",
          icon: data,
          route: DagatalHsiScreen(),
          selected: _selectedIndex == 2,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 2,
          isLargeScreen: true,
        ),
        SizedBox(height: 10.h),
        customButton(
          context: context,
          title: "HSÍ",
          icon: hsi,
          route: AboutHsiScreen(),
          selected: _selectedIndex == 3,
          onSelected: (newIndex) => setState(() => _selectedIndex = newIndex),
          index: 3,
          isLargeScreen: true,
        ),
      ],
    );
  }

  // Display the HomeScreen column list button UI.
  Widget customButton({
    required BuildContext context,
    required String title,
    required String icon,
    required Widget route,
    required bool selected,
    required Function(int) onSelected,
    required int index,
    required bool isLargeScreen,
  }) {
    return Container(
      height: isLargeScreen ? 60.13.h : 42.h,
      width: isLargeScreen ? 448.39.w : 332.w,
      child: ElevatedButton(
        onPressed: () {
          onSelected(index);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: appBarColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isLargeScreen ? 50.r : 35.r),
            side: BorderSide(
              color: selected ? selectedDividerColor : Colors.transparent,
              width: 3.w,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 30.w : 20.w,
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Image.asset(
                    icon,
                    width: isLargeScreen ? 34.84.w : 26.w,
                    height: isLargeScreen ? 34.84.h : 26.h,
                  ),
                  SizedBox(width: isLargeScreen ? 13.68.w : 10.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isLargeScreen ? 20.sp : 16.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: isLargeScreen ? 34.w : 24.w,
              color: selected ? selectedDividerColor : Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// Display the Notice Container UI.
Widget _buildNoticeContainer(bool isLargeScreen, Notice notice) {
  return Padding(
    padding:
        isLargeScreen
            ? EdgeInsets.only(top: 12.h, left: 37.w, right: 37.w)
            : EdgeInsets.only(top: 12.h, left: 8.w, right: 8.w),
    child: Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: selectedDividerColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white, width: 1),
      ),

      child: Padding(
        padding:
            isLargeScreen
                ? EdgeInsets.only(right: 10.w)
                : EdgeInsets.only(right: 3.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Only show image if noticeImage is not empty and is a valid URL
            if (notice.noticeImage.isNotEmpty &&
                    Uri.tryParse(notice.noticeImage)!.hasAbsolutePath ??
                false)
              Padding(
                padding:
                    isLargeScreen
                        ? EdgeInsets.only(left: 29.w, top: 12.9.h, bottom: 12.9)
                        : EdgeInsets.only(left: 4.w),
                child: Image.network(
                  notice.noticeImage,
                  width: isLargeScreen ? 24.w : 20.w,
                  height: isLargeScreen ? 24.h : 20.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // If image fails to load, return empty container
                    return const SizedBox.shrink();
                  },
                ),
              ),

            // Only add spacing if we're showing an image
            if (notice.noticeImage.isNotEmpty &&
                    Uri.tryParse(notice.noticeImage)!.hasAbsolutePath ??
                false)
              SizedBox(width: 12.w),

            // Always show text
            Expanded(
              child: Text(
                notice.noticeMessage,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// Display a row of buttons on the Home Screen
// load  match list details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class MatchListView extends StatefulWidget {
  @override
  const MatchListView({Key? key}) : super(key: key);
  _MatchListViewState createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
  late Future<LatestMatchResultModel?> _futureResults;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _futureResults = ApiService.fetchLatestResults();
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    return FutureBuilder<LatestMatchResultModel?>(
      future: _futureResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: isLargeScreen ? 110.h : 92.h,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 92.h,
            child: Center(child: Text('Error loading data')),
          );
        } else if (!snapshot.hasData || snapshot.data!.results.isEmpty) {
          return SizedBox(height: 92.h, child: Center(child: Text('')));
        }

        final results = snapshot.data!.results;

        return SizedBox(
          height: isLargeScreen ? 110.h : 92.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: results.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final match = results[index];
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.w : 0,
                  right: index == results.length - 1 ? 16.w : 0,
                ),
                child: _buildMatchCard(match, isLargeScreen),
              );
            },
          ),
        );
      },
    );
  }

  // this displays the custom match card UI
  Widget _buildMatchCard(MatchResult match, bool isLargeScreen) {
    return Container(
      width: isLargeScreen ? 217.w : 182.w,
      height: isLargeScreen ? 110.h : 92.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(4.r),
          bottomRight: Radius.circular(4.r),
        ),
        border: Border.all(width: 1.42, color: Color(0xFF005496)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: isLargeScreen ? 29.84.h : 20.h,

            decoration: BoxDecoration(color: Color(0xFF005496)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      match.teamName,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 11.16.sp : 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  VideoPlayerScreen(videoUrl: match.url),
                        ),
                      );
                    },
                    child: Image.asset(
                      play,
                      width: isLargeScreen ? 21.w : 15.58.w,
                      height: isLargeScreen ? 21.h : 15.58.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isLargeScreen ? 5.81.h : 4.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildClubImage(
                  match.homeClubImage,
                  match.homeClubName,
                  isLargeScreen,
                ),
                Text(
                  '${match.homeClubScore} - ${match.awayClubScore}',
                  style: TextStyle(
                    fontSize: isLargeScreen ? 20.85.sp : 17.44.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                ),
                _buildClubImage(
                  match.awayClubImage,
                  match.awayClubName,
                  isLargeScreen,
                ),
              ],
            ),
          ),
          Text(
            _formatDateTime(match.matchDateTime),
            style: TextStyle(
              fontSize: isLargeScreen ? 11.64.sp : 9.74.sp,
              color: Color(0xFF005496),
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  // This displays an image fetched from the web service
  Widget _buildClubImage(String imageUrl, String clubName, bool isLargeScreen) {
    return imageUrl.isNotEmpty
        ? Image.network(
          imageUrl,
          width: isLargeScreen ? 45.1.w : 36.9.w,
          height: isLargeScreen ? 45.1.h : 33.78.h,
          errorBuilder:
              // (context, error, stackTrace) => _buildPlaceholder(clubName),
              (context, error, stackTrace) => errorImageContainer(),
        )
        : _buildPlaceholder(clubName);
  }

  //This displays the club name in the match card
  Widget _buildPlaceholder(String clubName) {
    return Container(
      width: 39.9.w,
      height: 34.78.h,
      alignment: Alignment.center,
      child: Text(
        clubName.substring(0, 1),
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper function to format date in Icelandic locale
  String _formatDateTime(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);

      return DateFormat('dd. MMMM yyyy - HH:mm', 'is_IS').format(parsedDate);
    } catch (e) {
      return dateTime;
    }
  }
}
