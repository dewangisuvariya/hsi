import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/repository/fecth_about_hsi_details_helper.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';

// load HSÍ regulations details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HsiRegulationsScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const HsiRegulationsScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<HsiRegulationsScreen> createState() => _HsiRegulationsScreenState();
}

class _HsiRegulationsScreenState extends State<HsiRegulationsScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<RegulationDetail> regulationDetail = [];

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
          regulationDetail = response.data.regulationDetails;
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening PDF: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
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
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: borderContainerDecoration,
                              child: Column(
                                children: [
                                  ListView.separated(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: regulationDetail.length,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    separatorBuilder:
                                        (context, index) =>
                                            SizedBox(height: 8.h),
                                    itemBuilder: (context, index) {
                                      final pdfDetail = regulationDetail[index];

                                      return ElevatedButton(
                                        onPressed:
                                            () => _launchPdf(
                                              pdfDetail.regulationDetails,
                                            ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: pdfContainerColor,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 5,
                                          ),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                pdf,
                                                height: 30.h,
                                                width: 30.w,
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: Text(
                                                  maxLines: 3,
                                                  pdfDetail.regulationTitle,
                                                  style: pdfTitleTextStyle,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
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
