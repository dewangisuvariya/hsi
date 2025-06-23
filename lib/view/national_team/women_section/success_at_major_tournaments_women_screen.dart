import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:provider/provider.dart';
import 'package:hsi/const/style_manager.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../Model/tournament_matches_list_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../repository/national_team_category_helper.dart';
import '../../../repository/tournament_matches_list_helper.dart';

// load success at major tournaments women details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class SuccessAtMajorTournamentsWomenScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const SuccessAtMajorTournamentsWomenScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  _SuccessAtMajorTournamentsWomenScreenState createState() =>
      _SuccessAtMajorTournamentsWomenScreenState();
}

class _SuccessAtMajorTournamentsWomenScreenState
    extends State<SuccessAtMajorTournamentsWomenScreen> {
  List<MajorTournament> tournaments = [];
  Map<int, List<TournamentMatch>> tournamentMatches = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Load data from the TournamentMatchesListHelper class via the web service.
  // Load data from the NationalTeamCAtegoryHelper class via the web service.
  Future<void> _fetchData() async {
    try {
      final nationalTeamDetails =
          await NationalTeamDetailsApi.fetchNationalTeamDetails(
            id: widget.teamId,
            type: widget.type,
          );

      if (!nationalTeamDetails.success) {
        throw Exception(nationalTeamDetails.message);
      }

      for (var tournament in nationalTeamDetails.majorTournaments) {
        if (tournament is MajorTournament) {
          final matchesResponse =
              await TournamentMatchesApi.fetchTournamentMatches(
                tournamentId: tournament.id,
              );

          if (matchesResponse.success) {
            setState(() {
              tournamentMatches[tournament.id] = matchesResponse.matches;
            });
          }
        }
      }

      setState(() {
        tournaments =
            nationalTeamDetails.majorTournaments
                .whereType<MajorTournament>()
                .toList();
        isLoading = false;
      });
    } catch (e) {
      return showNetworkErrorDialog(context);
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
      body: Column(
        children: [
          CustomAppBarSubScreen(
            title: widget.teamName,
            imagePath: widget.teamImage,
          ),
          Expanded(
            child:
                isLoading
                    ? Center(child: loadingAnimation)
                    : errorMessage.isNotEmpty
                    ? Center(child: Text('Error: $errorMessage'))
                    : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: borderContainerDecoration,
                          child: Column(
                            children:
                                tournaments.map((tournament) {
                                  final matches =
                                      tournamentMatches[tournament.id] ?? [];

                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          bottom: 10,
                                          right: 16,
                                          left: 16,
                                        ),
                                        child: Text(
                                          tournament.name,
                                          style: tournamentNameTextStyle,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: Divider(
                                          color: Color(0xFFF28E2B),
                                          thickness: 1,
                                        ),
                                      ),

                                      if (matches.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 2.6,
                                                  mainAxisSpacing: 6,
                                                  crossAxisSpacing: 6,
                                                ),
                                            itemCount: matches.length,
                                            itemBuilder: (context, index) {
                                              return _buildMatchContainer(
                                                matches[index],
                                              );
                                            },
                                          ),
                                        )
                                      else
                                        const Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Text(
                                            'No matches available for this tournament',
                                          ),
                                        ),
                                      SizedBox(height: 20.h),
                                      if (tournament.coachName != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                            right: 18,
                                            left: 18,
                                          ),
                                          child: Column(
                                            children: [
                                              Divider(
                                                color:
                                                    containerSuccesAtMajorTorunamentColor,
                                                thickness: 1,
                                              ),
                                              SizedBox(height: 8.h),
                                              Row(
                                                children: [
                                                  if (tournament.coachImage !=
                                                      null)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            right: 8,
                                                          ),
                                                      child: Image.network(
                                                        tournament.coachImage!,
                                                        width: 33.w,
                                                        height: 33.h,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) =>
                                                                errorImageContainer(),
                                                      ),
                                                    ),
                                                  SizedBox(width: 12.w),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Þjálfari:',
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Poppins",
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      SizedBox(height: 4.h),
                                                      Text(
                                                        '${tournament.coachName}',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,

                                                          color: subTitleColor,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Display team name and score in a custom Container widget
  Widget _buildMatchContainer(TournamentMatch match) {
    return Container(
      height: 48.h,
      width: 170.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: containerSuccesAtMajorTorunamentColor),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      match.homeTeamName,
                      textAlign: TextAlign.center,
                      style: textStyleTournaments,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${match.homeTeamScore}",
                      textAlign: TextAlign.center,
                      style: textStyleTournaments,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Container(
                    child:
                        match.image.isNotEmpty
                            ? Image.network(
                              match.image,
                              width: 30.w,
                              height: 30.h,
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomCenter,
                              errorBuilder: (context, error, stackTrace) {
                                return Container();
                              },
                            )
                            : Container(),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      match.awayTeamName,
                      textAlign: TextAlign.center,
                      style: textStyleTournaments,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "${match.awayTeamScore}",
                      textAlign: TextAlign.center,
                      style: textStyleTournaments,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // If loading the image from the web service fails, display this widget
  Widget errorImageContainer() {
    return Container(
      width: 30.w,
      height: 30.h,
      color: Colors.grey[300],
      child: Icon(Icons.error_outline, size: 20),
    );
  }
}
