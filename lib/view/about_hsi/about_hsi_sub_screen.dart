import 'package:flutter/material.dart';
import 'package:hsi/Model/sub_sectiono_about_hsi_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
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
    _loadData();
  }

  // Load data from the web service
  Future<void> _loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final response = await fetchGeneralInfo(widget.id);
      if (mounted) {
        setState(() {
          generalInfo = response.generalInfo;
          clubs = response.clubs;
          nationalTeams = response.nationalTeams;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
      debugPrint("Error fetching data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Handle navigation when user taps a section
  void _handleSectionTap(GeneralInfo league, int index) {
    setState(() {
      selectedIndex = index;
    });
    _navigateToScreen(league.id, context, league);
  }

  void _navigateToScreen(int? id, BuildContext context, GeneralInfo league) {
    if (id == null) {
      debugPrint('League ID is null');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('League ID is null')));
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

  // Build section tile based on screen size
  Widget _buildSectionTile(GeneralInfo league, int index, bool isWideScreen) {
    return isWideScreen
        ? LeagueTileTab(
          imageUrl: league.image,
          name: league.name,
          onTap: () => _handleSectionTap(league, index),
          isSelected: selectedIndex == index,
        )
        : LeagueTile(
          imageUrl: league.image,
          name: league.name,
          onTap: () => _handleSectionTap(league, index),
          isSelected: selectedIndex == index,
        );
  }

  // Build the appropriate layout based on screen size
  Widget _buildListLayout(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;

    if (isWideScreen) {
      return GridView.custom(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4,
        ),
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          final league = generalInfo[index];
          return buildDividerContainer(
            isSelected: selectedIndex == index,
            child: _buildSectionTile(league, index, true),
          );
        }, childCount: generalInfo.length),
      );
    } else {
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
        itemCount: generalInfo.length + 1,
        itemBuilder: (context, index) {
          if (index == generalInfo.length) {
            return const SizedBox();
          }
          final league = generalInfo[index];
          return _buildSectionTile(league, index, false);
        },
      );
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
              if (!isLoading) Expanded(child: _buildListLayout(context)),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }
}
