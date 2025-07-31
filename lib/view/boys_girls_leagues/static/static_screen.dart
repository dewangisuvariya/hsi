import 'package:flutter/material.dart';
import 'package:hsi/Model/boys_girls_child_league_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen_Image_asset.dart';
import 'package:hsi/repository/boys-girls_child-leagues_helper.dart';
import 'package:hsi/view/boys_girls_leagues/boy_girl_league_detail_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// load Static data details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class StaticScreen extends StatefulWidget {
  final int leagueId;
  final int? subLeagueId;
  final String leagueName;

  const StaticScreen({
    super.key,
    required this.leagueId,
    required this.subLeagueId,
    required this.leagueName,
  });

  @override
  State<StaticScreen> createState() => _BoyGirlLeagueScreenState();
}

class _BoyGirlLeagueScreenState extends State<StaticScreen>
    with TickerProviderStateMixin {
  final BoysGirlsLeagueHelper _competitionRepo = BoysGirlsLeagueHelper();

  bool isLoading = true;
  List<LeagueDetail> leagueDetails = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize with length 1 temporarily
    _tabController = TabController(length: 1, vsync: this);
    fetchList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Load data from the BoysGirlsChildLeagueHelper class via the web service.
  Future<void> fetchList() async {
    setState(() => isLoading = true);

    try {
      final idToUse = widget.leagueId;
      final details = await _competitionRepo.fetchLeagueDetails(idToUse);

      if (details.success && details.leagueDetails.isNotEmpty) {
        setState(() {
          leagueDetails = details.leagueDetails;

          _tabController = TabController(
            length: leagueDetails.length,
            vsync: this,
            initialIndex: 0,
          );
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(details.message)));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('League details not found!')));
      print('Error fetching league details: $e');
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubImageAsset(
                imagePath: round,
                title: widget.leagueName,
              ),

              if (!isLoading && leagueDetails.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: unselectedCart,
                  ),
                  height: 40.h,
                  child: TabBar(
                    indicatorWeight: 0.1,
                    labelColor: Colors.white,
                    unselectedLabelColor: selectedDividerColor,
                    dividerColor: unselectedCart,
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: unselectedCart,
                    ),
                    tabs:
                        leagueDetails.asMap().entries.map((entry) {
                          final index = entry.key;
                          final isFirst = index == 0;
                          final isLast = index == leagueDetails.length - 1;
                          final league = entry.value;
                          return Tab(
                            child: Container(
                              height: 30.h,
                              width: 181.w,

                              margin: EdgeInsets.only(
                                left: isFirst ? 10.w : 5.w,
                                right: isLast ? 10.w : 5.w,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    _tabController.index == index
                                        ? selectedDividerColor
                                        : unselectedCart,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Center(
                                child: Text(
                                  league.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isWideScreen ? 16.sp : 14.sp,
                                    fontFamily: "Poppins",
                                    color:
                                        _tabController.index == index
                                            ? Colors.white
                                            : selectedDividerColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),

              if (!isLoading && leagueDetails.isNotEmpty)
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children:
                        leagueDetails.map((league) {
                          return BoyGirlLeagueDetailScreen(
                            leagueId: league.id,
                            leagueName: league.name,
                            leaguesImage: league.image,
                            leagueImage: null,
                          );
                        }).toList(),
                  ),
                ),

              if (!isLoading && leagueDetails.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No leagues available',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          if (isLoading) Positioned.fill(child: loadingAnimation),
        ],
      ),
    );
  }
}
