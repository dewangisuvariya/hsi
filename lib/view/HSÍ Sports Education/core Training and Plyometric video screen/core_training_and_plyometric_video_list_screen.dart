import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/core_training_and_plyometric_details_model.dart';
import 'package:hsi/Model/core_training_and_plyometric_video_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/core_training_and_plyometric_details_helper.dart';
import 'package:hsi/repository/core_training_and_plyometric_video_details_helper.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/video_player_screen.dart';

// load core training and plyometric video list details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class CoreTrainingAndPlyometricVideoListScreen extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final int sportEducationId;

  const CoreTrainingAndPlyometricVideoListScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.sportEducationId,
  });

  @override
  State<CoreTrainingAndPlyometricVideoListScreen> createState() =>
      _CoreTrainingAndPlyometricVideoListScreenState();
}

class _CoreTrainingAndPlyometricVideoListScreenState
    extends State<CoreTrainingAndPlyometricVideoListScreen> {
  PlyometricDetailsModel? _plyometricDetails;
  bool _isLoading = true;
  String? _errorMessage;

  // For video details
  final Map<int, PlyometricVideoDetailsModel?> _loadedVideos = {};
  final Map<int, bool> _loadingVideos = {};
  final Map<int, String?> _videoErrors = {};
  final Map<int, bool> _expandedSections = {};
  int? _selectedVideoId;

  @override
  void initState() {
    super.initState();
    _fetchPlyometricDetails();
  }

  // Load data from the CoreTraningAndPlyometricDetailsHelper class via the web service.
  Future<void> _fetchPlyometricDetails() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final details = await PlyometricDetailsHelper.fetchPlyometricDetails(
        widget.sportEducationId,
      );

      if (mounted) {
        setState(() {
          _plyometricDetails = details;
          if (details == null) {
            _errorMessage = 'Failed to load plyometric details';
          } else {
            // Initialize expanded sections
            for (var data in details.data) {
              _expandedSections[data.id] = false;
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading plyometric details: $e';
          _isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
    }
  }

  // Load data from the CoreTraningAndPlyometricVideoDetailsHelper class via the web service.
  Future<void> _fetchVideoDetails(int detailId) async {
    if (mounted) {
      setState(() {
        _loadingVideos[detailId] = true;
        _videoErrors[detailId] = null;
      });
    }

    try {
      final videoDetails = await PlyometricVideoDetailsHelper.fetchVideoDetails(
        detailId,
      );

      if (mounted) {
        setState(() {
          _loadedVideos[detailId] = videoDetails;
          _loadingVideos[detailId] = false;
          if (videoDetails == null) {
            _videoErrors[detailId] = 'Failed to load video details';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _videoErrors[detailId] = 'Error loading videos: $e';
          _loadingVideos[detailId] = false;
        });
      }
    }
  }

  // Toggle the container: open it when the user selects it, and close it if it's already open and selected again
  void _toggleSectionExpansion(int detailId) {
    if (mounted) {
      setState(() {
        final isExpanded = !(_expandedSections[detailId] ?? false);
        _expandedSections[detailId] = isExpanded;

        if (isExpanded && !_loadedVideos.containsKey(detailId)) {
          _fetchVideoDetails(detailId);
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
          if (_isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }
  //This displays the screen's main UI, and it shows the initial level name

  Widget _buildMainContent() {
    if (_isLoading) {
      return const SizedBox();
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_plyometricDetails == null || _plyometricDetails!.data.isEmpty) {
      return const Center(child: Text('No plyometric details available'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        children:
            _plyometricDetails!.data.asMap().entries.map((entry) {
              final index = entry.key;
              final detail = entry.value;
              final isExpanded = _expandedSections[detail.id] ?? false;
              final isFirst = index == 0;
              final isLast = index == _plyometricDetails!.data.length - 1;

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
                            detail.pointDetail,
                            style: videoListTitleTextStyle,
                          ),
                          trailing: GestureDetector(
                            onTap: () => _toggleSectionExpansion(detail.id),
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
                    if (isExpanded) _buildVideoContent(detail.id),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }
  //This displays the screen's main video container UI, showing the initial video name and details, along with navigation to the video playback screen

  Widget _buildVideoContent(int detailId) {
    if (_loadingVideos[detailId] == true) {
      return Padding(padding: const EdgeInsets.all(16.0), child: Container());
    }

    if (_videoErrors[detailId] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(_videoErrors[detailId]!),
      );
    }

    final videoDetails = _loadedVideos[detailId];
    if (videoDetails == null || videoDetails.videos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No videos available'),
      );
    }

    return Column(children: [_buildVideoList(videoDetails.videos)]);
  }

  Widget _buildVideoList(List<PlyometricVideo> videos) {
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
        final video = videos[index];
        final isSelected = _selectedVideoId == video.id;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedVideoId = video.id;
            });
            if (video.videoUrl.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => VideoPlayerScreen(videoUrl: video.videoUrl),
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
                          video.videoHeading,
                          style: videoTitleTextStyle,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          video.videoSubHeading,
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
