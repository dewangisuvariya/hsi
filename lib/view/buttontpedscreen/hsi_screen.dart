import 'package:flutter/material.dart';
import 'package:hsi/Model/hsi_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/hsi_api_helper.dart';
import 'package:hsi/view/about_hsi/about_hsi_sub_screen.dart';
import 'package:hsi/view/about_hsi/national_team.dart';
import 'package:hsi/view/about_hsi/partner_sports_club_list.dart';
import 'package:provider/provider.dart';

// load About Hsi  details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class AboutHsiScreen extends StatefulWidget {
  const AboutHsiScreen({super.key});

  @override
  State<AboutHsiScreen> createState() => _AboutHsiScreenState();
}

class _AboutHsiScreenState extends State<AboutHsiScreen> {
  final ApiHelper _apiHelper = ApiHelper.instance;
  List<AboutHsiSection> sections = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from the HsiApiHelper class via the web service.
  Future<void> _loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      sections = await _apiHelper.fetchAboutHsiSections();
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

  // To handle navigation when the user taps the button
  void _handleSectionTap(AboutHsiSection section, int index) {
    setState(() {
      selectedIndex = index;
    });

    if (section.id == 9) {
      _navigateTo(
        AoildarfelogHsi(
          id: section.id,
          name: section.sectionName,
          image: section.image,
        ),
      );
    } else if (section.id == 10) {
      _navigateTo(
        LandslioScreen(
          id: section.id,
          name: section.sectionName,
          image: section.image,
        ),
      );
    } else if ([1, 2, 4, 5].contains(section.id)) {
      _navigateTo(
        AboutHsiSubScreen(
          id: section.id,
          name: section.sectionName,
          image: section.image,
        ),
      );
    }
  }

  // Custom navigation method
  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // In this widget, show the tablet UI if isWideScreen is true; otherwise, display the mobile UI.
  Widget _buildSectionTile(
    AboutHsiSection section,
    int index,
    bool isWideScreen,
  ) {
    return isWideScreen
        ? LeagueTileTab(
          // Custom widget LeagueTileWidget to display a custom list tile for tablet
          imageUrl: section.image,
          name: section.sectionName,
          onTap: () => _handleSectionTap(section, index),
          isSelected: selectedIndex == index,
        )
        : LeagueTile(
          // Custom widget LeagueTileWidget to display a custom list tile
          imageUrl: section.image,
          name: section.sectionName,
          onTap: () => _handleSectionTap(section, index),
          isSelected: selectedIndex == index,
        );
  }

  // Custom widget to display a GridView on tablets and a ListView on mobile devices
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
          final section = sections[index];
          return buildDividerContainer(
            isSelected: selectedIndex == index,
            child: _buildSectionTile(section, index, true),
          );
        }, childCount: sections.length),
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
        itemCount: sections.length + 1,
        itemBuilder: (context, index) {
          if (index == sections.length) {
            return SizedBox();
          }
          final section = sections[index];
          return _buildSectionTile(section, index, false);
        },
      );
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
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: "HSÍ", imagePath: hsiHeader),
              Expanded(child: _buildListLayout(context)),
            ],
          ),
          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }
}
