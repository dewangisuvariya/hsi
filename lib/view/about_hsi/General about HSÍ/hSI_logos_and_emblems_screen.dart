import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

// load HSI Logos & Emblems details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HsiLogosAndEmblemsScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const HsiLogosAndEmblemsScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<HsiLogosAndEmblemsScreen> createState() =>
      _HsiLogosAndEmblemsScreenState();
}

class _HsiLogosAndEmblemsScreenState extends State<HsiLogosAndEmblemsScreen> {
  bool isLoading = true;
  HeadingDetails? _heading;
  List<LogoDetail> logoDetails = [];
  String? errorMessage;
  Map<String, bool> downloadingStatus = {};
  Map<String, double> downloadProgress = {};
  Map<String, bool> downloadComplete = {};
  Map<String, String> downloadedFilePaths = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from the FetchAboutHsiDetailsHelper class via the web service.
  Future<void> _loadData() async {
    try {
      final response = await AboutHsiDetailsHelper.fetchAboutHsiDetails(
        widget.subSectionId,
      );
      if (mounted) {
        setState(() {
          _heading = response.data.headingDetails;
          logoDetails = response.data.logoDetails;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load data: $e';
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
    }
  }

  // When the user selects a file, prompt for a download path and allow selection of file types like JPG, PNG, SVG, EPS or PDF."
  Future<void> _downloadFile(String url, String fileName) async {
    try {
      setState(() {});

      // Generate timestamp for unique filename
      final time = DateTime.now().millisecondsSinceEpoch;
      final uniqueFileName = fileName.replaceAll('.', '_$time.');

      // Get the appropriate downloads directory
      Directory directory;
      if (Platform.isAndroid) {
        // Use public Downloads directory on Android
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = (await getExternalStorageDirectory())!;
        }
      } else {
        // Use documents directory on iOS
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final filePath = '${directory.path}/$uniqueFileName';
      final file = File(filePath);

      // Download using http package approach similar to your example
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {});
          }
        },
      );

      if (response.statusCode != 200) {
        throw 'Download failed with status ${response.statusCode}';
      }

      // Write bytes to file - similar to your example
      await file.writeAsBytes(response.data as List<int>);

      // Verify download
      if (!await file.exists()) {
        throw 'File download verification failed';
      }

      // For Android, use MediaScanner to make file visible
      if (Platform.isAndroid) {
        try {
          await _scanFile(filePath);
        } catch (e) {
          debugPrint('Error scanning file: $e');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File saved successfully'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () => OpenFile.open(filePath),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
      debugPrint('Download error: $e');
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  // Helper method for Android file scanning
  Future<void> _scanFile(String path) async {
    if (!Platform.isAndroid) return;

    try {
      const platform = MethodChannel('flutter.io');
      await platform.invokeMethod('scanFile', {'path': path});
    } on PlatformException catch (e) {
      debugPrint('Failed to scan file: ${e.message}');
    }
  }

  // Custom widget to display a logo with a title."
  Widget _buildLogoCard(LogoDetail logo, String title) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          if (logo.jpgLogo != null || logo.pngLogo != null)
            Center(
              child: Image.network(
                logo.jpgLogo ?? logo.pngLogo!,
                height: 61.85.h,
                width: 77.w,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.broken_image, size: 50.sp);
                },
              ),
            ),
          SizedBox(height: 6.h),
          Text(
            logo.logoName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFF28E2B),
              fontFamily: 'Poppins',
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (logo.jpgLogo != null)
                _buildDownloadButton(
                  "JPG",
                  logo.jpgLogo!,
                  'HSI_${title.replaceAll(' ', '_')}.jpg',
                ),
              if (logo.pdfLogo != null)
                _buildDownloadButton(
                  "PDF",
                  logo.pdfLogo!,
                  'HSI_${title.replaceAll(' ', '_')}.pdf',
                ),
              if (logo.epsLogo != null)
                _buildDownloadButton(
                  "EPS",
                  logo.epsLogo!,
                  'HSI_${title.replaceAll(' ', '_')}.eps',
                ),
              if (logo.pngLogo != null)
                _buildDownloadButton(
                  "PNG",
                  logo.pngLogo!,
                  'HSI_${title.replaceAll(' ', '_')}.png',
                ),
              if (logo.svgLogo != null)
                _buildDownloadButton(
                  "SVG",
                  logo.svgLogo!,
                  'HSI_${title.replaceAll(' ', '_')}.svg',
                ),
            ],
          ),
        ],
      ),
    );
  }

  // When the user presses the button and the image is downloading, show a UI indicator using a custom widget
  Widget _buildDownloadButton(String format, String url, String fileName) {
    final isDownloading = downloadingStatus[url] == true;
    final isDownloaded = downloadComplete[url] == true;
    bool isSelected =
        downloadingStatus.containsKey(url) && downloadingStatus[url]!;

    return ElevatedButton(
      onPressed: isDownloading ? null : () => _downloadFile(url, fileName),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(73.w, 32.h),
        backgroundColor:
            isSelected
                ? Color(0xFFA0A0A0)
                : isDownloaded
                ? Color(0xFFA0A0A0)
                : isDownloading
                ? Color(0xFFA0A0A0)
                : Color(0xFFF0F0F0),
        foregroundColor: isDownloaded ? Colors.white : const Color(0xFF757575),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(vertical: 8.h),
      ),
      child: Text(
        format,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins",
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
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
              ),
              Expanded(
                child:
                    isLoading
                        ? Center(child: loadingAnimation)
                        : errorMessage != null
                        ? Center(
                          child: Text(
                            "",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16.sp,
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: borderContainerDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...logoDetails.map(
                                      (logo) =>
                                          _buildLogoCard(logo, logo.logoName),
                                    ),
                                    if (_heading != null &&
                                        _heading!.heading.isNotEmpty) ...[
                                      SizedBox(height: 10.h),
                                      Text(
                                        _heading!.heading,
                                        style: descriptionTextStyle,
                                      ),
                                    ],
                                    if (_heading != null &&
                                        _heading!.subHeading?.isNotEmpty ==
                                            true) ...[
                                      SizedBox(height: 10.h),
                                      Text(
                                        _heading!.subHeading!,
                                        style: descriptionTextStyle,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
