import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';

// load staff details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HsiStaffScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const HsiStaffScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<HsiStaffScreen> createState() => _HsiStaffScreenState();
}

class _HsiStaffScreenState extends State<HsiStaffScreen> {
  bool isLoading = true;
  HeadingDetails? _heading;
  String? errorMessage;
  List<StaffDetail> staffDetail = [];

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
          staffDetail = response.data.staffDetails;
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
    final isWideScreen = MediaQuery.of(context).size.width > 600;
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
                                      _heading?.heading ??
                                          "Helstu upplýsingar:",
                                      style:
                                          isWideScreen
                                              ? titleBarTextStyle.copyWith(
                                                fontSize: 17.sp,
                                              )
                                              : titleBarTextStyle,
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
                                  if (isWideScreen)
                                    displayTabletCustomUI(context)
                                  else
                                    displayMobileCustomUI(),
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

  ListView displayMobileCustomUI() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: staffDetail.length,
      separatorBuilder:
          (context, index) => Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(),
          ),
      itemBuilder: (context, index) {
        final item = staffDetail[index];

        return Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.memberName, style: coachesNameTextStyle),
              Text(item.memberDetails, style: durationTextStyle),
              SizedBox(height: 12.h),
              if (item.memberPhone.isNotEmpty)
                Row(
                  children: [
                    Image.network(item.phoneImage, height: 30.h, width: 30.w),
                    SizedBox(width: 16.w),
                    Text(
                      "Vinnusími: ${item.memberPhone}",
                      style: subtitleOfCoachOrTeamTextStyle,
                    ),
                  ],
                ),
              SizedBox(height: 10.h),
              if (item.memberEmail.isNotEmpty)
                Row(
                  children: [
                    Image.network(item.emailImage, height: 30.h, width: 30.w),
                    SizedBox(width: 16.w),
                    Text(
                      "E-mail: ${item.memberEmail}",
                      style: subtitleOfCoachOrTeamTextStyle,
                    ),
                  ],
                ),
              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }

  Padding displayTabletCustomUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Wrap(
        spacing: MediaQuery.of(context).size.width / 8.5,
        // Horizontal space between items
        runSpacing: 20.0, // Vertical space between rows
        children:
            staffDetail.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLastItem = index == staffDetail.length - 1;
              return SizedBox(
                width:
                    MediaQuery.of(context).size.width /
                    2.5, // Fixed width for each item
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.memberName,
                        style: coachesNameTextStyle.copyWith(fontSize: 18.sp),
                      ),
                      Text(
                        item.memberDetails,
                        style: durationTextStyle.copyWith(fontSize: 16.sp),
                      ),
                      SizedBox(height: 12.h),
                      if (item.memberPhone.isNotEmpty)
                        Row(
                          children: [
                            Image.network(
                              item.phoneImage,
                              height: 33.h,
                              width: 33.w,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "Vinnusími: ${item.memberPhone}",
                              style: subtitleOfCoachOrTeamTextStyle.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 10.h),
                      if (item.memberEmail.isNotEmpty)
                        Row(
                          children: [
                            Image.network(
                              item.emailImage,
                              height: 33.h,
                              width: 33.w,
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              "E-mail: ${item.memberEmail}",
                              style: subtitleOfCoachOrTeamTextStyle.copyWith(
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 12.h),

                      if (!isLastItem) Divider(),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
