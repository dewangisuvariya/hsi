import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/view/man_women_leagues/man_women_leagues_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../provider/BackgroundColorProvider.dart';
import '../../repository/men_women_leagues_helper.dart';

// load man women leagues details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ManWomenLeagues extends StatefulWidget {
  const ManWomenLeagues({super.key});

  @override
  State<ManWomenLeagues> createState() => _ManWomenLeaguesState();
}

class _ManWomenLeaguesState extends State<ManWomenLeagues>
    with TickerProviderStateMixin {
  final MenWomenLeagues _repository = MenWomenLeagues();
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 0, vsync: this);
    _tabController.addListener(_handleTabSelection);
    fetchLeagueData();
  }

  // For handling tab selection
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  // Load data from the MenWomenLeaguesHelper class via the web service.

  Future<void> fetchLeagueData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      await _repository.mwlData();

      if (mounted) {
        setState(() {
          isLoading = false;
          _tabController.dispose();
          _tabController = TabController(
            length: _repository.getdata.length,
            vsync: this,
          );
          _tabController.addListener(_handleTabSelection);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
      print('Error fetching league data: $e');
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
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
              CustomAppBar(title: "Meistaraflokkur", imagePath: menWomen2),

              if (!isLoading)
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
                    controller: _tabController,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: unselectedCart,
                    ),
                    indicatorWeight: 0.1,
                    labelColor: Colors.white,
                    unselectedLabelColor: selectedDividerColor,
                    dividerColor: unselectedCart,
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    tabs:
                        _repository.getdata.asMap().entries.map((entry) {
                          final index = entry.key;
                          final isFirst = index == 0;
                          final isLast =
                              index == _repository.getdata.length - 1;
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
                                  textAlign: TextAlign.center,
                                  league.leaguesName ?? 'No Name',
                                  style: TextStyle(
                                    color:
                                        _tabController.index == index
                                            ? Colors.white
                                            : selectedDividerColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              if (!isLoading)
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children:
                        _repository.getdata.map((league) {
                          return const ManWomenLeaguesDetailScreen();
                        }).toList(),
                  ),
                ),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }
}
