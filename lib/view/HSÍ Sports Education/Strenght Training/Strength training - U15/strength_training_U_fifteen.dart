import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/strength_group_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/custom/strenght_training_custom_sub_screen_appbar.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/strength_group_details_helper.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Strenght%20Training/Strength%20training%20-%20U15/strength_training_U_fifteen_video_list_screen.dart';
import 'package:provider/provider.dart';

// load strenght training  UFifteen details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class StrengthTrainingUFifteen extends StatefulWidget {
  final int id;
  final int sportEducationId;
  final String name;
  final String image;
  final String type;

  const StrengthTrainingUFifteen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.sportEducationId,
  });

  @override
  State<StrengthTrainingUFifteen> createState() =>
      _StrengthTrainingUFifteenState();
}

class _StrengthTrainingUFifteenState extends State<StrengthTrainingUFifteen> {
  final StrengthTrainingGroupService _apiService =
      StrengthTrainingGroupService();
  List<StrengthTrainingGroup> entries = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load data from the StrenghtGroupDetailsHelper class via the web service.
  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          entries = [];
        });
      }

      final data = await _apiService.fetchStrengthTrainingGroups(
        strengthTrainingId: widget.id,
        type: widget.type,
      );

      if (data != null && data.success) {
        if (mounted) {
          setState(() {
            entries = data.entries;
          });
        }
      } else {
        if (mounted) {
          showNetworkErrorDialog(context);
        }
      }
    } catch (e) {
      debugPrint("Error fetching strength training groups: $e");
      if (mounted) {
        showNetworkErrorDialog(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // To handle navigation when the user taps the button
  void _handleItemTap(StrengthTrainingGroup item, int index) {
    setState(() {
      selectedIndex = index;
    });
    _navigateToDetailsScreen(item);
  }

  // To handle navigation when the user taps the button
  void _navigateToDetailsScreen(StrengthTrainingGroup item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => StrengthTrainingUFifteenVideoListScreen(
              id: item.id,
              name: item.heading ?? "",
              image: item.image ?? "",
              sportEducationId: item.sportStrengthTrainingId,
              header: item.subHeading ?? "",
            ),
      ),
    );
  }

  // In this widget, show the tablet UI if isWideScreen is true; otherwise, display the mobile UI.
  Widget _buildItemTile(
    StrengthTrainingGroup item,
    int index,
    bool isWideScreen,
  ) {
    return isWideScreen
        ? LeagueTileTab(
          imageUrl: item.image ?? "",
          name: item.heading ?? "",
          onTap: () => _handleItemTap(item, index),
          isSelected: selectedIndex == index,
        )
        : LeagueTile(
          imageUrl: item.image ?? "",
          name: item.heading ?? "",
          onTap: () => _handleItemTap(item, index),
          isSelected: selectedIndex == index,
        );
  }

  // Custom widget to display a GridView on tablets and a ListView on mobile devices
  Widget _buildListLayout(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;

    if (entries.isEmpty && !isLoading) {
      return const Center(child: Text(""));
    }

    if (isWideScreen) {
      return GridView.custom(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4,
        ),
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          final item = entries[index];
          return buildDividerContainer(
            isSelected: selectedIndex == index,
            child: _buildItemTile(item, index, true),
          );
        }, childCount: entries.length),
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
        itemCount: entries.length + 1,
        itemBuilder: (context, index) {
          if (index == entries.length) {
            return SizedBox();
          }
          final item = entries[index];
          return _buildItemTile(item, index, false);
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
              StrenghtTrainingCustomSubScreenAppbar(
                title: "Styrktaræfingar U15",
                imagePath: strength,
              ),
              Expanded(child: _buildListLayout(context)),
            ],
          ),

          Positioned(
            bottom: 40.h,
            right: 16.w,
            left: 16.w,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(hrIcon, width: 100.w, height: 100.h),
                Text(
                  "Styrktarþjálfun HSÍ er unnin í samstarfi við Háskólann í Reykjavík",
                  textAlign: TextAlign.center,
                  style: userNameTextStyle,
                ),
              ],
            ),
          ),

          if (isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }
}
