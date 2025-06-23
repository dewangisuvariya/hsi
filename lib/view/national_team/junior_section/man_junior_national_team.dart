import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../../Model/national_team_category_model.dart'
    as national_team_category_model;
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../custom/leagueTile_Widget.dart';
import '../../../repository/national_team_category_helper.dart';
import 'men_team/coaches_junior_men_national_team.dart';
import 'men_team/junior_men_national_team_week_screen.dart';
// load man junior national team details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class ManJuniorNationalTeam extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const ManJuniorNationalTeam({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  State<ManJuniorNationalTeam> createState() => _ManJuniorNationalTeamState();
}

class _ManJuniorNationalTeamState extends State<ManJuniorNationalTeam> {
  List<national_team_category_model.JuniorTeam> juniorTeams = [];
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

      debugPrint('API Response: ${response.juniorTeams}');

      if (response.juniorTeams.isNotEmpty) {
        debugPrint('First team data: ${response.juniorTeams.first}');
      }

      setState(() {
        juniorTeams = response.juniorTeams;
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

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
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
                child: ListView.separated(
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
                      imageUrl: tournament.junior_image,
                      name: tournament.junior_name,
                      onTap: () {
                        if (tournament.id == 3) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => JuniorTeamsScreen(
                                    teamId: tournament.id,
                                    teamImage: tournament.junior_image,
                                    teamName: tournament.junior_name,
                                  ),
                            ),
                          );
                        } else if (tournament.id == 1) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => CoachesJuniorMenNationalTeam(
                                    teamId: tournament.id,
                                    teamImage: tournament.junior_image,
                                    teamName: tournament.junior_name,
                                  ),
                            ),
                          );
                        }
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      isSelected: selectedIndex == index,
                    );
                  },
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
