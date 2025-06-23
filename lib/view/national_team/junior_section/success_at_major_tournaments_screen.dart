import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/view/national_team/junior_section/success_at_major_tournaments/U_eighteen_men_screen.dart';
import 'package:hsi/view/national_team/junior_section/success_at_major_tournaments/U_eighteen_women_screen.dart';
import 'package:hsi/view/national_team/junior_section/success_at_major_tournaments/U_twenty_one_men_screen.dart';
import 'package:hsi/view/national_team/junior_section/success_at_major_tournaments/U_twenty_one_women_screen.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../custom/leagueTile_Widget.dart';
import '../../../repository/national_team_category_helper.dart';

// load success at major tournaments details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class SuccessAtMajorTournamentsScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const SuccessAtMajorTournamentsScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  State<SuccessAtMajorTournamentsScreen> createState() =>
      _SuccessAtMajorTournamentsScreenState();
}

class _SuccessAtMajorTournamentsScreenState
    extends State<SuccessAtMajorTournamentsScreen> {
  List<SuccessTournamentJuniorTeam> juniorTeams = [];
  TournamentHeading? headingDetails;
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

      print('API Response: ${response.tournamentHeadingDetails}');

      setState(() {
        juniorTeams = response.successTournamentJuniorTeams;

        if (response.tournamentHeadingDetails != null) {
          headingDetails = TournamentHeading.fromJson(
            response.tournamentHeadingDetails is TournamentHeading
                ? (response.tournamentHeadingDetails as TournamentHeading)
                    .toJson()
                : response.tournamentHeadingDetails as Map<String, dynamic>,
          );
        }

        isLoading = false;
      });

      print('Parsed Heading: ${headingDetails?.heading}');
      print('Parsed Description: ${headingDetails?.description}');
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        showNetworkErrorDialog(context);
      }
      print('Error: $e');
    }
  }

  // create structure of the success at major tournaments screen
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(
                title: widget.teamName,
                imagePath: widget.teamImage,
              ),
              if (headingDetails != null && headingDetails!.heading.isNotEmpty)
                _buildHeading(screenWidth, headingDetails!),
              Expanded(child: _leagueList(screenHeight, screenWidth)),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  // This displays the header paragraph of the screen
  Widget _buildHeading(double screenWidth, TournamentHeading heading) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 16, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading.heading,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E1E1E),
            ),
            //textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            heading.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Color(0xFF1E1E1E),
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.justify,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Divider(thickness: 2, color: Color(0xFFF28E2B)),
          ),
        ],
      ),
    );
  }

  // Display content of the .
  Widget _leagueList(double screenHeight, double screenWidth) {
    return ListView.separated(
      separatorBuilder:
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              color:
                  selectedIndex == index
                      ? selectedDividerColor
                      : unselectedDividerColor,
              thickness: selectedIndex == index ? 3 : 1,
              height: 4,
            ),
          ),
      itemCount: juniorTeams.length + 1,
      itemBuilder: (context, index) {
        if (index == juniorTeams.length) {
          // Return a divider for the last index
          return SizedBox();
        }
        final tournament = juniorTeams[index];

        return LeagueTile(
          // Custom widget LeagueTileWidget to display a custom list tile
          imageUrl: tournament.categoryImage,
          name: tournament.categoryName,

          onTap: () {
            if (tournament.id == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => UTwentyOneWomenScreen(
                        teamId: tournament.id,
                        teamImage: tournament.categoryImage,
                        teamName: tournament.categoryName,
                      ),
                ),
              );
            } else if (tournament.id == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => UEighteenWomenScreen(
                        teamId: tournament.id,
                        teamImage: tournament.categoryImage,
                        teamName: tournament.categoryName,
                      ),
                ),
              );
            } else if (tournament.id == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => UTwentyOneMenScreen(
                        teamId: tournament.id,
                        teamImage: tournament.categoryImage,
                        teamName: tournament.categoryName,
                      ),
                ),
              );
            } else if (tournament.id == 4) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => UEighteenMenScreen(
                        teamId: tournament.id,
                        teamImage: tournament.categoryImage,
                        teamName: tournament.categoryName,
                      ),
                ),
              );
            }
            setState(() {
              selectedIndex = index; // Update the selected index
            });
          },
          isSelected: selectedIndex == index,
        );
      },
    );
  }
}
