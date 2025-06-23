import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/fecth_about_hsi_details_helper.dart';
import 'package:provider/provider.dart';
// load Points Of Interests details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class PointsOfInterestsScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;
  const PointsOfInterestsScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<PointsOfInterestsScreen> createState() =>
      _PointsOfInterestsScreenState();
}

class _PointsOfInterestsScreenState extends State<PointsOfInterestsScreen> {
  bool isLoading = true;

  String? errorMessage;
  List<PointOfInterestDetail> pointOfInterestDetail = [];

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
          pointOfInterestDetail = response.data.pointOfInterestDetails;
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
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  decoration: borderContainerDecoration,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16.h,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemCount: pointOfInterestDetail.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 4,
                                                  right: 8,
                                                ),
                                                child: Image.asset(
                                                  "assets/images/Ellipse 7.png",
                                                  height: 8.h,
                                                  width: 8.w,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                child: HtmlWidget(
                                                  pointOfInterestDetail[index]
                                                      .pointDetail,
                                                  textStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFF000000),
                                                    fontFamily: "Poppins",
                                                    height: 1.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
