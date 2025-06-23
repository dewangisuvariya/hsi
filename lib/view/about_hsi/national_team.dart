import 'package:flutter/material.dart';
import 'package:hsi/Model/sub_sectiono_about_hsi_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/sub_screen_hsi_sections_helper.dart';
import 'package:provider/provider.dart';
import '../../custom/custom_appbar_subscreen.dart';
import '../../custom/leagueTile_Widget.dart';
import '../../provider/BackgroundColorProvider.dart';
import '../national_team/national_team_detail_screen.dart';
// load  National team details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class LandslioScreen extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  const LandslioScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  State<LandslioScreen> createState() => _LandslioScreenState();
}

class _LandslioScreenState extends State<LandslioScreen> {
  List<GeneralInfo> generalInfo = [];
  List<Club> clubs = [];
  List<NationalTeam> nationalTeams = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Load data from the SubScreenHaiSectionsHelper class via the web service
  Future<void> fetchData() async {
    try {
      final response = await fetchGeneralInfo(widget.id);
      setState(() {
        generalInfo = response.generalInfo;
        clubs = response.clubs;
        nationalTeams = response.nationalTeams;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
      print("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // create structure of the screen
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
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
              ),
              Expanded(
                child: ListView.separated(
                  separatorBuilder:
                      // (context, index) =>
                      //     buildAnimatedDivider(index, selectedIndex),
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
                  itemCount: nationalTeams.length + 1,
                  itemBuilder: (context, index) {
                    if (index == nationalTeams.length) {
                      return SizedBox();
                    }
                    final league = nationalTeams[index];

                    return LeagueTile(
                      // Custom widget LeagueTileWidget to display a custom list tile
                      imageUrl: league.image,
                      name: league.name,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });

                        print('League object: ${league.toJson()}');
                        print(
                          'League ID to pass: ${league.id} (type: ${league.id.runtimeType})',
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => NationalTeamDetailScreen(
                                  teamId: league.id,
                                  teamName: league.name,
                                  teamImage: league.image,
                                ),
                          ),
                        );
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
