import 'dart:io';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/fecth_about_hsi_details_helper.dart';
import 'package:url_launcher/url_launcher.dart';

// load Laws of HSÍ details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class LawsOfHsiScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const LawsOfHsiScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<LawsOfHsiScreen> createState() => _LawsOfHsiScreenState();
}

class _LawsOfHsiScreenState extends State<LawsOfHsiScreen> {
  bool isLoading = true;

  HeadingDetails? _heading;
  String? errorMessage;
  List<LawDetail> lawDetail = [];

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
          lawDetail = response.data.lawDetails;
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

  // When the user taps the button, the selected file (PDF) should launch in the appropriate viewer
  Future<void> _launchPdf(String url) async {
    try {
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode:
              Platform.isAndroid
                  ? LaunchMode.externalNonBrowserApplication
                  : LaunchMode.platformDefault,
        );
      } else {
        if (Platform.isAndroid) {
          // Try with a more compatible approach for Android
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
            webOnlyWindowName: '_blank',
          );
        } else {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening PDF: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
      debugPrint('Error launching PDF: $e');
    }
  }
  // create structure of the screen

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backgroundColorProvider.updateBackgroundColor(const Color(0xFFFAFAFA));
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
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
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        )
                        : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: borderContainerDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (_heading != null) ...[
                                      Text(
                                        _heading!.heading,
                                        style: pdfButtonTextStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Divider(
                                          color: selectedDividerColor,
                                          thickness: 1,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],

                                    ...lawDetail.map((pdfDetail) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            _launchPdf(pdfDetail.lawDetails);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: pdfContainerColor,
                                            elevation: 0,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 5,
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 10,
                                                    ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      pdf,
                                                      height: 30.h,
                                                      width: 30.w,
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Text(
                                                      pdfDetail.lawTitle,
                                                      style: pdfTitleTextStyle,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
