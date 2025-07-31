import 'package:flutter/material.dart';
import '../Model/check_user_notification_status_model.dart';
import '../Model/fetch_latest_results_model.dart';
import '../Model/notices_model.dart';
import '../repository/Check_user_notification_status_helper.dart';
import '../repository/latest_results_helper.dart';
import '../repository/log_activity_helper.dart';
import '../repository/notices_helper.dart';
import '../repository/user_notifications_mark_as_read_helper.dart';

class HomeScreenState extends ChangeNotifier {
  // Data states
  List<Notice> notices = [];
  LatestMatchResultModel? latestResults;
  NotificationResponse? notificationResponse;

  // Loading states
  bool isLoading = true;
  bool isInitialLoad = true;

  // Error states
  bool hasNoticesError = false;
  bool hasResultsError = false;
  bool hasNotificationsError = false;
  String? resultsError;
  String? notificationsError;

  // UI states
  bool hideFooter = false;
  int? selectedIndex;

  // Services
  final NoticeApiHelper _noticeApiHelper = NoticeApiHelper();
  final NotificationApiService _notificationApiService =
      NotificationApiService();
  final ApiService _apiService = ApiService();

  // Combined error state
  bool get hasError =>
      hasNoticesError || hasResultsError || hasNotificationsError;

  Future<void> loadAllData() async {
    try {
      if (isInitialLoad) {
        isLoading = true;
        notifyListeners();
      }

      // Reset error states
      hasNoticesError = false;
      hasResultsError = false;
      hasNotificationsError = false;
      resultsError = null;
      notificationsError = null;

      // Fetch data in parallel
      await Future.wait([
        _fetchNotices(),
        _fetchNotifications(),
        _fetchLatestResults(),
        _logUserActivity(),
      ]);

      isInitialLoad = false;
    } catch (e) {
      debugPrint('Error loading all data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchNotices() async {
    try {
      final response = await _noticeApiHelper.fetchNotices();
      notices = response.notices;
    } catch (e) {
      hasNoticesError = true;
      debugPrint('Error fetching notices: $e');
      notices = [];
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await NotificationApiService.fetchUserNotifications();

      if (response == null) {
        hasNotificationsError = true;
        notificationsError = 'Failed to load notifications: No data returned';
        debugPrint(notificationsError);
        notificationResponse = null;
      } else {
        notificationResponse = response;
        hasNotificationsError = false;
        notificationsError = null;
      }
    } catch (e) {
      hasNotificationsError = true;
      notificationsError = 'Error fetching notifications: ${e.toString()}';
      debugPrint(notificationsError);
      notificationResponse = null;
    }
  }

  Future<void> _fetchLatestResults() async {
    try {
      final results = await ApiService.fetchLatestResults();

      if (results == null) {
        hasResultsError = true;
        resultsError = 'Failed to load results: No data returned';
        debugPrint(resultsError);
        latestResults = null;
      } else {
        latestResults = results;
        hasResultsError = false;
        resultsError = null;
      }
    } catch (e) {
      hasResultsError = true;
      resultsError = 'Error fetching results: ${e.toString()}';
      debugPrint(resultsError);
      latestResults = null;
    }
  }

  Future<void> _logUserActivity() async {
    try {
      await LogActivityApiHelper.logUserActivity();
    } catch (e) {
      debugPrint('Error logging activity: $e');
    }
  }

  Future<void> refreshData() async {
    isInitialLoad = true;
    await loadAllData();
  }

  // Future<void> markNotificationAsRead(int notificationId) async {
  //   try {
  //     await NotificationService.markNotificationAsRead(notificationId);
  //     await _fetchNotifications();
  //   } catch (e) {
  //     debugPrint('Error marking notification as read: $e');
  //   }
  // }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      await NotificationService.markNotificationAsRead(notificationId);
      await _fetchNotifications(); // Refresh notifications after marking as read
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      throw e; // Re-throw to handle in the UI if needed
    }
  }

  void setSelectedIndex(int? index) {
    selectedIndex = index;
    notifyListeners();
  }
}
