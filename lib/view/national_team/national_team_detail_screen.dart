import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../Model/national_team_detail_model.dart';
import '../../custom/custom_appbar_subscreen.dart';
import '../../custom/leagueTile_Widget.dart';
import '../../custom/routing_screen_national_team.dart';
import '../../repository/national_team_detail_helper.dart';

// load national team details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class NationalTeamDetailScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String? type;

  const NationalTeamDetailScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    this.type,
  }) : super(key: key);

  @override
  _NationalTeamDetailScreenState createState() =>
      _NationalTeamDetailScreenState();
}

class _NationalTeamDetailScreenState extends State<NationalTeamDetailScreen> {
  List<TeamDetail> nationalTeam = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
  }

  // Load data from the NationalTeamCategoryHelper class via the web service.
  Future<void> _fetchTeamData() async {
    try {
      final response = await ApiHelper.fetchNationalTeamCategory(widget.teamId);
      if (response.success == true &&
          response.teamDetails != null &&
          response.teamDetails!.isNotEmpty) {
        setState(() {
          nationalTeam = response.teamDetails!;
          isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
          showNetworkErrorDialog(context);
        }
      }
    } catch (e) {
      print("$e");
      return showNetworkErrorDialog(context);
    }
  }

  // For navigation to the screen
  void navigateToTeamSection(int id, String name, String image, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TeamSectionWrapper(
              teamId: id,
              teamName: name,
              teamImage: image,
              type: type,
            ),
      ),
    );
    setState(() {
      selectedIndex = nationalTeam.indexWhere((team) => team.id == id);
    });
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

              if (isLoading)
                Expanded(child: Center(child: loadingAnimation))
              else
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
                    itemCount: nationalTeam.length + 1,
                    itemBuilder: (context, index) {
                      if (index == nationalTeam.length) {
                        return SizedBox();
                      }
                      final team = nationalTeam[index];

                      return LeagueTile(
                        // Custom widget LeagueTileWidget to display a custom list tile
                        imageUrl: team.image ?? '',
                        name: team.name ?? 'Unknown',

                        onTap:
                            () => navigateToTeamSection(
                              team.id ?? 0,
                              team.name ?? "No Name",
                              team.image ?? "",
                              team.type ?? "",
                            ),
                        isSelected: selectedIndex == index,
                      );
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
