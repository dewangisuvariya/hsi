import 'package:flutter/material.dart';
import 'package:hsi/Model/sub_sectiono_about_hsi_model.dart';
import 'package:hsi/view/about_hsi/Annual%20meeting%20of%20HSI/about_the_hsi_annual_conference_screen.dart';
import 'package:hsi/view/about_hsi/Annual%20meeting%20of%20HSI/acts_of_parliament_screen.dart';
import 'package:hsi/view/about_hsi/Annual%20meeting%20of%20HSI/hsi_annual_metting_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/committee_of_judges_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/disciplinary_committee_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/education_and_outreach_committee_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/handball_referees_association_of_iceland_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/hsi_court_of_appeal_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/hsi_court_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/law_commission_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/men_national_team_committee_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/tournament_committee_hsi_screen.dart';
import 'package:hsi/view/about_hsi/Committees%20and%20courts/women_national_team_committee_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/achievement_policy_of_hsi_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/board_of_hSi_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/chairmen_since_the_founding_of_hsi_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/hSI_logos_and_emblems_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/hSI_office_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/hSi_board_meeting_minutes_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/hSi_staff_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/hsi_code_of_conduct_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/hsi_environmental_policy_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/points_of_interests_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/privacy_policy_four_screen.dart';
import 'package:hsi/view/about_hsi/General%20about%20HS%C3%8D/the_history_of_handball_screen.dart';
import 'package:hsi/view/about_hsi/laws_and_regulations/hsi_regulations_screen.dart';
import 'package:hsi/view/about_hsi/laws_and_regulations/laws_of_hsi_screen.dart';

class NavigationHelper {
  static Widget? getScreenById(int? id, GeneralInfo league) {
    if (id == null) return null;

    switch (id) {
      case 1:
        return HsiOfficeScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 2:
        return HsiStaffScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 3:
        return BoardOfHsiScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 4:
        return HsiBoardMeetingMinutesScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 5:
        return TheHistoryOfHandballScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 6:
        return LawsOfHsiScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 7:
        return HsiRegulationsScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 9:
        return ChairmenSinceTheFoundingOfHsiScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 10:
        return PointsOfInterestsScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 11:
        return AchievementPolicyOfHsiScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 12:
        return HsiCodeOfConductScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 13:
        return PrivacyPolicyFourScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 14:
        return DisciplinaryCommitteeScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 15:
        return HsiCourtScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 16:
        return HsiCourtOfAppealScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 17:
        return CommitteeOfJudgesScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 18:
        return LawCommissionScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 19:
        return WomenNationalTeamCommitteeScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 20:
        return MenNationalTeamCommitteeScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 21:
        return TournamentCommitteeHsiScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 22:
        return EducationAndOutreachCommitteeScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 23:
        return HandballRefereesAssociationOfIcelandScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 24:
        return AboutTheHsiAnnualConferenceScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 25:
        return HsiAnnualMeetingScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 26:
        return ActsOfParliamentScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 32:
        return HsiLogosAndEmblemsScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      case 35:
        return HsiEnvironmentalPolicyScreen(
          subSectionId: league.id,
          image: league.image,
          name: league.name,
          type: league.type,
        );
      default:
        return null;
    }
  }
}
