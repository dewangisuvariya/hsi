import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';
import '../Model/junior_tournament_model.dart';

// Custom widget to display tournament data
class TournamentSection extends StatelessWidget {
  final TournamentDetail tournament;
  final List<TournamentMatch> matches;

  const TournamentSection({
    Key? key,
    required this.tournament,
    required this.matches,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 10,
            right: 16,
            left: 16,
          ),
          child: Text(
            tournament.tournamentName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(color: selectedDividerColor, thickness: 1),
        ),
        if (matches.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: MatchesGrid(matches: matches),
          )
        else
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No matches available for this tournament'),
          ),
      ],
    );
  }
}

// Custom widget to display a GridView containing the MatchContainer custom class in the UI
class MatchesGrid extends StatelessWidget {
  final List<TournamentMatch> matches;

  const MatchesGrid({Key? key, required this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.6,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        return MatchContainer(match: matches[index]);
      },
    );
  }
}

// Display in this UI the container showing tournament name, score, and image
class MatchContainer extends StatelessWidget {
  final TournamentMatch match;
  final double imageSize;

  const MatchContainer({Key? key, required this.match, this.imageSize = 30})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: 48.h,
        width: 170.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: containerSuccesAtMajorTorunamentColor),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8, right: 4, left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTeamColumn(match.homeTeamName, match.homeTeamScore),

              Padding(
                padding: const EdgeInsets.all(5),
                child:
                    match.image.isNotEmpty
                        ? Image.network(
                          match.image,
                          width: imageSize.w,
                          height: imageSize.h,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return errorImageContainer();
                          },
                        )
                        : errorImageContainer(),
              ),

              _buildTeamColumn(match.awayTeamName, match.awayTeamScore),
            ],
          ),
        ),
      ),
    );
  }

  // Custom widget to display a column
  Widget _buildTeamColumn(String teamName, int teamScore) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          teamName,
          textAlign: TextAlign.center,
          style: textStyleTournaments,
        ),
        Text(
          "$teamScore",
          textAlign: TextAlign.center,
          style: textStyleTournaments,
        ),
      ],
    );
  }
}
