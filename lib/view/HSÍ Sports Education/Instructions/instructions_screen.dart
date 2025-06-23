import 'package:flutter/material.dart';
import 'package:hsi/Model/sport_education_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/sport_education_details_helper.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Instructions/active_rest_screen.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Instructions/important_points_screen.dart';
import 'package:hsi/view/HS%C3%8D%20Sports%20Education/Instructions/load_management_screen.dart';
import 'package:provider/provider.dart';

// load instructions details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class InstructionsScreen extends StatefulWidget {
  final int id;
  final String name;
  final String image;

  const InstructionsScreen({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  final ApiService _apiService = ApiService();
  List<SportEducationDetailItem> details = [];
  bool isLoading = true;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load data from the SportEducationDetailsHelper class via the web service.
  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
          details = []; // Clear previous data
        });
      }

      final data = await _apiService.fetchSportEducationDetails(
        sportEducationId: widget.id,
        type: "instruction",
      );

      if (data != null && data.success) {
        if (mounted) {
          setState(() {
            details = data.details;
          });
        }
      } else {
        // Show empty state or message
        if (mounted) {
          showNetworkErrorDialog(context);
        }
      }
    } catch (e) {
      debugPrint("Error fetching sport education details: $e");
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
  void _handleItemTap(SportEducationDetailItem item, int index) {
    setState(() {
      selectedIndex = index;
    });
    _navigateToDetailsScreen(item);
  }

  // To handle navigation when the user taps the button
  void _navigateToDetailsScreen(SportEducationDetailItem item) {
    if (item.id == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ImportantPointsScreen(
                id: item.id,
                name: item.instructionDetail ?? "",
                image: item.instructionImage ?? "",
                sportEducationId: item.sportEducationId,
                type: item.type,
              ),
        ),
      );
    }
    if (item.id == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => LoadManagementScreen(
                id: item.id,
                name: item.instructionDetail ?? "",
                image: item.instructionImage ?? "",
                sportEducationId: item.sportEducationId,
                type: item.type,
              ),
        ),
      );
    }
    if (item.id == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => ActiveRestScreen(
                id: item.id,
                name: item.instructionDetail ?? "",
                image: item.instructionImage ?? "",
                sportEducationId: item.sportEducationId,
                type: item.type,
              ),
        ),
      );
    }
  }

  // In this widget, show the tablet UI if isWideScreen is true; otherwise, display the mobile UI.
  Widget _buildItemTile(
    SportEducationDetailItem item,
    int index,
    bool isWideScreen,
  ) {
    return isWideScreen
        ? LeagueTileTab(
          imageUrl: item.instructionImage ?? "",
          name: item.instructionDetail ?? "",
          onTap: () => _handleItemTap(item, index),
          isSelected: selectedIndex == index,
        )
        : LeagueTile(
          imageUrl: item.instructionImage ?? "",
          name: item.instructionDetail ?? "",
          onTap: () => _handleItemTap(item, index),
          isSelected: selectedIndex == index,
        );
  }

  // Custom widget to display a GridView on tablets and a ListView on mobile devices
  Widget _buildListLayout(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;

    if (details.isEmpty && !isLoading) {
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
          final item = details[index];
          return buildDividerContainer(
            isSelected: selectedIndex == index,
            child: _buildItemTile(item, index, true),
          );
        }, childCount: details.length),
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
        itemCount: details.length + 1,
        itemBuilder: (context, index) {
          if (index == details.length) {
            return SizedBox();
          }
          final item = details[index];
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
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
              ),
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
