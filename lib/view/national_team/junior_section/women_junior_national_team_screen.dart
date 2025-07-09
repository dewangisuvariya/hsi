import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/view/national_team/junior_section/women_team/coaches_junior_women_national_team_screen.dart';
import 'package:hsi/view/national_team/junior_section/women_team/junior_women_national_team_week_screen.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../custom/leagueTile_Widget.dart';
import '../../../repository/national_team_category_helper.dart';

// load woman junior national team details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class WomenJuniorNationalTeamScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const WomenJuniorNationalTeamScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  State<WomenJuniorNationalTeamScreen> createState() =>
      _WomenJuniorNationalTeamScreenState();
}

class _WomenJuniorNationalTeamScreenState
    extends State<WomenJuniorNationalTeamScreen> {
  List<JuniorTeam> juniorTeams = [];
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
              Expanded(child: _buildContent(screenHeight, screenWidth)),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  // Display content of the Women’s Junior National Team screen.
  Widget _buildContent(double screenHeight, double screenWidth) {
    if (errorMessage.isNotEmpty) {
      return Center(child: Text('', style: TextStyle(color: Colors.red)));
    }

    if (juniorTeams.isEmpty && !isLoading) {
      return Center(
        child: Text(
          'No junior teams available',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

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
          imageUrl: tournament.junior_image,
          name: tournament.junior_name,
          onTap: () {
            if (tournament.id == 2) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => CoachesJuniorWomenNationalTeamScreen(
                        teamId: tournament.id,
                        teamImage: tournament.junior_image,
                        teamName: tournament.junior_name,
                      ),
                ),
              );
            } else if (tournament.id == 4) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) => JuniorWomenNationalTeamWeekScreen(
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
    );
  }
}
