import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hsi/Model/sport_instructions_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/sport_instructions_details_helper.dart';

// load important points details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ImportantPointsScreen extends StatefulWidget {
  final int id;
  final int sportEducationId;
  final String name;
  final String image;
  final String type;

  const ImportantPointsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.sportEducationId,
  });

  @override
  State<ImportantPointsScreen> createState() => _ImportantPointsScreenState();
}

class _ImportantPointsScreenState extends State<ImportantPointsScreen> {
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
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
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
                                    if (_data!.importantPoints!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          ..._data!.importantPoints!
                                              .map(
                                                (point) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 8.0,
                                                      ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Image.asset(
                                                        ellipse,
                                                        width:
                                                            isLargeScreen
                                                                ? 10.w
                                                                : 8.w,
                                                        height:
                                                            isLargeScreen
                                                                ? 17.h
                                                                : 15.h,
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Expanded(
                                                        child: HtmlWidget(
                                                          point.point,
                                                          textStyle: TextStyle(
                                                            fontSize:
                                                                isLargeScreen
                                                                    ? 18.sp
                                                                    : 14.sp,
                                                            color: Color(
                                                              0xFF000000,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                        ),
                                                      ),
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
