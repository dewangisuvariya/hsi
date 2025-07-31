import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../../Model/coach_model.dart';
import '../../../repository/coach_helper.dart';
// load coach details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class CoachListScreen extends StatefulWidget {
  final int clubId;

  const CoachListScreen({super.key, required this.clubId});

  @override
  State<CoachListScreen> createState() => _CoachListScreenState();
}

class _CoachListScreenState extends State<CoachListScreen> {
  List<Coach> coaches = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from the CoachHelper class via the web service.
  Future<void> _loadData() async {
    try {
      final fetchedCoaches = await CoachHelper.fetchCoachList(widget.clubId);
      setState(() {
        coaches = fetchedCoaches;
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
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: loadingAnimation);
    }
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(""));
    }
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    return ListView.builder(
      itemCount: coaches.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Container(
              height: isLargeScreen ? 70.h : 56.h,
              decoration: BoxDecoration(
                color: appBarColor,
                border: Border(
                  bottom: BorderSide(color: backgroundColorContainer, width: 4),
                ),
              ),
              child: Row(
                children: [
                  Expanded(flex: isLargeScreen ? 3 : 2, child: Container()),
                  Expanded(
                    flex: isLargeScreen ? 4 : 3,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment:
                          isLargeScreen
                              ? Alignment.centerLeft
                              : Alignment.center,
                      child: Text(
                        "Nafn:",
                        style:
                            isLargeScreen
                                ? partnerClubCoachTitleTextStyle.copyWith(
                                  fontSize: 15.sp,
                                )
                                : partnerClubCoachTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isLargeScreen ? 4 : 3,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment:
                          isLargeScreen
                              ? Alignment.centerLeft
                              : Alignment.center,
                      child: Text(
                        "Netfang:",
                        style:
                            isLargeScreen
                                ? partnerClubCoachTitleTextStyle.copyWith(
                                  fontSize: 15.sp,
                                )
                                : partnerClubCoachTitleTextStyle,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: isLargeScreen ? 3 : 2,
                    child: Container(
                      margin: const EdgeInsets.only(left: 4, right: 4),
                      alignment: Alignment.center,
                      child: Text(
                        "Sími:",
                        style:
                            isLargeScreen
                                ? partnerClubCoachTitleTextStyle.copyWith(
                                  fontSize: 15.sp,
                                )
                                : partnerClubCoachTitleTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        final coach = coaches[index - 1];
        return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Container(
            height: 56.h,
            color: index.isEven ? selectLeagueTileColor : Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: isLargeScreen ? 3 : 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 7, right: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      coach.league,
                      style:
                          isLargeScreen
                              ? partnerClubCoachSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                              )
                              : partnerClubCoachSubtitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: isLargeScreen ? 4 : 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      coach.name,
                      style:
                          isLargeScreen
                              ? partnerClubCoachSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                              )
                              : partnerClubCoachSubtitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: isLargeScreen ? 4 : 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      coach.email,
                      style:
                          isLargeScreen
                              ? partnerClubCoachSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                              )
                              : partnerClubCoachSubtitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: isLargeScreen ? 3 : 2,
                  child: Container(
                    margin: const EdgeInsets.only(left: 4, right: 4),
                    alignment: Alignment.center,
                    child: Text(
                      coach.phone,
                      style:
                          isLargeScreen
                              ? partnerClubCoachSubtitleTextStyle.copyWith(
                                fontSize: 14.sp,
                              )
                              : partnerClubCoachSubtitleTextStyle,
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
