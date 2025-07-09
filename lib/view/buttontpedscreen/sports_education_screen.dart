import 'package:flutter/material.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen_Image_asset.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/sports_education_helper.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Core%20Training/core_training_screen.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Instructions/instructions_screen.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Plyometric/plyometric_screen.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Strenght%20Training/strenght_training_screen.dart';
import 'package:hsi/Model/sports_education_model.dart';
// load Sport Education details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class DagatalHsiScreen extends StatefulWidget {
  const DagatalHsiScreen({super.key});

  @override
  State<DagatalHsiScreen> createState() => _DagatalHsiScreenState();
}

class _DagatalHsiScreenState extends State<DagatalHsiScreen> {
  bool isLoading = true;
  int? selectedIndex;
  late ApiService _apiService;
  List<SportEducationItem> sportEducationItems = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    loadData();
  }

  // Load data from the SportEducationHelper class via the web service.

  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final data = await _apiService.fetchSportEducation();
      if (data != null && data.success) {
        sportEducationItems = data.details;
      } else {
        // Handle error case
        showNetworkErrorDialog(context);
      }
    } catch (e) {
      if (mounted) {
        showNetworkErrorDialog(context);
      }
      print("Error fetching sport education data: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Custom widget to display a GridView on tablets and a ListView on mobile devices
  Widget _buildListLayout(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;

    if (isWideScreen) {
      // GridView for tablet/wide screens
      return GridView.custom(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4, // Adjusted ratio for better appearance
        ),
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          final item = sportEducationItems[index];
          return buildDividerContainer(
            child: _buildSportEducationTileTab(item, index),
            isSelected: selectedIndex == index,
          );
        }, childCount: sportEducationItems.length),
      );
    } else {
      // ListView for mobile
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
        itemCount: sportEducationItems.length + 1,
        itemBuilder: (context, index) {
          if (index == sportEducationItems.length) {
            return SizedBox();
          }
          final item = sportEducationItems[index];
          return _buildSportEducationTile(item, index);
        },
      );
    }
  }

  // This widget is displayed on mobile devices
  Widget _buildSportEducationTile(SportEducationItem item, int index) {
    return LeagueTile(
      // Custom widget LeagueTileWidget to display a custom list tile
      imageUrl: item.image,
      name: item.name,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        print('Sport Education item: ${item.id} - ${item.name}');

        if (item.id == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => StrenghtTrainingScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
        if (item.id == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => InstructionsScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
        if (item.id == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => PlyometricScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
        if (item.id == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => CoreTrainingScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
      },
      isSelected: selectedIndex == index,
    );
  }

  // This widget is displayed on Tablet devices
  Widget _buildSportEducationTileTab(SportEducationItem item, int index) {
    return LeagueTileTab(
      // Custom widget LeagueTileWidget to display a custom list tile for tablet
      imageUrl: item.image,
      name: item.name,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        if (item.id == 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => StrenghtTrainingScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
        if (item.id == 2) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => InstructionsScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
        if (item.id == 3) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => PlyometricScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
        if (item.id == 4) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => CoreTrainingScreen(
                    id: item.id,
                    name: item.name,
                    image: item.image,
                  ),
            ),
          );
        }
      },
      isSelected: selectedIndex == index,
    );
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
              CustomAppBarSubImageAsset(
                title: "Íþróttafræðsla HSÍ",
                imagePath: data,
              ),
              Expanded(
                child:
                    isLoading
                        ? Center(child: loadingAnimation)
                        : sportEducationItems.isEmpty
                        ? Center(child: Text(''))
                        : _buildListLayout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
