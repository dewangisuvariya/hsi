import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../repository/national_team_category_helper.dart';
import 'package:skeletonizer/skeletonizer.dart';

// load about men details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class AboutTeamScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const AboutTeamScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  _AboutTeamScreenState createState() => _AboutTeamScreenState();
}

class _AboutTeamScreenState extends State<AboutTeamScreen> {
  NationalTeamDetailsResponse? _teamDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchTeamDetails();
  }

  // Load data from the NationalTeamCategoryHelper class via the web service.
  Future<void> _fetchTeamDetails() async {
    try {
      final response = await NationalTeamDetailsApi.fetchNationalTeamDetails(
        id: widget.teamId,
        type: widget.type,
      );

      if (mounted) {
        setState(() {
          if (response.success && response.infoSections.isNotEmpty) {
            _teamDetails = response;
          } else {
            errorMessage = 'No data available.';
          }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = MediaQuery.of(context).size.width > 600;

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
              Expanded(
                child:
                    isLoading
                        ? Center(
                          child: LoadingAnimationWidget.newtonCradle(
                            color: Colors.blue,
                            size: screenWidth * 0.30,
                          ),
                        )
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
                        : _buildContent(screenWidth, isLargeScreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom widget for the main Container of this screen
  Widget _buildContent(double screenWidth, bool isLargeScreen) {
    final infoSection = _teamDetails!.infoSections.first;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.8, color: const Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTeamInfoCard(infoSection),
                    if (isLargeScreen) SizedBox(height: 22.h),
                    _buildSocialMediaRow(infoSection, isLargeScreen),
                    SizedBox(height: 10.h),
                    _buildDetailsSection(infoSection, isLargeScreen),
                    SizedBox(height: 10.h),
                    _buildContactSection(isLargeScreen),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Displays an image loaded from the web service
  Widget _buildTeamInfoCard(InfoSection infoSection) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.8, color: const Color(0xFFD9D9D9)),
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          infoSection.image.isNotEmpty == true
              ? Skeletonizer(
                enabled: isLoading,
                child: Image.network(
                  infoSection.image,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        width: double.infinity,
                        height: 200.h,
                        color: Colors.transparent,
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.black,
                        child: Image.asset(
                          errorImage,
                          fit: BoxFit.contain,
                          color: Colors.white,
                        ),
                      ),
                ),
              )
              : Container(
                color: Colors.black,
                child: Image.asset(
                  errorImage,
                  fit: BoxFit.contain,
                  color: Colors.white,
                ),
              ),
    );
  }

  // This displays the paragraph about women on the screen
  Widget _buildDetailsSection(InfoSection infoSection, bool isLargeScreen) {
    return Column(
      children: [
        HtmlWidget(
          infoSection.details,
          textStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: "Poppins",
            color: Colors.black,
            fontSize: isLargeScreen ? 18.sp : 14.sp,
          ),
          customWidgetBuilder: (element) {
            if (element.text == 'hér') {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Baseline(
                  baseline: 14.0 * 1.2, // Match your text line height
                  baselineType: TextBaseline.alphabetic,
                  child: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(
                        'https://www.hsi.is/landslid/a-landslid-karla/leikir-a-landslids-karla/',
                      );
                      if (!await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      )) {
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.inAppBrowserView,
                        )) {
                          throw 'Could not launch $url';
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedDividerColor,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      "hér",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            isLargeScreen
                                ? 18.sp
                                : 14.sp, // Match your text size
                      ),
                    ),
                  ),
                ),
              );
            }
            return null;
          },
          onTapUrl: (url) async {
            try {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
                return true;
              }
            } catch (e) {
              print('Error launching URL: $e');
            }
            return false;
          },
        ),
      ],
    );
  }

  // This displays the row of social media icon buttons
  Widget _buildSocialMediaRow(InfoSection infoSection, bool isLargeScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSocialIcon(instagram, infoSection.instagramLink, isLargeScreen),
          SizedBox(width: 16.w),
          _buildSocialIcon(facebook, infoSection.facebookLink, isLargeScreen),
          SizedBox(width: 16.w),
          _buildSocialIcon(twitter, infoSection.twitterLink, isLargeScreen),
        ],
      ),
    );
  }

  // This displays the icon button UI
  Widget _buildSocialIcon(String iconPath, String? url, bool isLargeScreen) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Image.asset(
        iconPath,
        height: isLargeScreen ? 60.h : 40.h,
        width: isLargeScreen ? 60.w : 40.w,
      ),
    );
  }

  // display social media Section
  Widget _buildContactSection(bool isLargeScreen) {
    return contactSection(isLargeScreen);
  }

  Widget contactSection(bool isLargeScreen) {
    if (isLargeScreen) {
      return contactSectionTablet(isLargeScreen);
    } else {
      return contactSectionMobile(isLargeScreen);
    }
  }

  Column contactSectionMobile(bool isLargeScreen) {
    return Column(
      children: [
        _buildContactTile("strakarnirokkar", snapchat, isLargeScreen),
        SizedBox(height: 12.h),
        _buildContactTile(
          "Strákarnir okkar á Facebook",
          facebook1,
          isLargeScreen,
        ),
      ],
    );
  }

  Row contactSectionTablet(bool isLargeScreen) {
    return Row(
      children: [
        Expanded(
          child: _buildContactTile("strakarnirokkar", snapchat, isLargeScreen),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildContactTile(
            "Strákarnir okkar á Facebook",
            facebook1,
            isLargeScreen,
          ),
        ),
      ],
    );
  }

  // This displays social media Section UI
  Widget _buildContactTile(String text, String iconPath, bool isLargeScreen) {
    return Container(
      height: isLargeScreen ? 60.h : 50.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (isLargeScreen) SizedBox(width: 8.w) else SizedBox(width: 16.w),
            Image.asset(
              iconPath,
              height: isLargeScreen ? 35.h : 30.h,
              width: isLargeScreen ? 35.w : 30.w,
            ),
            SizedBox(width: 12.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Color(0xFF757575),
                fontFamily: "Poppins",
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // When the user presses the icon button, open the corresponding social media link
  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print('Error launching URL: $e');
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
