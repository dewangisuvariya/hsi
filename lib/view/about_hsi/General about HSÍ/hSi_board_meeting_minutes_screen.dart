import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';

// load  board meeting minutes details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HsiBoardMeetingMinutesScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const HsiBoardMeetingMinutesScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<HsiBoardMeetingMinutesScreen> createState() =>
      _HsiBoardMeetingMinutesScreenState();
}

class _HsiBoardMeetingMinutesScreenState
    extends State<HsiBoardMeetingMinutesScreen> {
  bool isLoading = true;
  HeadingDetails? _heading;
  String? errorMessage;
  List<MeetingDetail> meetingDetail = [];

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
          meetingDetail = response.data.meetingDetails;
          _heading = response.data.headingDetails;
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                      top: 16.h,
                                    ),
                                    child: Text(
                                      _heading?.heading ?? " ",
                                      style: titleBarTextStyle,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 20.w,
                                      right: 20.w,
                                    ),
                                    child: Text(
                                      _heading?.subHeading ?? "",
                                      style: subtitleofAboutHsiTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Divider(
                                      color: selectedDividerColor,
                                      thickness: 1,
                                    ),
                                  ),
                                  ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: meetingDetail.length,

                                    itemBuilder: (context, index) {
                                      final item = meetingDetail[index];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          bottom: 20,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Image.network(
                                                  item.image,
                                                  height: 30.h,
                                                  width: 30.w,
                                                ),
                                                SizedBox(width: 12.w),
                                                Text(
                                                  item.meetingDetails,
                                                  style: coachesNameTextStyle,
                                                ),
                                              ],
                                            ),
                                          ],
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
