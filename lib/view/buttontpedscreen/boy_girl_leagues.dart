import 'package:flutter/material.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/leagueTile_tab.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/view/boys_girls_leagues/static/girl_boy_league_screen.dart';
import 'package:provider/provider.dart';
import '../../custom/custom_appbar.dart';
import '../../custom/leagueTile_Widget.dart';
import '../../provider/BackgroundColorProvider.dart';
import '../../repository/boys_girls_league_helper.dart';
import '../boys_girls_leagues/boy_girl_league_screen.dart';

// load boy girl leagues details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class MotamalYangiriflokkarLeagePage extends StatefulWidget {
  const MotamalYangiriflokkarLeagePage({super.key});

  @override
  State<MotamalYangiriflokkarLeagePage> createState() =>
      _MotamalYangiriflokkarLeagePageState();
}

class _MotamalYangiriflokkarLeagePageState
    extends State<MotamalYangiriflokkarLeagePage> {
  final BoysGirlsLeage _compitionRepo = BoysGirlsLeage();

  bool isLoading = true;
  int? selectedIndex;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load data from the BoysGirlsLeagueHelper class via the web service.
  Future<void> loadData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      await _compitionRepo.boyGirlLeageData();
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
          final league = _compitionRepo.getData[index];
          return buildDividerContainer(
            child: _buildLeagueTileTab(league, index),
            isSelected: selectedIndex == index,
          );
        }, childCount: _compitionRepo.getData.length),
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
        itemCount: _compitionRepo.getData.length + 1,
        itemBuilder: (context, index) {
          if (index == _compitionRepo.getData.length) {
            return SizedBox();
          }
          final league = _compitionRepo.getData[index];
          return _buildLeagueTile(league, index);
        },
      );
    }
  }

  // This widget is displayed on mobile devices
  Widget _buildLeagueTile(dynamic league, int index) {
    return LeagueTile(
      // Custom widget LeagueTileWidget to display a custom list tile
      imageUrl: league.leaguesImage ?? '',
      name: league.leaguesName ?? 'No Name',
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print('League object: ${league.toJson()}');
        print(
          'League ID to pass: ${league.id} (type: ${league.id.runtimeType})',
        );
        if (league.id == null) {
          print('Warning: League ID is null!');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('League ID is missing')));
          return;
        }
        if (league.id == 8 ||
            league.id == 9 ||
            league.id == 11 ||
            league.id == 12) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => GirlBoyLeagueScreen(
                    leagueId: league.id!,
                    leagueName: league.leaguesName ?? 'League Details',
                    leaguesImage: league.leaguesImage ?? errorImage,
                  ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BoyGirlLeagueScreen(
                    leagueId: league.id!,
                    leagueName: league.leaguesName ?? 'League Details',
                    leaguesImage: league.leaguesImage ?? errorImage,
                  ),
            ),
          );
        }
      },
      isSelected: selectedIndex == index,
    );
  }

  // This widget is displayed on Tablet devices
  Widget _buildLeagueTileTab(dynamic league, int index) {
    return LeagueTileTab(
      // Custom widget LeagueTileWidget to display a custom list tile for tablet
      imageUrl: league.leaguesImage ?? '',
      name: league.leaguesName ?? 'No Name',
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        print('League object: ${league.toJson()}');
        print(
          'League ID to pass: ${league.id} (type: ${league.id.runtimeType})',
        );
        if (league.id == null) {
          print('Warning: League ID is null!');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('League ID is missing')));
          return;
        }
        if (league.id == 8 ||
            league.id == 9 ||
            league.id == 11 ||
            league.id == 12) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => GirlBoyLeagueScreen(
                    leagueId: league.id!,
                    leagueName: league.leaguesName ?? 'League Details',
                    leaguesImage: league.leaguesImage ?? errorImage,
                  ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BoyGirlLeagueScreen(
                    leagueId: league.id!,
                    leagueName: league.leaguesName ?? 'League Details',
                    leaguesImage: league.leaguesImage ?? errorImage,
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
              CustomAppBar(
                title: "Mótamál - yngri flokkar",
                imagePath: nationalTeam,
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
