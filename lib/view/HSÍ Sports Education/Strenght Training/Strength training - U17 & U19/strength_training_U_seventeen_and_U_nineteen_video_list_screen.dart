import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/uSeventeen_uNineteen_team_level_details_model.dart';
import 'package:hsi/Model/useventeen-unineteen_videos_details_by_level_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/uSeventeen_uNineteen_team_level_details_helper.dart';
import 'package:hsi/repository/useventeen-unineteen_videos_details_by_level_helper.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/video_player_screen.dart';
// load strength training USeventeen and UNineteen video list details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class StrengthTrainingUSeventeenAndUNineteenVideoListScreen
    extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final String header;
  final int sportEducationId;

  const StrengthTrainingUSeventeenAndUNineteenVideoListScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.header,
    required this.sportEducationId,
  });

  @override
  State<StrengthTrainingUSeventeenAndUNineteenVideoListScreen> createState() =>
      _StrengthTrainingUSeventeenAndUNineteenVideoListScreenState();
}

class _StrengthTrainingUSeventeenAndUNineteenVideoListScreenState
    extends State<StrengthTrainingUSeventeenAndUNineteenVideoListScreen> {
  StrengthTrainingLevelModel? _levelsData;
  bool isLoading = true;
  String? errorMessage;

  final Map<int, bool> _expandedSections = {};
  final Map<int, bool> _loadingVideos = {};
  final Map<int, VideoDetailsModel?> _loadedVideos = {};
  final Map<int, String?> _videoErrors = {};

  // Track the currently selected video across all lists
  int? _selectedVideoId;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  // Load data from the USeventeenAndUNineteenTeamLevelDetailHelper class via the web service.
  Future<void> _loadLevels() async {
    try {
      final data = await U17U19LevelApiHelper.fetchU17U19Levels(
        widget.sportEducationId,
      );
      if (mounted) {
        setState(() {
          _levelsData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load levels';
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
    }
  }

  // Load data from the USeventeenAndUNineteenVideosDetailByLevelHelper class via the web service.
  Future<void> _loadVideos(int levelId) async {
    if (_loadedVideos.containsKey(levelId)) return;

    if (mounted) {
      setState(() {
        _loadingVideos[levelId] = true;
        _videoErrors[levelId] = null;
      });
    }

    try {
      final videos = await U17U19VideosApiHelper.fetchU17U19Videos(levelId);
      if (mounted) {
        setState(() {
          _loadedVideos[levelId] = videos;
          _loadingVideos[levelId] = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _videoErrors[levelId] = 'Failed to load videos';
          _loadingVideos[levelId] = false;
        });
      }
    }
  }

  // Toggle the container: open it when the user selects it, and close it if it's already open and selected again.
  void _toggleSectionExpansion(int levelId) {
    if (mounted) {
      setState(() {
        _expandedSections[levelId] = !(_expandedSections[levelId] ?? false);
        if (_expandedSections[levelId] == true) {
          _loadVideos(levelId);
        }
      });
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
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
              ),
              Expanded(child: _buildMainContent()),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  //This displays the screen's main UI, and it shows the initial level name
  Widget _buildMainContent() {
    if (isLoading) {
      return const SizedBox();
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (_levelsData == null || _levelsData!.levels.isEmpty) {
      return const Center(child: Text('No levels available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        children:
            _levelsData!.levels.asMap().entries.map((entry) {
              final index = entry.key;
              final level = entry.value;
              final isExpanded = _expandedSections[level.id] ?? false;
              final isFirst = index == 0;
              final isLast = index == _levelsData!.levels.length - 1;
              return Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide.none,
                    vertical: BorderSide(color: unselectedCart, width: 1.0),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? Radius.circular(8.r) : Radius.zero,
                    topRight: isFirst ? Radius.circular(8.r) : Radius.zero,
                    bottomLeft: isLast ? Radius.circular(8.r) : Radius.zero,
                    bottomRight: isLast ? Radius.circular(8.r) : Radius.zero,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft:
                                isFirst ? Radius.circular(8.r) : Radius.zero,
                            topRight:
                                isFirst ? Radius.circular(8.r) : Radius.zero,
                            bottomLeft:
                                isLast ? Radius.circular(8.r) : Radius.zero,
                            bottomRight:
                                isLast ? Radius.circular(8.r) : Radius.zero,
                          ),
                          color: unselectedCart,
                        ),
                        child: ListTile(
                          title: Text(
                            level.levelName,
                            style: videoListTitleTextStyle,
                          ),
                          trailing: GestureDetector(
                            onTap: () => _toggleSectionExpansion(level.id),
                            child: SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: Image.asset(
                                isExpanded ? rightUp : arrowDown,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isExpanded) _buildVideoContent(level.id),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  //This displays the screen's main video container UI, and displays content by type, separated accordingly
  Widget _buildVideoContent(int levelId) {
    if (_loadingVideos[levelId] == true) {
      return const Padding(padding: EdgeInsets.all(16.0), child: SizedBox());
    }

    if (_videoErrors[levelId] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_videoErrors[levelId]!),
      );
    }

    final videoDetails = _loadedVideos[levelId];
    if (videoDetails == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No videos available'),
      );
    }

    return Column(
      children: [
        if (videoDetails.warmUpVideos.isNotEmpty) ...[
          _buildSectionTitle("1. Upphitun:"),
          _buildVideoList(videoDetails.warmUpVideos),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Divider(color: unselectedDividerColor, thickness: 1),
        ),
        if (videoDetails.exerciseVideos.isNotEmpty) ...[
          _buildSectionTitle("2. Æfing:"),
          _buildVideoList(videoDetails.exerciseVideos),
        ],
      ],
    );
  }

  // this widget displays  Section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, left: 16.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: emailOtpScreenTextStyle.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  //This displays the screen's main video container UI, showing the initial video name and details, along with navigation to the video playback screen
  Widget _buildVideoList(List<VideoItem> videos) {
    if (videos.isEmpty) {
      return const SizedBox();
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: videos.length + 1,

      separatorBuilder: (context, index) {
        bool isLast = index == videos.length - 1;
        final color =
            isLast
                ? (_selectedVideoId == videos[index].id
                    ? selectedDividerColor
                    : Colors.white)
                : (_selectedVideoId == videos[index].id
                    ? selectedDividerColor
                    : unselectedDividerColor);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Divider(
            color: color,

            thickness: _selectedVideoId == videos[index].id ? 3 : 1,
            height: 4,
          ),
        );
      },
      itemBuilder: (context, index) {
        if (index == videos.length) {
          return SizedBox();
        }
        final item = videos[index];
        final isSelected = _selectedVideoId == item.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedVideoId = item.id;
            });
            if (item.videoUrl.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => VideoPlayerScreen(videoUrl: item.videoUrl),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid video URL")),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected ? selectLeagueTileColor : unselectLeagueTileColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
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
                        return Container(
                          width: 34.w,
                          height: 34.h,
                          color: Colors.grey,
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 13.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.heading,
                          style: videoTitleTextStyle,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.subHeading,
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
    );
  }
}
