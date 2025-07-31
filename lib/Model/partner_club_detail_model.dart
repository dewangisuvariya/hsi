class PartnerClubDetailModel {
  int? id;
  HomeField? homeField;
  HomeField? homepage;
  HomeField? chairman;
  HomeField? executiveDirector;
  HomeField? chairmanCouncilChildrenYouth;
  HomeField? treasurerChildrenYouthCouncil;
  HomeField? chairmanMensChampionshipCouncil;
  HomeField? chairmanWomensChampionshipCouncil;
  HomeField? headCoach;
  HomeField? sportsRepresentative;
  HomeField? handballDepartmentProjectManager;
  HomeField? projectManager;
  HomeField? officeManager;
  HomeField? handballDepartmentExecutiveDirector;
  HomeField? mensHeadCoach;
  HomeField? womensHeadCoach;
  HomeField? chairmenOfTheChampionshipCouncil;
  HomeField? viceChairman;
  HomeField? treasurer;

  PartnerClubDetailModel({
    this.id,
    this.homeField,
    this.homepage,
    this.chairman,
    this.executiveDirector,
    this.chairmanCouncilChildrenYouth,
    this.treasurerChildrenYouthCouncil,
    this.chairmanMensChampionshipCouncil,
    this.chairmanWomensChampionshipCouncil,
    this.headCoach,
    this.sportsRepresentative,

    ///
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

  PartnerClubDetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    homeField =
        json['home_field'] != null
            ? HomeField.fromJson(json['home_field'])
            : null;
    homepage =
        json['homepage'] != null ? HomeField.fromJson(json['homepage']) : null;
    chairman =
        json['chairman'] != null ? HomeField.fromJson(json['chairman']) : null;
    executiveDirector =
        json['executive_director'] != null
            ? HomeField.fromJson(json['executive_director'])
            : null;
    chairmanCouncilChildrenYouth =
        json['chairman_council_children_youth'] != null
            ? HomeField.fromJson(json['chairman_council_children_youth'])
            : null;
    treasurerChildrenYouthCouncil =
        json['treasurer_children_youth_council'] != null
            ? HomeField.fromJson(json['treasurer_children_youth_council'])
            : null;
    chairmanMensChampionshipCouncil =
        json['chairman_mens_championship_council'] != null
            ? HomeField.fromJson(json['chairman_mens_championship_council'])
            : null;
    chairmanWomensChampionshipCouncil =
        json['chairman_womens_championship_council'] != null
            ? HomeField.fromJson(json['chairman_womens_championship_council'])
            : null; // Added missing field
    headCoach =
        json['head_coach'] != null
            ? HomeField.fromJson(json['head_coach'])
            : null;
    sportsRepresentative =
        json['sports_representative'] != null
            ? HomeField.fromJson(json['sports_representative'])
            : null;
    /////////////////
    handballDepartmentProjectManager =
        json['handball_department_project_manager'] != null
            ? HomeField.fromJson(json['handball_department_project_manager'])
            : null;
    projectManager =
        json['project_manager'] != null
            ? HomeField.fromJson(json['project_manager'])
            : null;
    officeManager =
        json['office_manager'] != null
            ? HomeField.fromJson(json['office_manager'])
            : null;
    handballDepartmentExecutiveDirector =
        json['handball_department_executive_director'] != null
            ? HomeField.fromJson(json['handball_department_executive_director'])
            : null;
    mensHeadCoach =
        json['mens_head_coach'] != null
            ? HomeField.fromJson(json['mens_head_coach'])
            : null;
    womensHeadCoach =
        json['womens_head_coach'] != null
            ? HomeField.fromJson(json['womens_head_coach'])
            : null;
    chairmenOfTheChampionshipCouncil =
        json['chairmen_of_the_championship_council'] != null
            ? HomeField.fromJson(json['chairmen_of_the_championship_council'])
            : null;
    viceChairman =
        json['vice_chairman'] != null
            ? HomeField.fromJson(json['vice_chairman'])
            : null;
    treasurer =
        json['treasurer'] != null
            ? HomeField.fromJson(json['treasurer'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;

    if (homeField != null) {
      data['home_field'] = homeField!.toJson();
    }
    if (homepage != null) {
      data['homepage'] = homepage!.toJson();
    }
    if (chairman != null) {
      data['chairman'] = chairman!.toJson();
    }
    if (executiveDirector != null) {
      data['executive_director'] = executiveDirector!.toJson();
    }
    if (chairmanCouncilChildrenYouth != null) {
      data['chairman_council_children_youth'] =
          chairmanCouncilChildrenYouth!.toJson();
    }
    if (treasurerChildrenYouthCouncil != null) {
      data['treasurer_children_youth_council'] =
          treasurerChildrenYouthCouncil!.toJson();
    }
    if (chairmanMensChampionshipCouncil != null) {
      data['chairman_mens_championship_council'] =
          chairmanMensChampionshipCouncil!.toJson();
    }
    if (chairmanWomensChampionshipCouncil != null) {
      data['chairman_womens_championship_council'] =
          chairmanWomensChampionshipCouncil!.toJson();
    }
    if (headCoach != null) {
      data['head_coach'] = headCoach!.toJson();
    }
    if (sportsRepresentative != null) {
      data['sports_representative'] = sportsRepresentative!.toJson();
    }
    if (handballDepartmentProjectManager != null) {
      data['handball_department_project_manager'] =
          handballDepartmentProjectManager!.toJson();
    }
    if (projectManager != null) {
      data['project_manager'] = projectManager!.toJson();
    }
    if (officeManager != null) {
      data['office_manager'] = officeManager!.toJson();
    }
    if (handballDepartmentExecutiveDirector != null) {
      data['handball_department_executive_director'] =
          handballDepartmentExecutiveDirector!.toJson();
    }
    if (mensHeadCoach != null) {
      data['mens_head_coach'] = mensHeadCoach!.toJson();
    }
    if (womensHeadCoach != null) {
      data['womens_head_coach'] = womensHeadCoach!.toJson();
    }
    if (viceChairman != null) {
      data['vice_chairman'] = viceChairman!.toJson();
    }
    if (treasurer != null) {
      data['treasurer'] = treasurer!.toJson();
    }

    return data;
  }
}

class HomeField {
  String? title;
  String? description;
  String? image;

  HomeField({this.title, this.description, this.image});

  HomeField.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image': image};
  }
}
