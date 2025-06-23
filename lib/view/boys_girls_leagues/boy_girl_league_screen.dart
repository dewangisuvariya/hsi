import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:provider/provider.dart';
import '../../Model/boys_girls_child_league_model.dart';
import '../../custom/custom_appbar_subscreen.dart';
import '../../custom/leagueTile_Widget.dart';
import '../../provider/BackgroundColorProvider.dart';
import '../../repository/boys-girls_child-leagues_helper.dart';

// load Boy Girl League details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class BoyGirlLeagueScreen extends StatefulWidget {
  final int leagueId;
  final String leagueName;
  final String leaguesImage;

  const BoyGirlLeagueScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
    required this.leaguesImage,
  });

  @override
  State<BoyGirlLeagueScreen> createState() => _BoyGirlLeagueScreenState();
}

class _BoyGirlLeagueScreenState extends State<BoyGirlLeagueScreen> {
  final BoysGirlsLeagueHelper _competitionRepo = BoysGirlsLeagueHelper();

  bool isLoading = true;
  int? selectedIndex;
  List<LeagueDetail> leagueDetails = [];

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  // Load data from the BoysGirlsChildLeagueHelper class via the web service.
  Future<void> fetchList() async {
    setState(() {
      isLoading = true;
    });

    try {
      final details = await _competitionRepo.fetchLeagueDetails(
        widget.leagueId,
      );
      if (details.success) {
        setState(() {
          leagueDetails = details.leagueDetails;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      showNetworkErrorDialog(context);
      print('Error fetching league details: $e');
    }
  }
  // create structure of the screen

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
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
                title: widget.leagueName,
                imagePath: widget.leaguesImage,
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
                    itemCount: leagueDetails.length + 1,
                    itemBuilder: (context, index) {
                      if (index == leagueDetails.length) {
                        return SizedBox();
                      }
                      final league = leagueDetails[index];

                      return LeagueTile(
                        // Custom widget LeagueTileWidget to display a custom list tile
                        imageUrl: league.image,
                        name: league.name,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          print(
                            'Selected League: ${league.name}, ID: ${league.id}',
                          );
                        },
                        isSelected: selectedIndex == index,
                      );
                    },
                  ),
                ),
            ],
          ),
          if (isLoading) Positioned.fill(child: loadingAnimation),
        ],
      ),
    );
  }
}
