import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/strength_training_u_fifteen_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/strenght_training_custom_sub_screen_appbar.dart';
import 'package:hsi/repository/strength_training_u_fifteen_details_helper.dart';
import 'package:hsi/view/HSÍ Sports Education/video_player_screen.dart';
// load strength training UFifteen video list details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class StrengthTrainingUFifteenVideoListScreen extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final String header;
  final int sportEducationId;

  const StrengthTrainingUFifteenVideoListScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.header,
    required this.sportEducationId,
  });

  @override
  State<StrengthTrainingUFifteenVideoListScreen> createState() =>
      _StrengthTrainingUFifteenVideoListScreenState();
}

class _StrengthTrainingUFifteenVideoListScreenState
    extends State<StrengthTrainingUFifteenVideoListScreen> {
  bool isLoading = true;
  late StrengthTrainingU15Api _apiService;

  StrengthTrainingU15Response? _responseData;
  int? selectedIndex;
  String? sportSubheading;

  @override
  void initState() {
    super.initState();
    _apiService = StrengthTrainingU15Api();
    loadData();
  }

  // Load data from the StrenghtTrainingUFifteenDetailsHelper class via the web service.
  Future<void> loadData() async {
    try {
      setState(() => isLoading = true);

      final data = await _apiService.fetchStrengthTrainingDetails(widget.id);

      if (data != null && data.success) {
        setState(() {
          _responseData = data;
          if (data.details.isNotEmpty) {
            sportSubheading = data.details.first.videoHeading;
          }
        });
      }
    } catch (e) {
      print("Error fetching strength training details: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // This displays the header of the screen
  Widget _buildHeader() {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;
    if (widget.header == null) return const SizedBox.shrink();

    return Padding(
      padding:
          isWideScreen
              ? EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h)
              : EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Text(
        widget.header,
        style: TextStyle(
          fontSize: isWideScreen ? 22.sp : 16.sp,
          color: const Color(0xFF1E1E1E),
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // This displays the screen content along with the video list
  Widget _buildExerciseItem() {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;
    if (_responseData == null || _responseData!.details.isEmpty) {
      return Center(
        child: Text(
          "No videos available",
          style: TextStyle(fontSize: 16.sp, color: Colors.grey),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (isWideScreen) customTabletColumn() else customMobleColumn(),
      ],
    );
  }

  Expanded customMobleColumn() {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) {
          bool isLast = index == _responseData!.details.length - 1;

          final color =
              isLast
                  ? (selectedIndex == index
                      ? selectedDividerColor
                      : Colors.white)
                  : (selectedIndex == index
                      ? selectedDividerColor
                      : unselectedDividerColor);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color: color,

              thickness: selectedIndex == index ? 3 : 1,
              height: 4,
            ),
          );
        },
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _responseData!.details.length + 1,
        itemBuilder: (context, index) {
          if (index == _responseData!.details.length) {
            return SizedBox();
          }
          final item = _responseData!.details[index];
          final isSelected = selectedIndex == index;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color:
                  isSelected ? selectLeagueTileColor : unselectLeagueTileColor,
            ),
            child: Container(
              width: 374.w,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });

                  if (item.videoUrl.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                VideoPlayerScreen(videoUrl: item.videoUrl),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid video URL")),
                    );
                  }
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Image.asset(
                        videoPlay,
                        width: 34.w,
                        height: 34.h,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return errorImageContainer();
                        },
                      ),
                    ),
                    SizedBox(width: 13.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.videoHeading,
                            style: videoTitleTextStyle,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item.videoSubHeading,
                            style: videoSubtitleTextStyle,
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor:
                          isSelected
                              ? selectedCircleAvatarcolor
                              : unselectedCircleAvatarcolor,
                      radius: 17.r,
                      child: Center(
                        child: Image.asset(
                          isSelected
                              ? selectedCircleAvater
                              : unselectedCircleAvater,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded customTabletColumn() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          right: 30.0,
          left: 30.0,
          top: 2,
          bottom: 30.0,
        ),
        child: Container(
          decoration: borderContainerDecoration,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              bool isLast = index == _responseData!.details.length - 1;

              final color =
                  isLast
                      ? (selectedIndex == index
                          ? selectedDividerColor
                          : Colors.white)
                      : (selectedIndex == index
                          ? selectedDividerColor
                          : unselectedDividerColor);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  color: color,

                  thickness: selectedIndex == index ? 3 : 1,
                  height: 4,
                ),
              );
            },
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 18.h),
            itemCount: _responseData!.details.length + 1,
            itemBuilder: (context, index) {
              if (index == _responseData!.details.length) {
                return SizedBox();
              }
              final item = _responseData!.details[index];
              final isSelected = selectedIndex == index;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? selectLeagueTileColor
                          : unselectLeagueTileColor,
                ),
                child: Container(
                  width: 374.w,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                      if (item.videoUrl.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    VideoPlayerScreen(videoUrl: item.videoUrl),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid video URL")),
                        );
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 9.0),
                          child: Image.asset(
                            videoPlay,
                            width: 44.w,
                            height: 44.h,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return errorImageContainer();
                            },
                          ),
                        ),
                        SizedBox(width: 23.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.videoHeading,
                                style: videoTitleTextStyle.copyWith(
                                  fontSize: 17.sp,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                item.videoSubHeading,
                                style: videoSubtitleTextStyle.copyWith(
                                  fontSize: 16.sp,
                                ),
                                maxLines: 7,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor:
                              isSelected
                                  ? selectedCircleAvatarcolor
                                  : unselectedCircleAvatarcolor,
                          radius: 20.r,
                          child: Center(
                            child: Image.asset(
                              isSelected
                                  ? selectedCircleAvater
                                  : unselectedCircleAvater,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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
              StrenghtTrainingCustomSubScreenAppbar(
                title: "Styrktaræfingar U15",
                imagePath: strength,
              ),
              Expanded(
                child:
                    isLoading
                        ? Center(child: loadingAnimation)
                        : _buildExerciseItem(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
