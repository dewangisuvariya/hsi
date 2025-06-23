import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../repository/partner_club_detail_helper.dart';
import '../../custom/custom_appbar_subscreen.dart';
import '../../provider/BackgroundColorProvider.dart';
import 'package:provider/provider.dart';
import 'club_partner_manager_info_screen.dart';
import 'coach_list_screen.dart';

// load partner club details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class PartnerClubDetail extends StatefulWidget {
  final int? clubId;
  final String? title;
  final String? image;
  const PartnerClubDetail({
    super.key,
    required this.clubId,
    required this.title,
    required this.image,
  });

  @override
  State<PartnerClubDetail> createState() => _PartnerClubDetail();
}

class _PartnerClubDetail extends State<PartnerClubDetail>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> clubPartners = [];
  late int clubId;
  late String title;
  late String image;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    clubId = widget.clubId!;
    title = widget.title!;
    image = widget.image!;
    _loadData();

    _tabController = TabController(length: 2, vsync: this);
  }

  // Load data from the PartnerClubDetailHelper class via the web service.
  Future<void> _loadData() async {
    // Check if widget is still mounted before proceeding
    if (!mounted) return;

    if (mounted) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    // Exit if offline

    setState(() {
      isLoading = true;
    });

    try {
      final data = await fetchClubPartners(clubId);

      // Verify widget is still mounted before updating state
      if (mounted) {
        setState(() {
          clubPartners = data;
          isLoading = false;
          // Clear any previous errors
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }

      // Optionally log the error for debugging
      debugPrint('Error loading club partners: $e');
    } finally {
      // Ensure loading state is always false when done
      if (mounted && isLoading) {
        setState(() {
          isLoading = false;
        });
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
      backgroundColorProvider.updateBackgroundColor(backgroundColor);
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(title: title, imagePath: image),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: unselectedCart,
                  ),
                  height: 40.h,
                  //width: 338.w,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _tabController.animateTo(0),
                          child: Container(
                            height: 30.h,
                            width: 181.w,
                            margin: EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color:
                                  _tabController.index == 0
                                      ? selectedDividerColor
                                      : unselectedCart,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Text(
                                'Stjórnendur',
                                style: TextStyle(
                                  color:
                                      _tabController.index == 0
                                          ? Colors.white
                                          : selectedDividerColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 18.w),
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () => _tabController.animateTo(1),
                          child: Container(
                            height: 30.h,
                            width: 181.w,
                            margin: EdgeInsets.only(left: 4),
                            decoration: BoxDecoration(
                              color:
                                  _tabController.index == 1
                                      ? selectedDividerColor
                                      : unselectedCart,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: Text(
                                'Þjálfaralisti',
                                style: TextStyle(
                                  color:
                                      _tabController.index == 1
                                          ? Colors.white
                                          : selectedDividerColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Add TabBarView here
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ClubPartnerManagerInfoScreen(clubId: clubId),
                    CoachListScreen(clubId: clubId),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
