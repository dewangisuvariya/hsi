import 'package:flutter/material.dart';
import 'package:hsi/Model/statistics_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/leagueTile_Widget.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/statistics_helper.dart';
import '../../custom/custom_appbar.dart';
import '../../provider/BackgroundColorProvider.dart';
import 'package:provider/provider.dart';

// load Statistics details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isLoading = true;
  int? selectedIndex;
  late ApiService _apiService;
  List<HSIStatisticItem> statistics = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    loadData();
  }

  // Load data from the StatisticsHelper class via the web service.
  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final data = await _apiService.fetchHSIStatistics();
      if (data != null && data.success) {
        statistics = data.statistics;
      } else {
        // Handle error case
        showNetworkErrorDialog(context);
      }
    } catch (e) {
      if (mounted) {
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
          final statItem = statistics[index];
          return buildDividerContainer(
            child: _buildLeagueTileTab(statItem, index),
            isSelected: selectedIndex == index,
          );
        }, childCount: statistics.length),
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
        itemCount: statistics.length + 1,
        itemBuilder: (context, index) {
          if (index == statistics.length) {
            return SizedBox();
          }
          final statItem = statistics[index];
          return _buildLeagueTile(statItem, index);
        },
      );
    }
  }

  // This widget is displayed on mobile devices
  Widget _buildLeagueTile(HSIStatisticItem statItem, int index) {
    return LeagueTile(
      // Custom widget LeagueTileWidget to display a custom list tile
      imageUrl: statItem.image,
      name: statItem.name,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print('Statistic item: ${statItem.id} - ${statItem.name}');

        // You'll need to update these navigation calls based on your actual screens
      },
      isSelected: selectedIndex == index,
    );
  }

  // This widget is displayed on Tablet devices
  Widget _buildLeagueTileTab(HSIStatisticItem statItem, int index) {
    return LeagueTileTab(
      // Custom widget LeagueTileWidget to display a custom list tile for tablet
      imageUrl: statItem.image,
      name: statItem.name,
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print('Statistic item: ${statItem.id} - ${statItem.name}');
      },
      isSelected: selectedIndex == index,
    );
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
              CustomAppBar(title: "Tölfræði", imagePath: barChart),
              Expanded(
                child:
                    isLoading
                        ? Center(child: loadingAnimation)
                        : _buildListLayout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
