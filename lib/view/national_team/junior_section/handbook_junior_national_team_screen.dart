import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../repository/national_team_category_helper.dart';
import 'package:provider/provider.dart';

// load  handbook junior national team details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class HandbookJuniorNationalTeamScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const HandbookJuniorNationalTeamScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  State<HandbookJuniorNationalTeamScreen> createState() =>
      _HandbookJuniorNationalTeamScreenTeamState();
}

class _HandbookJuniorNationalTeamScreenTeamState
    extends State<HandbookJuniorNationalTeamScreen> {
  List<JuniorTeamHandbook> handbooks = [];
  bool isLoading = true;
  String errorMessage = '';
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Load data from the NationalTeamCategoryHelper class via the web service.
  Future<void> _fetchData() async {
    try {
      final response = await NationalTeamDetailsApi.fetchNationalTeamDetails(
        id: widget.teamId,
        type: widget.type,
      );

      debugPrint('API Response: ${response.juniorTeamHandbook}');

      if (response.juniorTeams.isNotEmpty) {
        debugPrint('First team data: ${response.juniorTeamHandbook.first}');
      }

      setState(() {
        handbooks = response.juniorTeamHandbook;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        showNetworkErrorDialog(context);
      }
      debugPrint('Error: $e');
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
      listen: true,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backgroundColorProvider.updateBackgroundColor(backgroundColor);
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(
                title: widget.teamName,
                imagePath: widget.teamImage,
              ),
              Expanded(child: _buildContent()),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  // Displays the file list
  Widget _buildContent() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: handbooks.length,
      itemBuilder: (context, index) {
        final handbook = handbooks[index];
        return Container(
          decoration: borderContainerDecoration,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(handbook.description, style: pdfButtonTextStyle),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(color: selectedDividerColor, thickness: 1),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    _launchPdf(handbook.handbookFile);
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
                    fixedSize: Size(323.w, 54.h),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(pdf, height: 30.h, width: 30.w),
                            SizedBox(width: 10.w),
                            Text(
                              "Handbók yngri landsliða",
                              style: pdfTitleTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
