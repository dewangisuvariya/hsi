import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../../../Model/junior_tournament_model.dart';
import '../../../../custom/custom_appbar_subscreen.dart';
import '../../../../custom/tournament_of_junior.dart';
import '../../../../repository/junior_tournament_helper.dart';

// load U twenty men tournament details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class UTwentyOneMenScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;

  const UTwentyOneMenScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
  }) : super(key: key);

  @override
  _UTwentyOneMenScreenState createState() => _UTwentyOneMenScreenState();
}

class _UTwentyOneMenScreenState extends State<UTwentyOneMenScreen> {
  List<TournamentDetail> tournaments = [];
  Map<int, List<TournamentMatch>> tournamentMatches = {};
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Load data from the JuniorTournamentHelper class via the web service.
  Future<void> _fetchData() async {
    try {
      final tournamentDetails =
          await TournamentDetailsHelper.fetchTournamentDetails(widget.teamId);

      if (!tournamentDetails.success) {
        throw Exception(tournamentDetails.message);
      }

      for (var tournament in tournamentDetails.tournamentDetails) {
        final matchesResponse =
            await TournamentMatchesHelper.fetchTournamentMatches(
              tournament.tournamentId,
            );

        if (matchesResponse.success) {
          setState(() {
            tournamentMatches[tournament.tournamentId] =
                matchesResponse.matches;
          });
        }
      }

      setState(() {
        tournaments = tournamentDetails.tournamentDetails;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data: $e';
        });
        showNetworkErrorDialog(context);
      }
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        children: [
          CustomAppBarSubScreen(
            title: widget.teamName,
            imagePath: widget.teamImage,
          ),
          Expanded(
            child:
                isLoading
                    ? Center(child: loadingAnimation)
                    : errorMessage.isNotEmpty
                    ? Center(child: Text(''))
                    : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAFAFA),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFD9D9D9),
                              width: 0.8,
                            ),
                          ),
                          child: Column(
                            children:
                                tournaments.map((tournament) {
                                  final matches =
                                      tournamentMatches[tournament
                                          .tournamentId] ??
                                      [];

                                  return TournamentSection(
                                    // Custom widget TournamentOfJunior to display content in a column
                                    tournament: tournament,
                                    matches: matches,
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
