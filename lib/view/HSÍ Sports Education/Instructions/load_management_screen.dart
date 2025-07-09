import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hsi/Model/sport_instructions_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/sport_instructions_details_helper.dart';

// load load management details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class LoadManagementScreen extends StatefulWidget {
  final int id;
  final int sportEducationId;
  final String name;
  final String image;
  final String type;

  const LoadManagementScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.sportEducationId,
  });

  @override
  State<LoadManagementScreen> createState() => _LoadManagementScreenState();
}

class _LoadManagementScreenState extends State<LoadManagementScreen> {
  SportInstructionsResponse? _data;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInstructionDetails();
  }

  // Load data from the SportInstructionDetailsHelper class via the web service.
  Future<void> _fetchInstructionDetails() async {
    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      final response =
          await SportInstructionsApiHelper.fetchSportInstructionDetails(
            instructionId: widget.id,
            type: widget.type,
          );

      if (mounted) {
        if (response != null && response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          setState(() {
            _data = SportInstructionsResponse.fromJson(jsonData);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load instructions. Please try again.';
          });
          showNetworkErrorDialog(context);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'An error occurred: $e';
        });
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
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Display instruction details
                                    if (_data!.details!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          ..._data!.details!
                                              .map(
                                                (detail) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 8.0,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Display heading
                                                      HtmlWidget(
                                                        detail.heading,
                                                        textStyle:
                                                            titleBarTextStyle,
                                                      ),

                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 12,
                                                            ),
                                                        child: Divider(
                                                          color:
                                                              selectedDividerColor,
                                                          thickness: 1,
                                                        ),
                                                      ),

                                                      HtmlWidget(
                                                        detail.details,

                                                        textStyle: TextStyle(
                                                          fontSize: 14.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.h),
                                                    ],
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ],
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
