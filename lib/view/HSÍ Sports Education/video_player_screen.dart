// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/const/resource_manager.dart';
// import 'package:hsi/const/style_manager.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// /// A screen that plays videos from various sources including direct video files,
// /// YouTube, Vimeo, and other platforms. It automatically detects the video source
// /// type and uses the appropriate player (Chewie for direct files, WebView for
// /// embedded players, or launches browser for unsupported platforms).
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   final VoidCallback? onEnter; // Callback when entering video player
//   final VoidCallback? onExit; // Callback when exiting video player

//   const VideoPlayerScreen({
//     Key? key,
//     required this.videoUrl,
//     this.onEnter,
//     this.onExit,
//   }) : super(key: key);

//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }

// enum VideoSourceType {
//   direct, // Direct video file (mp4, m3u8, etc.)
//   youtube, // YouTube URL
//   vimeo, // Vimeo URL
//   other, // Other streaming platforms
//   unknown, // Unknown or unsupported
// }

// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isLoading = true;
//   String? _errorMessage;
//   late final WebViewController _webViewController;
//   VideoSourceType _videoSourceType = VideoSourceType.unknown;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize WebViewController for embedded players (YouTube, Vimeo)
//     _webViewController = WebViewController();
//     // Start the video initialization process
//     _initializePlayer();
//     // Call the enter callback after the first frame is rendered
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       widget.onEnter?.call();
//     });
//   }

//   @override
//   void dispose() {
//     if (_videoSourceType == VideoSourceType.direct) {
//       _videoPlayerController.dispose();
//       _chewieController?.dispose();
//     }

//     // Call the exit callback if provided
//     widget.onExit?.call();

//     super.dispose();
//   }

//   /// Determines the type of video source based on the URL
//   VideoSourceType _determineVideoSource(String url) {
//     if (url.isEmpty) return VideoSourceType.unknown;

//     final uri = Uri.tryParse(url);
//     if (uri == null) return VideoSourceType.unknown;

//     // Check for direct video files
//     if (url.endsWith('.mp4') ||
//         url.endsWith('.mov') ||
//         url.endsWith('.m3u8') ||
//         url.endsWith('.mkv')) {
//       return VideoSourceType.direct;
//     }

//     // Check for YouTube
//     if (uri.host.contains('youtube.com') ||
//         uri.host.contains('youtu.be') ||
//         uri.host.contains('youtube-nocookie.com')) {
//       return VideoSourceType.youtube;
//     }

//     // Check for Vimeo
//     if (uri.host.contains('vimeo.com')) {
//       return VideoSourceType.vimeo;
//     }

//     // For other known streaming platforms
//     if (uri.host.contains('dailymotion.com') ||
//         uri.host.contains('twitch.tv') ||
//         uri.host.contains('facebook.com') ||
//         uri.host.contains('instagram.com')) {
//       return VideoSourceType.other;
//     }

//     // Default to direct if we can't determine (might work for some URLs)
//     return VideoSourceType.direct;
//   }

//   /// Extracts the video ID from URLs for platforms like YouTube and Vimeo
//   String? _extractVideoId(String url, VideoSourceType type) {
//     final uri = Uri.tryParse(url);
//     if (uri == null) return null;

//     switch (type) {
//       case VideoSourceType.youtube:
//         if (uri.host.contains('youtu.be')) {
//           return uri.pathSegments.first;
//         } else if (uri.queryParameters.containsKey('v')) {
//           return uri.queryParameters['v'];
//         } else if (uri.pathSegments.length > 1 &&
//             uri.pathSegments[0] == 'embed') {
//           return uri.pathSegments[1];
//         }
//         return null;
//       case VideoSourceType.vimeo:
//         final regex = RegExp(
//           r'vimeo\.com/(?:video/|showcase/\d+/video/)?(\d+)',
//         );
//         final match = regex.firstMatch(url);
//         return match?.group(1);
//       default:
//         return null;
//     }
//   }

//   /// Main initialization method that sets up the appropriate player based on source type
//   Future<void> _initializePlayer() async {
//     try {
//       if (widget.videoUrl.isEmpty) {
//         throw Exception("Video URL is empty");
//       }

//       _videoSourceType = _determineVideoSource(widget.videoUrl);

//       switch (_videoSourceType) {
//         case VideoSourceType.direct:
//           await _setupDirectVideoPlayer();
//           break;
//         case VideoSourceType.youtube:
//           await _setupYoutubePlayer();
//           break;
//         case VideoSourceType.vimeo:
//           await _setupVimeoPlayer();
//           break;
//         case VideoSourceType.other:
//           await _setupOtherPlatformPlayer();
//           break;
//         case VideoSourceType.unknown:
//           throw Exception("Unsupported video URL format");
//       }

//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = "Failed to load video: ${e.toString()}";
//           _isLoading = false;
//         });
//       }
//     }
//   }

//   /// Sets up the player for direct video files (MP4, M3U8, etc.)
//   Future<void> _setupDirectVideoPlayer() async {
//     _videoPlayerController = VideoPlayerController.network(
//       widget.videoUrl,
//     )..addListener(() {
//       if (_videoPlayerController.value.hasError && mounted) {
//         setState(() {
//           _errorMessage =
//               "Video playback error: ${_videoPlayerController.value.errorDescription}";
//           _isLoading = false;
//         });
//       }
//     });

//     await _videoPlayerController.initialize();
//     if (mounted) {
//       _chewieController = ChewieController(
//         videoPlayerController: _videoPlayerController,
//         autoPlay: true,
//         looping: false,
//         aspectRatio: _videoPlayerController.value.aspectRatio,
//         errorBuilder: (context, errorMessage) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 50),
//                 const SizedBox(height: 10),
//                 Text(
//                   errorMessage,
//                   style: const TextStyle(color: Colors.white),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _retryLoading,
//                   child: const Text("Retry"),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     }
//   }

//   /// Sets up YouTube player using WebView
//   Future<void> _setupYoutubePlayer() async {
//     final videoId = _extractVideoId(widget.videoUrl, VideoSourceType.youtube);
//     if (videoId == null) {
//       throw Exception("Could not extract YouTube video ID");
//     }

//     final youtubeEmbedUrl = 'https://www.youtube.com/embed/$videoId?autoplay=1';

//     await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
//     await _webViewController.setNavigationDelegate(
//       NavigationDelegate(
//         onNavigationRequest: (request) {
//           if (!request.url.startsWith(youtubeEmbedUrl)) {
//             launchUrl(Uri.parse(request.url));
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     );
//     await _webViewController.loadRequest(Uri.parse(youtubeEmbedUrl));
//   }

//   /// Sets up Vimeo player using WebView
//   Future<void> _setupVimeoPlayer() async {
//     final videoId = _extractVideoId(widget.videoUrl, VideoSourceType.vimeo);
//     if (videoId == null) {
//       throw Exception("Could not extract Vimeo video ID");
//     }

//     await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
//     await _webViewController.loadRequest(
//       Uri.parse('https://player.vimeo.com/video/$videoId?autoplay=1'),
//     );
//   }

//   /// Handles setup for other video platforms (Dailymotion, Twitch, etc.)
//   Future<void> _setupOtherPlatformPlayer() async {
//     final uri = Uri.tryParse(widget.videoUrl);
//     if (uri == null) {
//       throw Exception("Invalid video URL");
//     }

//     if (uri.host.contains('dailymotion.com')) {
//       final videoId = uri.pathSegments.last;
//       await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
//       await _webViewController.loadRequest(
//         Uri.parse(
//           'https://www.dailymotion.com/embed/video/$videoId?autoplay=1',
//         ),
//       );
//     } else {
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//         Navigator.pop(context);
//       } else {
//         throw Exception("Could not launch video URL");
//       }
//     }
//   }

//   /// Retries video loading when an error occurs
//   void _retryLoading() {
//     if (mounted) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//     }
//     _initializePlayer();
//   }

//   /// Builds the WebView player widget for embedded players
//   Widget _buildWebViewPlayer() {
//     return WebViewWidget(controller: _webViewController);
//   }

//   // Builds the UI for unsupported platforms with an error message
//   Widget _buildUnsupportedPlatform() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, color: Colors.red, size: 50),
//           const SizedBox(height: 20),
//           Text(
//             "This video platform is not supported for embedded playback",
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () async {
//               if (await canLaunchUrl(Uri.parse(widget.videoUrl))) {
//                 await launchUrl(Uri.parse(widget.videoUrl));
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text("Open in Browser"),
//           ),
//         ],
//       ),
//     );
//   }

//   // create structure of the screen
//   @override
//   Widget build(BuildContext context) {
//     if (_videoSourceType == VideoSourceType.direct) {
//       return Scaffold(
//         backgroundColor: Colors.black,
//         body: SafeArea(
//           child:
//               _isLoading
//                   ? Center(child: loadingAnimation)
//                   : _errorMessage != null
//                   ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           color: Colors.red,
//                           size: 50,
//                         ),
//                         const SizedBox(height: 20),
//                         Text(_errorMessage!, textAlign: TextAlign.center),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _retryLoading,
//                           child: const Text("Try Again"),
//                         ),
//                       ],
//                     ),
//                   )
//                   : Chewie(controller: _chewieController!),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: appBarColor,
//       appBar: AppBar(
//         backgroundColor: appBarColor,
//         leading: Container(
//           //   color: Colors.amber,
//           child: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Image.asset(backArrow, height: 40.h, width: 30.w),
//           ),
//         ),
//       ),
//       body:
//           _isLoading
//               ? Center(child: loadingAnimation)
//               : _errorMessage != null
//               ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       color: Colors.red,
//                       size: 50,
//                     ),
//                     const SizedBox(height: 20),
//                     Text(_errorMessage!, textAlign: TextAlign.center),
//                     const SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _retryLoading,
//                       child: const Text("Try Again"),
//                     ),
//                   ],
//                 ),
//               )
//               : _videoSourceType == VideoSourceType.other
//               ? _buildUnsupportedPlatform()
//               : _buildWebViewPlayer(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onEnter;
  final VoidCallback? onExit;

  const VideoPlayerScreen({
    Key? key,
    required this.videoUrl,
    this.onEnter,
    this.onExit,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

enum VideoSourceType { direct, youtube, vimeo, other, unknown }

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  late final WebViewController _webViewController;
  bool _isLoading = true;
  String? _errorMessage;
  VideoSourceType _videoSourceType = VideoSourceType.unknown;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController();
    _initializePlayer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onEnter?.call();
    });
  }

  @override
  void dispose() {
    if (_videoSourceType == VideoSourceType.direct) {
      _videoPlayerController.dispose();
    }
    widget.onExit?.call();
    super.dispose();
  }

  VideoSourceType _determineVideoSource(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null || url.isEmpty) return VideoSourceType.unknown;

    if (url.endsWith('.mp4') || url.endsWith('.mov') || url.endsWith('.m3u8')) {
      return VideoSourceType.direct;
    } else if (uri.host.contains('youtube.com') ||
        uri.host.contains('youtu.be')) {
      return VideoSourceType.youtube;
    } else if (uri.host.contains('vimeo.com')) {
      return VideoSourceType.vimeo;
    } else if (uri.host.contains('dailymotion.com') ||
        uri.host.contains('twitch.tv') ||
        uri.host.contains('facebook.com') ||
        uri.host.contains('instagram.com')) {
      return VideoSourceType.other;
    }

    return VideoSourceType.unknown;
  }

  String? _extractVideoId(String url, VideoSourceType type) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    switch (type) {
      case VideoSourceType.youtube:
        if (uri.host.contains('youtu.be')) return uri.pathSegments.first;
        if (uri.queryParameters.containsKey('v'))
          return uri.queryParameters['v'];
        if (uri.pathSegments.length > 1 && uri.pathSegments[0] == 'embed') {
          return uri.pathSegments[1];
        }
        return null;

      case VideoSourceType.vimeo:
        final match = RegExp(
          r'vimeo\.com/(?:video/|showcase/\d+/video/)?(\d+)',
        ).firstMatch(url);
        return match?.group(1);

      default:
        return null;
    }
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.videoUrl.isEmpty) throw Exception("Video URL is empty");

      _videoSourceType = _determineVideoSource(widget.videoUrl);

      switch (_videoSourceType) {
        case VideoSourceType.direct:
          await _setupDirectVideoPlayer();
          break;
        case VideoSourceType.youtube:
          await _setupYoutubePlayer();
          break;
        case VideoSourceType.vimeo:
          await _setupVimeoPlayer();
          break;
        case VideoSourceType.other:
          await _setupOtherPlatformPlayer();
          break;
        default:
          throw Exception("Unsupported video format");
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Error: ${e.toString()}";
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _setupDirectVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        if (_videoPlayerController.value.hasError && mounted) {
          setState(() {
            _errorMessage = _videoPlayerController.value.errorDescription;
          });
        }
      });

    await _videoPlayerController.initialize();
    _videoPlayerController.play();
  }

  Future<void> _setupYoutubePlayer() async {
    final videoId = _extractVideoId(widget.videoUrl, VideoSourceType.youtube);
    if (videoId == null) throw Exception("Could not extract YouTube ID");

    final embedUrl = 'https://www.youtube.com/embed/$videoId?autoplay=1';
    await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _webViewController.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) {
          if (!request.url.startsWith(embedUrl)) {
            launchUrl(Uri.parse(request.url));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
    await _webViewController.loadRequest(Uri.parse(embedUrl));
  }

  Future<void> _setupVimeoPlayer() async {
    final videoId = _extractVideoId(widget.videoUrl, VideoSourceType.vimeo);
    if (videoId == null) throw Exception("Could not extract Vimeo ID");

    final embedUrl = 'https://player.vimeo.com/video/$videoId?autoplay=1';
    await _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
    await _webViewController.loadRequest(Uri.parse(embedUrl));
  }

  Future<void> _setupOtherPlatformPlayer() async {
    final uri = Uri.tryParse(widget.videoUrl);
    if (uri == null) throw Exception("Invalid video URL");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      if (mounted) Navigator.pop(context);
    } else {
      throw Exception("Unable to launch video URL");
    }
  }

  void _retryLoading() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    _initializePlayer();
  }

  Widget _buildWebViewPlayer() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 185.h,
        child: WebViewWidget(controller: _webViewController),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 20),
          Text(_errorMessage ?? "Unknown error", textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _retryLoading,
            child: const Text("Try Again"),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedPlatform() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            "Platform not supported for playback",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse(widget.videoUrl))) {
                await launchUrl(Uri.parse(widget.videoUrl));
                Navigator.pop(context);
              }
            },
            child: const Text("Open in Browser"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBarColor,
      appBar:
          _videoSourceType == VideoSourceType.direct
              ? null
              : AppBar(
                backgroundColor: appBarColor,
                leading: IconButton(
                  icon: Image.asset(backArrow, height: 40.h, width: 30.w),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (_isLoading) return Center(child: loadingAnimation);
            if (_errorMessage != null) return _buildErrorWidget();

            if (_videoSourceType == VideoSourceType.direct) {
              return Center(
                child: Container(
                  width: double.infinity,
                  height: 185.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.black,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
                ),
              );
            }

            if (_videoSourceType == VideoSourceType.other) {
              return _buildUnsupportedPlatform();
            }

            return _buildWebViewPlayer();
          },
        ),
      ),
      floatingActionButton:
          _videoSourceType == VideoSourceType.direct &&
                  _videoPlayerController.value.isInitialized
              ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _videoPlayerController.value.isPlaying
                        ? _videoPlayerController.pause()
                        : _videoPlayerController.play();
                  });
                },
                child: Icon(
                  _videoPlayerController.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
              )
              : null,
    );
  }
}
