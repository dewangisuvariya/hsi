import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/fecth_about_hsi_details_helper.dart';
import 'package:provider/provider.dart';

// load Privacy Policy details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class PrivacyPolicyFourScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const PrivacyPolicyFourScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<PrivacyPolicyFourScreen> createState() =>
      _PrivacyPolicyFourScreenState();
}

class _PrivacyPolicyFourScreenState extends State<PrivacyPolicyFourScreen> {
  bool isLoading = true;
  String _errorMessage = '';
  List<PolicyDetail> policyDetails = [];
  final Map<int, bool> _expandedSections = {};

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
          policyDetails = response.data.privacyPolicyDetails;
          for (var detail in policyDetails) {
            _expandedSections[detail.id] = false;
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load data: $e';
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
    }
  }

  // Toggle the container: open it when the user selects it, and close it if it's already open and selected again.
  void _toggleSectionExpansion(int sectionId) {
    setState(() {
      _expandedSections[sectionId] = !(_expandedSections[sectionId] ?? false);
    });
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backgroundColorProvider.updateBackgroundColor(backgroundColor);
    });

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
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

  // Displaying the privacy policy in a custom widget with toggle functionality
  Widget _buildContent() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "",
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (policyDetails.isEmpty)
            const Center(
              child: Padding(padding: EdgeInsets.all(16.0), child: Text('')),
            )
          else
            Column(
              children: List.generate(policyDetails.length, (index) {
                final policy = policyDetails[index];
                final isExpanded = _expandedSections[policy.id] ?? false;
                final isFirst = index == 0;
                final isLast = index == policyDetails.length - 1;

                return Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide.none,
                      vertical: BorderSide(color: unselectedCart, width: 1.0),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: isFirst ? Radius.circular(8.r) : Radius.zero,
                      topRight: isFirst ? Radius.circular(8.r) : Radius.zero,
                      bottomLeft: isLast ? Radius.circular(8.r) : Radius.zero,
                      bottomRight: isLast ? Radius.circular(8.r) : Radius.zero,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  isFirst ? Radius.circular(8.r) : Radius.zero,
                              topRight:
                                  isFirst ? Radius.circular(8.r) : Radius.zero,
                              bottomLeft:
                                  isLast ? Radius.circular(8.r) : Radius.zero,
                              bottomRight:
                                  isLast ? Radius.circular(8.r) : Radius.zero,
                            ),
                            color: unselectedCart,
                          ),
                          child: ListTile(
                            title: Text(
                              policy.policyTitle,
                              style: nameOfTournamentTextStyle,
                            ),
                            trailing: GestureDetector(
                              onTap: () => _toggleSectionExpansion(policy.id),
                              child: SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: Image.asset(
                                  isExpanded ? rightUp : arrowDown,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isExpanded)
                        Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: unselectedCart,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 16.0,
                              ),
                              child: Text(
                                policy.policyDescription,
                                style: TextStyle(fontSize: 14.sp, height: 1.5),
                              ),
                            ),
                          ),
                        ),
                      Divider(height: 1, color: unselectedCart),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}
