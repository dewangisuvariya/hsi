import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';

// load history of handball in Iceland details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class TheHistoryOfHandballScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const TheHistoryOfHandballScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<TheHistoryOfHandballScreen> createState() =>
      _TheHistoryOfHandballScreenState();
}

class _TheHistoryOfHandballScreenState
    extends State<TheHistoryOfHandballScreen> {
  bool isLoading = true;
  AboutHsiData? _data;
  String? errorMessage;

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
          _data = response.data;
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
  } // create structure of the screen

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
                            padding: const EdgeInsets.all(16),
                            child: Container(
                              decoration: borderContainerDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _data!.headingDetails.heading,
                                      style:
                                          isWideScreen
                                              ? titleBarTextStyle.copyWith(
                                                fontSize: 19.sp,
                                              )
                                              : titleBarTextStyle,
                                    ),
                                    Divider(
                                      color: selectedDividerColor,
                                      thickness: 1,
                                    ),
                                    if (_data!.headingDetails.subHeading !=
                                        null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          _data!.headingDetails.subHeading!,
                                          style:
                                              isWideScreen
                                                  ? descriptionTextStyle
                                                      .copyWith(fontSize: 17.sp)
                                                  : descriptionTextStyle,
                                        ),
                                      ),
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
