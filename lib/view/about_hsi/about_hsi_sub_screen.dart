import 'package:flutter/material.dart';
import 'package:hsi/Model/sub_sectiono_about_hsi_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/routing_screen_about_hsi.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/sub_screen_hsi_sections_helper.dart';

class AboutHsiSubScreen extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  const AboutHsiSubScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  State<AboutHsiSubScreen> createState() => _AboutHsiSubScreenState();
}

class _AboutHsiSubScreenState extends State<AboutHsiSubScreen> {
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

  void _navigateToScreen(int? id, BuildContext context, GeneralInfo league) {
    if (id == null) {
      print('League ID is null');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('League ID is null')));
      return;
    }

    final screen = NavigationHelper.getScreenById(id, league);

    if (screen != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No screen defined for ID: $id')));
    }
  }

  @override
  Widget build(BuildContext context) {
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
              if (!isLoading)
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
                    itemCount: generalInfo.length + 1,
                    itemBuilder: (context, index) {
                      if (index == generalInfo.length) {
                        return SizedBox();
                      }
                      final league = generalInfo[index];

                      return LeagueTile(
                        imageUrl: league.image,
                        name: league.name,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          _navigateToScreen(league.id, context, league);
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
