// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/const/resource_manager.dart';
// import 'package:hsi/const/style_manager.dart';
// import 'package:hsi/custom/custom_refresh_indicator.dart';
// import 'package:hsi/custom/showNetworkErrorDialog.dart';
// import 'package:hsi/repository/news_api_helper.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:developer' as developer; // Added for better logging
// import '../../custom/custom_appbar.dart';
// import '../../provider/BackgroundColorProvider.dart';

// class NewScreen extends StatefulWidget {
//   const NewScreen({super.key});

//   @override
//   State<NewScreen> createState() => _NewScreenState();
// }

// class _NewScreenState extends State<NewScreen> {
//   bool _hasDataLoaded = false;
//   bool _isManualRefresh = false;
//   bool isLoading = true;
//   List<BaseNewsItem> newsItems = [];
//   final ScrollController _scrollController = ScrollController();
//   int _currentAdIndex = 0;
//   double _lastScrollOffset = 0;
//   int _visibleNewsStart = 0;
//   int _currentGroup = 1;
//   String _currentItemRange = "1-8";
//   int _lastPositionInGroup = 0;

//   final List<Map<String, dynamic>> adConfigurations = [
//     {'color': Colors.blue.shade400, 'mediaUrl': imageOne},
//     {'color': Colors.green.shade400, 'mediaUrl': imageTwo},
//     {'color': Colors.purple.shade400, 'mediaUrl': imageThree},
//     {'color': Colors.amber.shade400, 'mediaUrl': imageFour},
//     {'color': Colors.green.shade400, 'mediaUrl': imageFive},
//     {'color': Colors.purple.shade400, 'mediaUrl': imageSix},
//     {'color': Colors.amber.shade400, 'mediaUrl': imageSeven},
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_handleScroll);
//     fetchAboutHsiSections();
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_handleScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _handleScroll() {
//     final scrollOffset = _scrollController.position.pixels;
//     final approxItemHeight = 118.0;
//     final approxAdHeight = 500.0;

//     double totalHeight = 0;
//     int currentNewsIndex = 0;
//     int newsCount = newsItems.length;

//     for (int i = 0; i < newsCount;) {
//       if (totalHeight + approxItemHeight > scrollOffset) break;
//       totalHeight += approxItemHeight;
//       i++;
//       currentNewsIndex++;

//       if (i % 5 == 0 && i < newsCount) {
//         if (totalHeight + approxAdHeight > scrollOffset) break;
//         totalHeight += approxAdHeight;
//       }
//     }

//     currentNewsIndex = currentNewsIndex.clamp(0, newsCount - 1);

//     final int group = (currentNewsIndex / 10).floor() + 1;
//     final int positionInGroup = (currentNewsIndex % 8) + 1;
//     final int rangeStart = (group - 1) * 10 + 1;
//     final int rangeEnd = min(group * 10, newsCount);
//     final String itemRange = "$rangeStart-$rangeEnd";

//     bool enteredNewGroup = _currentGroup != group;
//     bool wasInFirstHalf = _lastPositionInGroup < 5;
//     bool isInSecondHalf = positionInGroup > 5;
//     bool crossedHalfwayPoint = wasInFirstHalf && isInSecondHalf;

//     bool shouldUpdateAd =
//         (enteredNewGroup && group > 1) || (group > 1 && crossedHalfwayPoint);

//     setState(() {
//       _currentGroup = group;
//       _lastPositionInGroup = positionInGroup - 1;
//       _currentItemRange = itemRange;
//       _visibleNewsStart = (group - 1) * 10;

//       if (shouldUpdateAd) {
//         _currentAdIndex = (_currentAdIndex + 1) % adConfigurations.length;
//       } else if (enteredNewGroup && group == 1) {
//         _currentAdIndex = 0;
//       }
//     });
//   }

//   int min(int a, int b) => a < b ? a : b;

//   Future<void> fetchAboutHsiSections() async {
//     try {
//       if (!_hasDataLoaded || _isManualRefresh) {
//         setState(() => isLoading = true);
//       }

//       // SOLUTION 1: Add timeout to network requests
//       final results = await Future.wait([
//         NewsApiHelper.fetchHandballNews().timeout(const Duration(seconds: 15)),
//         NewsApiHelper.fetchNews().timeout(const Duration(seconds: 15)),
//         NewsApiHelper.fetchRuvHandballNews().timeout(
//           const Duration(seconds: 15),
//         ),
//         NewsApiHelper.fetchHsiNews().timeout(const Duration(seconds: 15)),
//       ]);

//       final combinedItems = [
//         ...results[0],
//         ...results[1],
//         ...results[2],
//         ...results[3],
//       ];

//       combinedItems.sort((a, b) {
//         final dateA = _parseDate(a.pubDate);
//         final dateB = _parseDate(b.pubDate);
//         return dateB.compareTo(dateA);
//       });

//       if (mounted) {
//         setState(() {
//           newsItems = combinedItems;
//           _hasDataLoaded = true;
//         });
//       }
//     } catch (e) {
//       // SOLUTION 2: Better error logging
//       developer.log("Error fetching data: $e", name: 'NewScreen', error: e);
//       if (mounted) showNetworkErrorDialog(context);
//     } finally {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           _isManualRefresh = false;
//         });
//       }
//     }
//   }

//   DateTime _parseDate(String pubDate) {
//     try {
//       return pubDate.contains(',')
//           ? DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDate)
//           : DateTime.parse(pubDate);
//     } catch (e) {
//       developer.log("Error parsing date: $e", name: 'NewScreen');
//       return DateTime.now();
//     }
//   }

//   Future<void> _refreshData() async {
//     setState(() => _isManualRefresh = true);
//     await fetchAboutHsiSections();
//   }

//   String _formatDate(String pubDate) {
//     try {
//       final date = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDate);
//       return DateFormat('dd. MMMM yyyy - HH:mm', 'is_IS').format(date);
//     } catch (e) {
//       return pubDate;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
//       context,
//       listen: false,
//     );

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: [
//           CustomAppBar(title: "Fréttir", imagePath: news),
//           Expanded(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: _buildAdBannerContent(
//                     adConfigurations[_currentAdIndex],
//                   ),
//                 ),
//                 CustomRefreshIndicator(
//                   onRefresh: _refreshData,
//                   child:
//                       newsItems.isEmpty
//                           ? (isLoading
//                               ? Container(
//                                 height: double.infinity,
//                                 width: double.infinity,
//                                 color: Colors.white,
//                                 child: Center(child: loadingAnimation),
//                               )
//                               : Container(
//                                 height: double.infinity,
//                                 width: double.infinity,
//                                 color: Colors.white,
//                                 child: const Center(child: Text("")),
//                               ))
//                           : ListView.builder(
//                             controller: _scrollController,
//                             padding: EdgeInsets.zero,
//                             itemCount: (newsItems.length / 5).ceil() * 2,
//                             itemBuilder: (context, index) {
//                               if (index % 2 == 0) {
//                                 final groupIndex = index ~/ 2;
//                                 final startNewsIndex = groupIndex * 5;
//                                 final endNewsIndex = min(
//                                   startNewsIndex + 5,
//                                   newsItems.length,
//                                 );
//                                 final remainingItems =
//                                     newsItems.length - startNewsIndex;

//                                 if (remainingItems <= 0)
//                                   return const SizedBox();

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: List.generate(
//                                     min(5, remainingItems),
//                                     (i) => _buildNewsItem(
//                                       newsItems[startNewsIndex + i],
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return SizedBox(height: 500.h);
//                               }
//                             },
//                           ),
//                 ),

//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNewsItem(BaseNewsItem newsItem) {
//     return Container(
//       height: 118.h,
//       width: double.infinity,
//       margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6.r),
//         color: unselectedCart,
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () => _launchUrl(newsItem.link),
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (newsItem.imageUrl != null)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(6.r),
//                   child: Image.network(
//                     newsItem.imageUrl!,
//                     height: 98.h,
//                     width: 120.w,
//                     fit: BoxFit.cover,
//                     errorBuilder:
//                         (context, error, stackTrace) => Container(
//                           height: 180,
//                           color: Colors.grey[200],
//                           child: Image.asset(errorImage),
//                         ),
//                   ),
//                 ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       newsItem.title,
//                       maxLines: 2,
//                       style: coachesNameTextStyle.copyWith(color: Colors.black),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           _formatDate(newsItem.pubDate),
//                           style: TextStyle(
//                             fontSize: 14.sp,
//                             color: const Color(0xFF757575),
//                             fontWeight: FontWeight.w500,
//                             fontFamily: "Poppins",
//                           ),
//                         ),
//                         CircleAvatar(
//                           backgroundColor: selectedCircleAvatarcolor,
//                           radius: 10.r,
//                           child: Center(
//                             child: Image.asset(
//                               selectedCircleAvater,
//                               fit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // SOLUTION 3: Separate URL launching logic
//   Future<void> _launchUrl(String url) async {
//     try {
//       final uri = Uri.parse(url);
//       if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//         await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
//       }
//     } catch (e) {
//       developer.log("Could not launch URL: $url", error: e);
//     }
//   }

//   Widget _buildAdBannerContent(Map<String, dynamic> adConfig) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       color: Colors.white,
//       child: Image.asset(adConfig['mediaUrl'], fit: BoxFit.cover),
//     );
//   }
// }
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
import 'dart:developer' as developer;
import '../../custom/custom_appbar.dart';
import '../../provider/BackgroundColorProvider.dart';

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
  final ScrollController _scrollController = ScrollController();
  int _currentAdIndex = 0;
  double _lastScrollOffset = 0;
  int _visibleNewsStart = 0;
  int _currentGroup = 1;
  String _currentItemRange = "1-8";
  int _lastPositionInGroup = 0;
  int _currentVisibleItemCount = 0;
  int _totalGroups = 1;

  final List<Map<String, dynamic>> adConfigurations = [
    {'color': Colors.blue.shade400, 'mediaUrl': imageOne},
    {'color': Colors.green.shade400, 'mediaUrl': imageTwo},
    {'color': Colors.purple.shade400, 'mediaUrl': imageThree},
    {'color': Colors.amber.shade400, 'mediaUrl': imageFour},
    {'color': Colors.green.shade400, 'mediaUrl': imageFive},
    {'color': Colors.purple.shade400, 'mediaUrl': imageSix},
    {'color': Colors.amber.shade400, 'mediaUrl': imageSeven},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    fetchAboutHsiSections();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final scrollOffset = _scrollController.position.pixels;
    final approxItemHeight = 130.h;
    final approxAdHeight = 500.h;

    double totalHeight = 0;
    int currentNewsIndex = 0;
    int newsCount = newsItems.length;
    int visibleCount = 0;

    for (int i = 0; i < newsCount;) {
      if (totalHeight + approxItemHeight > scrollOffset) break;
      totalHeight += approxItemHeight;
      i++;
      currentNewsIndex++;
      visibleCount++;

      if (i % 5 == 0 && i < newsCount) {
        if (totalHeight + approxAdHeight > scrollOffset) break;
        totalHeight += approxAdHeight;
      }
    }

    currentNewsIndex = currentNewsIndex.clamp(0, newsCount - 1);

    final int group = (currentNewsIndex / 6).floor() + 1;
    final int positionInGroup = (currentNewsIndex % 5) + 1;
    final int rangeStart = (group - 1) * 6 + 1;
    final int rangeEnd = min(group * 6, newsCount);
    final String itemRange = "$rangeStart-$rangeEnd";

    bool enteredNewGroup = _currentGroup != group;
    bool wasInFirstHalf = _lastPositionInGroup < 3;
    bool isInSecondHalf = positionInGroup > 3;
    bool crossedHalfwayPoint = wasInFirstHalf && isInSecondHalf;

    bool shouldUpdateAd =
        (enteredNewGroup && group > 1) || (group > 1 && crossedHalfwayPoint);

    setState(() {
      _currentGroup = group;
      _lastPositionInGroup = positionInGroup - 1;
      _currentItemRange = itemRange;
      _visibleNewsStart = (group - 1) * 6;
      _currentVisibleItemCount = visibleCount;
      _totalGroups = (newsCount / 6).ceil();

      if (shouldUpdateAd) {
        _currentAdIndex = (_currentAdIndex + 1) % adConfigurations.length;
      } else if (enteredNewGroup && group == 1) {
        _currentAdIndex = 0;
      }
    });
  }

  int min(int a, int b) => a < b ? a : b;

  Future<void> fetchAboutHsiSections() async {
    try {
      if (!_hasDataLoaded || _isManualRefresh) {
        setState(() => isLoading = true);
      }

      final results = await Future.wait([
        NewsApiHelper.fetchHandballNews().timeout(const Duration(seconds: 15)),
        NewsApiHelper.fetchNews().timeout(const Duration(seconds: 15)),
        NewsApiHelper.fetchRuvHandballNews().timeout(
          const Duration(seconds: 15),
        ),
        NewsApiHelper.fetchHsiNews().timeout(const Duration(seconds: 15)),
      ]);

      final combinedItems = [
        ...results[0],
        ...results[1],
        ...results[2],
        ...results[3],
      ];

      combinedItems.sort((a, b) {
        final dateA = _parseDate(a.pubDate);
        final dateB = _parseDate(b.pubDate);
        return dateB.compareTo(dateA);
      });

      if (mounted) {
        setState(() {
          newsItems = combinedItems;
          _hasDataLoaded = true;
          _totalGroups = (combinedItems.length / 10).ceil();
        });
      }
    } catch (e) {
      developer.log("Error fetching data: $e", name: 'NewScreen', error: e);
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

  DateTime _parseDate(String pubDate) {
    try {
      return pubDate.contains(',')
          ? DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDate)
          : DateTime.parse(pubDate);
    } catch (e) {
      developer.log("Error parsing date: $e", name: 'NewScreen');
      return DateTime.now();
    }
  }

  Future<void> _refreshData() async {
    setState(() => _isManualRefresh = true);
    await fetchAboutHsiSections();
  }

  String _formatDate(String pubDate) {
    try {
      final date = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z").parse(pubDate);
      return DateFormat('dd. MMMM yyyy - HH:mm', 'is_IS').format(date);
    } catch (e) {
      return pubDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          CustomAppBar(title: "Fréttir", imagePath: news),
          // Add scroll position indicator container
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          //   color: Colors.white,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Group $_currentGroup",
          //         style: TextStyle(
          //           fontSize: 14.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //       Text(
          //         "Items: $_currentItemRange (${_currentVisibleItemCount})",
          //         style: TextStyle(
          //           fontSize: 14.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _buildAdBannerContent(
                    adConfigurations[_currentAdIndex],
                  ),
                ),
                CustomRefreshIndicator(
                  onRefresh: _refreshData,
                  child:
                      newsItems.isEmpty
                          ? (isLoading
                              ? Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.white,
                                child: Center(child: loadingAnimation),
                              )
                              : Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.white,
                                child: const Center(child: Text("")),
                              ))
                          : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.only(top: 12.h),
                            itemCount: (newsItems.length / 3).ceil() * 2,
                            itemBuilder: (context, index) {
                              if (index % 2 == 0) {
                                final groupIndex = index ~/ 2;
                                final startNewsIndex = groupIndex * 3;
                                final endNewsIndex = min(
                                  startNewsIndex + 3,
                                  newsItems.length,
                                );
                                final remainingItems =
                                    newsItems.length - startNewsIndex;

                                if (remainingItems <= 0)
                                  return const SizedBox();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    min(3, remainingItems),
                                    (i) => _buildNewsItem(
                                      newsItems[startNewsIndex + i],
                                    ),
                                  ),
                                );
                              } else {
                                return SizedBox(height: 500.h);
                              }
                            },
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(BaseNewsItem newsItem) {
    return Container(
      height: 118.h,
      width: double.infinity,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: unselectedCart,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchUrl(newsItem.link),
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
                      style: coachesNameTextStyle.copyWith(color: Colors.black),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(newsItem.pubDate),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF757575),
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

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }
    } catch (e) {
      developer.log("Could not launch URL: $url", error: e);
    }
  }

  Widget _buildAdBannerContent(Map<String, dynamic> adConfig) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Image.asset(adConfig['mediaUrl'], fit: BoxFit.cover),
    );
  }
}
