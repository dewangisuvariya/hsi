import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:flutter/material.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';
import 'package:url_launcher/url_launcher.dart';

// load Code of Conduct details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HsiCodeOfConductScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;
  const HsiCodeOfConductScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });
  @override
  State<HsiCodeOfConductScreen> createState() => _HsiCodeOfConductScreenState();
}

class _HsiCodeOfConductScreenState extends State<HsiCodeOfConductScreen> {
  bool isLoading = true;

  HeadingDetails? _heading;
  String? errorMessage;
  List<CodeOfConductDetail> codeOfConductDetail = [];

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
          codeOfConductDetail = response.data.codeOfConductDetails;
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
                        ? Center(child: SizedBox.shrink())
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

                                    ...codeOfConductDetail.map((pdfDetail) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          _launchPdf(pdfDetail.conductDetails);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: pdfContainerColor,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ), // Same border radius
                                          ),
                                          // fixedSize: Size(323.w, 54.h),
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
                                                    pdfDetail.conductTitle,
                                                    style: pdfTitleTextStyle,
                                                  ),
                                                ],
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
