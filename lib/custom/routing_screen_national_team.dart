import 'package:flutter/material.dart';

import '../view/national_team/junior_section/handbook_junior_national_team_screen.dart';
import '../view/national_team/junior_section/man_junior_national_team.dart';
import '../view/national_team/junior_section/success_at_major_tournaments_screen.dart';
import '../view/national_team/junior_section/women_junior_national_team_screen.dart';
import '../view/national_team/men_section/about_team_screen.dart';
import '../view/national_team/men_section/coaches_from_beginning_screen.dart';
import '../view/national_team/men_section/national_team_week_screen.dart';
import '../view/national_team/men_section/success_at_major_tournaments.dart';
import '../view/national_team/women_section/about_team_women_screen.dart';
import '../view/national_team/women_section/coaches_from_beginning_women_screen.dart';
import '../view/national_team/women_section/national_team_weeks_women_screen.dart';
import '../view/national_team/women_section/success_at_major_tournaments_women_screen.dart';
import 'custom_appbar_subscreen.dart';

class TeamSectionWrapper extends StatelessWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String type;

  const TeamSectionWrapper({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (teamId) {
      case 3:
        return AboutTeamScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 4:
        return CoachesFromBeginningScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 6:
        return SuccessAtMajorTournaments(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 8:
        return NationalTeamWeeksScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 11:
        return CoachesFromBeginningWomenScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 13:
        return NationalTeamWeeksWomenScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 12:
        return SuccessAtMajorTournamentsWomenScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 10:
        return AboutTeamWomenScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 17:
        return SuccessAtMajorTournamentsScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 15:
        return ManJuniorNationalTeam(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 16:
        return WomenJuniorNationalTeamScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      case 18:
        return HandbookJuniorNationalTeamScreen(
          teamId: teamId,
          teamName: teamName,
          teamImage: teamImage,
          type: type,
        );
      default:
        return Scaffold(
          backgroundColor: Color(0xFFFAFAFA),
          body: Stack(
            children: [
              CustomAppBarSubScreen(title: teamName, imagePath: teamImage),
              Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
            ],
          ),
        );
    }
  }
}
