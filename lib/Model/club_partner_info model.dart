class ClubPartnersResponse {
  final bool success;
  final String message;
  final List<ClubPartner> clubPartners;

  ClubPartnersResponse({
    required this.success,
    required this.message,
    required this.clubPartners,
  });

  factory ClubPartnersResponse.fromJson(Map<String, dynamic> json) {
    return ClubPartnersResponse(
      success: json['success'],
      message: json['message'],
      clubPartners: List<ClubPartner>.from(
        json['club_partners'].map((x) => ClubPartner.fromJson(x)),
      ),
    );
  }
}

class ClubPartner {
  final int id;
  final PartnerInfo homeField;
  final PartnerInfo homepage;
  final PartnerInfo chairman;
  final PartnerInfo executiveDirector;
  final PartnerInfo chairmanCouncilChildrenYouth;
  final PartnerInfo treasurerChildrenYouthCouncil;
  final PartnerInfo chairmanMensChampionshipCouncil;
  final PartnerInfo chairmanWomensChampionshipCouncil;
  final PartnerInfo headCoach;
  final PartnerInfo sportsRepresentative;
  final PartnerInfo? handballDepartmentProjectManager;
  final PartnerInfo? projectManager;
  final PartnerInfo? officeManager;
  final PartnerInfo? handballDepartmentExecutiveDirector;
  final PartnerInfo? mensHeadCoach;
  final PartnerInfo? womensHeadCoach;
  final PartnerInfo? chairmenOfTheChampionshipCouncil;
  final PartnerInfo? viceChairman;
  final PartnerInfo? treasurer;

  ClubPartner({
    required this.id,
    required this.homeField,
    required this.homepage,
    required this.chairman,
    required this.executiveDirector,
    required this.chairmanCouncilChildrenYouth,
    required this.treasurerChildrenYouthCouncil,
    required this.chairmanMensChampionshipCouncil,
    required this.chairmanWomensChampionshipCouncil,
    required this.headCoach,
    required this.sportsRepresentative,
    this.handballDepartmentProjectManager,
    this.projectManager,
    this.officeManager,
    this.handballDepartmentExecutiveDirector,
    this.mensHeadCoach,
    this.womensHeadCoach,
    this.chairmenOfTheChampionshipCouncil,
    this.viceChairman,
    this.treasurer,
  });

  factory ClubPartner.fromJson(Map<String, dynamic> json) {
    return ClubPartner(
      id: json['id'],
      homeField: PartnerInfo.fromJson(json['home_field']),
      homepage: PartnerInfo.fromJson(json['homepage']),
      chairman: PartnerInfo.fromJson(json['chairman']),
      executiveDirector: PartnerInfo.fromJson(json['executive_director']),
      chairmanCouncilChildrenYouth: PartnerInfo.fromJson(
        json['chairman_council_children_youth'],
      ),
      treasurerChildrenYouthCouncil: PartnerInfo.fromJson(
        json['treasurer_children_youth_council'],
      ),
      chairmanMensChampionshipCouncil: PartnerInfo.fromJson(
        json['chairman_mens_championship_council'],
      ),
      chairmanWomensChampionshipCouncil: PartnerInfo.fromJson(
        json['chairman_womens_championship_council'],
      ),
      headCoach: PartnerInfo.fromJson(json['head_coach']),
      sportsRepresentative: PartnerInfo.fromJson(json['sports_representative']),
      handballDepartmentProjectManager:
          json['handball_department_project_manager']['description'] != null
              ? PartnerInfo.fromJson(
                json['handball_department_project_manager'],
              )
              : null,
      projectManager:
          json['project_manager']['description'] != null
              ? PartnerInfo.fromJson(json['project_manager'])
              : null,
      officeManager:
          json['office_manager']['description'] != null
              ? PartnerInfo.fromJson(json['office_manager'])
              : null,
      handballDepartmentExecutiveDirector:
          json['handball_department_executive_director']['description'] != null
              ? PartnerInfo.fromJson(
                json['handball_department_executive_director'],
              )
              : null,
      mensHeadCoach:
          json['mens_head_coach']['description'] != null
              ? PartnerInfo.fromJson(json['mens_head_coach'])
              : null,
      womensHeadCoach:
          json['womens_head_coach']['description'] != null
              ? PartnerInfo.fromJson(json['womens_head_coach'])
              : null,
      chairmenOfTheChampionshipCouncil:
          json['chairmen_of_the_championship_council']['description'] != null
              ? PartnerInfo.fromJson(
                json['chairmen_of_the_championship_council'],
              )
              : null,
      viceChairman:
          json['vice_chairman']['description'] != null
              ? PartnerInfo.fromJson(json['vice_chairman'])
              : null,
      treasurer:
          json['treasurer']['description'] != null
              ? PartnerInfo.fromJson(json['treasurer'])
              : null,
    );
  }
}

class PartnerInfo {
  final String title;
  final String? description;
  final String? image;

  PartnerInfo({required this.title, this.description, this.image});

  factory PartnerInfo.fromJson(Map<String, dynamic> json) {
    return PartnerInfo(
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }
}
