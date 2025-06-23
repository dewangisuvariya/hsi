import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_refresh_indicator.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/news_api_helper.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../custom/custom_appbar.dart';
import '../../provider/BackgroundColorProvider.dart';
// load news from web server

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  bool _hasDataLoaded = false;
  bool _isManualRefresh = false;
  bool isLoading = true;
  List<BaseNewsItem> newsItems = [];

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this); // No cast needed now
    // _checkBatteryOptimization();
    fetchAboutHsiSections();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Load data from the NewsApiHelper class via the web service.
  Future<void> fetchAboutHsiSections() async {
    try {
      if (!_hasDataLoaded || _isManualRefresh) {
        setState(() {
          isLoading = true;
        });
      }
      // Fetch data from multiple news sources concurrently
      final results = await Future.wait([
        NewsApiHelper.fetchHandballNews(),
        NewsApiHelper.fetchNews(),
        NewsApiHelper.fetchRuvHandballNews(),
        NewsApiHelper.fetchHsiNews(),
      ]);
      // Combine all news items into a single list
      final combinedItems = [
        ...results[0],
        ...results[1],
        ...results[2],
        ...results[3],
      ];

      // Sort the items by publication date (newest first)
      combinedItems.sort((a, b) {
        final dateA = _parseDate(a.pubDate);
        final dateB = _parseDate(b.pubDate);
        return dateB.compareTo(dateA); // Descending order
      });

      if (mounted) {
        setState(() {
          newsItems = combinedItems;
          _hasDataLoaded = true;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) showNetworkErrorDialog(context);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          _isManualRefresh = false;
        });
      }
    }
  }

  // Helper function to parse different date formats from news sources
  DateTime _parseDate(String pubDate) {
    try {
      // Handle different date formats from different APIs
      if (pubDate.contains(',')) {
        // Format like "Sun, 11 May 2025 19:00:00 +0000"
        return DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDate);
      } else {
        // Try other formats if needed
        return DateTime.parse(pubDate);
      }
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now();
    }
  }

  // Function to manually refresh data
  Future<void> _refreshData() async {
    setState(() {
      _isManualRefresh = true;
    });
    await fetchAboutHsiSections();
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: backgroundColorProvider.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: "Fréttir", imagePath: news),
              Expanded(
                child: Stack(
                  children: [
                    CustomRefreshIndicator(
                      onRefresh: _refreshData,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: newsItems.length,
                        itemBuilder: (context, index) {
                          final item = newsItems[index];
                          return NewsCard(newsItem: item);
                        },
                      ),
                    ),
                    if (isLoading && newsItems.isEmpty)
                      Positioned.fill(child: Center(child: loadingAnimation)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget for displaying individual news cards
class NewsCard extends StatelessWidget {
  final BaseNewsItem newsItem;

  const NewsCard({super.key, required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: unselectedCart,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          final Uri url = Uri.parse(newsItem.link);
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {
              throw 'Could not launch $url';
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (newsItem.imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: Image.network(
                    newsItem.imageUrl!,
                    height: 98.h,
                    width: 120.w,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey[200],
                          child: Image.asset(errorImage),
                        ),
                  ),
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      newsItem.title,
                      maxLines: 2,
                      style: coachesNameTextStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(newsItem.pubDate),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: selectedCircleAvatarcolor,
                          radius: 10.r,
                          child: Center(
                            child: Image.asset(
                              selectedCircleAvater,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to format date in Icelandic locale
  String _formatDate(String pubDate) {
    try {
      // Parse the incoming date string
      final date = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDate);

      // Format it in Icelandic
      return DateFormat('dd. MMMM yyyy - HH:mm', 'is_IS').format(date);
    } catch (e) {
      return pubDate;
    }
  }
}
