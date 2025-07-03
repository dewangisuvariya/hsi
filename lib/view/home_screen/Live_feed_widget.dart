import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:hsi/Model/live_feed_model.dart';
import 'package:hsi/repository/live_feed_helper.dart';

/// A widget that displays a rotating feed of live content including both images and videos.
///
/// Features:
/// - Automatically cycles through available banners (images and videos)
/// - Shows loading indicators while content is being fetched
/// - Handles video playback with thumbnails
/// - Responsive design using ScreenUtil for adaptive sizing
/// - Error handling for failed content loading
class LiveFeedWidget extends StatefulWidget {
  final double? width; // Optional width for the widget
  final double? height; // Optional height for the widget

  const LiveFeedWidget({super.key, this.width, this.height});

  @override
  State<LiveFeedWidget> createState() => _LiveFeedWidgetState();
}

class _LiveFeedWidgetState extends State<LiveFeedWidget> {
  final LiveFeedApiHelper _apiHelper = LiveFeedApiHelper();
  late Future<LiveFeedResponse> _liveFeedFuture;
  List<LiveFeedBanner> _banners = [];
  int _currentIndex = 0;
  Timer? _playbackTimer;
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;
  bool _isVideoInitializing = false;
  Uint8List? _videoThumbnail;

  @override
  void initState() {
    super.initState();
    _initializeLiveFeed();
  }

  /// Initializes the live feed by:
  /// 1. Fetching data from API
  /// 2. Sorting banners by position
  /// 3. Preloading thumbnails for videos
  /// 4. Starting playback of the first item
  Future<void> _initializeLiveFeed() async {
    _liveFeedFuture = _apiHelper.fetchLiveFeed().then((response) async {
      if (mounted) {
        setState(() {
          _banners = LiveFeedBanner.sortByPosition(response.banners);
        });
        await _preloadThumbnails(); // Generate thumbnails for all videos
        if (_banners.isNotEmpty)
          _startPlayback(); // Start playback if we have banners
      }
      return response;
    });
  }

  /// Preloads thumbnails for all video banners in the list
  ///
  /// This improves UX by having thumbnails ready when videos need to be displayed
  Future<void> _preloadThumbnails() async {
    for (var banner in _banners) {
      if (banner.fileType == 'video') {
        try {
          final thumbnail = await _generateThumbnail(banner.fileUrl);
          banner.thumbnailBytes = Future.value(thumbnail);
        } catch (e) {
          print('Error generating thumbnail: $e');
        }
      }
    }
  }

  /// Generates a thumbnail image from a video URL
  ///
  /// Uses the video_thumbnail package to create a JPEG snapshot
  /// at 1 second into the video with 50% quality
  Future<Uint8List> _generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      quality: 50,
      timeMs: 1000, // Capture at 1 second into the video
    );
    return thumbnail ?? Uint8List(0);
  }

  /// Starts the playback cycle by playing the current item
  void _startPlayback() => _playCurrentItem();

  /// Plays the current item in the banners list
  ///
  /// Handles both video and image content types:
  /// - For videos: initializes player and starts playback
  /// - For images: shows for fixed duration then moves to next
  void _playCurrentItem() {
    _cleanupPreviousMedia();
    _currentIndex %= _banners.length;

    final currentBanner = _banners[_currentIndex];
    if (currentBanner.fileType == 'video') {
      _loadAndPlayVideo(currentBanner); // Handle video playback
    } else {
      _showImage(currentBanner.fileUrl); // Handle image display
    }
  }

  /// Loads and plays a video banner
  ///
  /// 1. Shows loading state
  /// 2. Gets thumbnail if available
  /// 3. Initializes video player
  /// 4. Starts playback when ready
  /// 5. Handles errors by moving to next item
  Future<void> _loadAndPlayVideo(LiveFeedBanner banner) async {
    setState(() {
      _isVideoInitializing = true;
      _videoThumbnail = null;
    });

    try {
      // Get thumbnail if available
      if (banner.thumbnailBytes != null) {
        _videoThumbnail = await banner.thumbnailBytes;
      }
      // Initialize video controller
      _videoController =
          VideoPlayerController.network(banner.fileUrl)
            ..setVolume(0)
            ..initialize()
                .then((_) {
                  if (!mounted) return;
                  setState(() {
                    _isVideoPlaying = true;
                    _isVideoInitializing = false;
                  });
                  _videoController!
                    ..play()
                    ..addListener(
                      _onVideoStateChanged,
                    ); // Listen for state changes
                })
                .catchError((error) {
                  if (!mounted) return;
                  setState(() => _isVideoInitializing = false);
                  _moveToNextItemAfterDelay(
                    const Duration(seconds: 3),
                  ); // On error, move to next
                });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isVideoInitializing = false);
      _moveToNextItemAfterDelay(
        const Duration(seconds: 3),
      ); // On error, move to next
    }
  }

  /// Cleans up resources from previous media item
  ///
  /// 1. Cancels any active timers
  /// 2. Removes video listeners
  /// 3. Disposes video controller
  /// 4. Resets video state flags
  void _cleanupPreviousMedia() {
    _playbackTimer?.cancel();
    _videoController?.removeListener(_onVideoStateChanged);
    _videoController?.dispose();
    _videoController = null;
    _isVideoInitializing = false;
  }

  /// Listener for video state changes
  ///
  /// Moves to next item when current video completes playback
  void _onVideoStateChanged() {
    if (_videoController == null || !mounted) return;

    final isVideoComplete =
        !_videoController!.value.isPlaying &&
        _videoController!.value.isInitialized &&
        _videoController!.value.position == _videoController!.value.duration;

    if (isVideoComplete) _moveToNextItem();
  }

  /// Shows an image for a fixed duration then moves to next item
  void _showImage(String imageUrl) =>
      _moveToNextItemAfterDelay(const Duration(seconds: 3));

  /// Schedules moving to next item after a delay
  void _moveToNextItemAfterDelay(Duration delay) {
    _playbackTimer = Timer(delay, _moveToNextItem);
  }

  /// Moves to the next item in the banners list
  ///
  /// Wraps around to beginning when reaching end
  void _moveToNextItem() {
    if (!mounted) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _banners.length;
      _isVideoPlaying = false;
      _playCurrentItem(); // Play the new current item
    });
  }

  @override
  void dispose() {
    _cleanupPreviousMedia();
    super.dispose();
  }

  /// create structure of the screen
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LiveFeedResponse>(
      future: _liveFeedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData || _banners.isEmpty) {
          return _buildErrorOrEmptyState(snapshot.hasError);
        }

        return _buildMediaContainer();
      },
    );
  }

  /// Builds a loading indicator widget
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  /// Builds an error or empty state widget
  Widget _buildErrorOrEmptyState(bool hasError) {
    return Center(
      child: Text(
        hasError ? 'Error loading content' : 'No content available',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
    );
  }

  /// Builds the container for the current media item
  Widget _buildMediaContainer() {
    final currentBanner = _banners[_currentIndex];

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child:
            currentBanner.fileType == 'video'
                ? _buildVideoPlayer(currentBanner)
                : _buildImage(currentBanner.fileUrl),
      ),
    );
  }

  /// Builds the video player widget
  ///
  /// Shows either:
  /// 1. The video player when initialized
  /// 2. A thumbnail while loading
  /// 3. A loading indicator while waiting for thumbnail

  Widget _buildVideoPlayer(LiveFeedBanner banner) {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _videoController!.value.size.width,
            height: _videoController!.value.size.height,
            child: VideoPlayer(_videoController!),
          ),
        ),
      );
    }

    /// Show thumbnail while video is loading
    return FutureBuilder<Uint8List?>(
      future: banner.thumbnailBytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            _videoThumbnail == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.transparent),
            ),
          );
        }

        return Image.memory(
          _videoThumbnail!,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        );
      },
    );
  }

  /// Builds the image widget with loading and error states
  Widget _buildImage(String imageUrl) {
    return Image.network(
      imageUrl,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        return loadingProgress == null
            ? child
            : Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
      },
      errorBuilder:
          (context, error, stackTrace) => Container(
            color: Colors.grey[800],
            child: Center(
              child: Icon(
                Icons.broken_image,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),
    );
  }
}
