class AboutHsiDetailsResponse {
  final bool success;
  final String message;
  final AboutHsiData data;

  AboutHsiDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AboutHsiDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AboutHsiDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AboutHsiData.fromJson(json['data'] ?? {}),
    );
  }
}

class AboutHsiData {
  final Info info;
  final List<OfficeDetail> officeDetails;
  final List<StaffDetail> staffDetails;
  final List<BoardMember> boardDetail;
  final List<MeetingDetail> meetingDetails;
  final List<ChairmanDetail> chairmanDetails;
  final List<PointOfInterestDetail> pointOfInterestDetails;
  final List<AchievementPolicyDetail> achievementPolicyDetails;
  final List<CodeOfConductDetail> codeOfConductDetails;
  final List<PolicyDetail> privacyPolicyDetails;
  final List<LawDetail> lawDetails;
  final List<RegulationDetail> regulationDetails;
  final List<CourtDetail> courtDetails;
  final List<CommitteeHeadingDetail> committeeHeadingDetails;
  final List<Inspector> inspectorDetails;
  final List<CommitteeDetail> committeeDetails;
  final List<DisciplinHeadingDetail> disciplinHeadingDetails;
  final List<LogoDetail> logoDetails;
  final HeadingDetails headingDetails;

  AboutHsiData({
    required this.info,
    required this.officeDetails,
    required this.staffDetails,
    required this.boardDetail,
    required this.meetingDetails,
    required this.chairmanDetails,
    required this.pointOfInterestDetails,
    required this.achievementPolicyDetails,
    required this.codeOfConductDetails,
    required this.privacyPolicyDetails,
    required this.lawDetails,
    required this.regulationDetails,
    required this.courtDetails,
    required this.committeeHeadingDetails,
    required this.inspectorDetails,
    required this.committeeDetails,
    required this.disciplinHeadingDetails,
    required this.logoDetails,
    required this.headingDetails,
  });

  factory AboutHsiData.fromJson(Map<String, dynamic> json) {
    return AboutHsiData(
      info: Info.fromJson(json['info'] ?? {}),
      officeDetails:
          (json['officeDetails'] as List?)
              ?.map((item) => OfficeDetail.fromJson(item))
              .toList() ??
          [],
      staffDetails:
          (json['staffDetails'] as List?)
              ?.map((item) => StaffDetail.fromJson(item))
              .toList() ??
          [],
      boardDetail:
          (json['boardDetail'] as List?)
              ?.map((item) => BoardMember.fromJson(item))
              .toList() ??
          [],
      meetingDetails:
          (json['meetingDetails'] as List?)
              ?.map((item) => MeetingDetail.fromJson(item))
              .toList() ??
          [],
      chairmanDetails:
          (json['chairmanDetails'] as List?)
              ?.map((item) => ChairmanDetail.fromJson(item))
              .toList() ??
          [],
      pointOfInterestDetails:
          (json['pointOfInterestDetails'] as List?)
              ?.map((item) => PointOfInterestDetail.fromJson(item))
              .toList() ??
          [],
      achievementPolicyDetails:
          (json['achievementPolicyDetails'] as List?)
              ?.map((item) => AchievementPolicyDetail.fromJson(item))
              .toList() ??
          [],
      logoDetails:
          (json['logoDetails'] as List?)
              ?.map((item) => LogoDetail.fromJson(item))
              .toList() ??
          [],
      codeOfConductDetails:
          (json['codeOfConductDetails'] as List?)
              ?.map((item) => CodeOfConductDetail.fromJson(item))
              .toList() ??
          [],
      privacyPolicyDetails:
          (json['privacyPolicyDetails'] as List?)
              ?.map((item) => PolicyDetail.fromJson(item))
              .toList() ??
          [],
      lawDetails:
          (json['lawDetails'] as List?)
              ?.map((item) => LawDetail.fromJson(item))
              .toList() ??
          [],
      regulationDetails:
          (json['regulationDetails'] as List?)
              ?.map((item) => RegulationDetail.fromJson(item))
              .toList() ??
          [],
      courtDetails:
          (json['courtDetails'] as List?)
              ?.map((item) => CourtDetail.fromJson(item))
              .toList() ??
          [],

      committeeHeadingDetails:
          (json['committeeHeadingDetails'] as List?)
              ?.map((item) => CommitteeHeadingDetail.fromJson(item))
              .toList() ??
          [],
      inspectorDetails:
          (json['inspectorDetails'] as List?)
              ?.map((item) => Inspector.fromJson(item))
              .toList() ??
          [],

      committeeDetails:
          (json['committeeDetails'] as List?)
              ?.map((item) => CommitteeDetail.fromJson(item))
              .toList() ??
          [],
      disciplinHeadingDetails:
          (json['disciplinHeadingDetails'] as List?)
              ?.map((item) => DisciplinHeadingDetail.fromJson(item))
              .toList() ??
          [],

      headingDetails: HeadingDetails.fromJson(json['headingDetails'] ?? {}),
    );
  }
}

class CourtDetail {
  final int id;
  final String name;
  final String? details;
  final String image;

  CourtDetail({
    required this.id,
    required this.name,
    this.details,
    required this.image,
  });

  factory CourtDetail.fromJson(Map<String, dynamic> json) {
    return CourtDetail(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      image: json['image'],
    );
  }
}

class Inspector {
  final int id;
  final String name;
  final String image;

  Inspector({required this.id, required this.name, required this.image});

  factory Inspector.fromJson(Map<String, dynamic> json) {
    return Inspector(id: json['id'], name: json['name'], image: json['image']);
  }
}

class CommitteeHeadingDetail {
  final int id;
  final String heading;
  final String? subHeading;
  final List<Document> documents;

  CommitteeHeadingDetail({
    required this.id,
    required this.heading,
    this.subHeading,
    required this.documents,
  });

  factory CommitteeHeadingDetail.fromJson(Map<String, dynamic> json) {
    final documents = <Document>[];

    // Handle both List and Map formats for documents
    if (json['documents'] is List) {
      for (var doc in json['documents']) {
        if (doc is Map<String, dynamic>) {
          documents.add(Document.fromJson(doc));
        }
      }
    } else if (json['documents'] is Map) {
      for (var entry in (json['documents'] as Map).entries) {
        if (entry.value is Map<String, dynamic>) {
          documents.add(Document.fromJson(entry.value));
        }
      }
    }

    return CommitteeHeadingDetail(
      id: json['id'],
      heading: json['heading'],
      subHeading: json['sub_heading'],
      documents: documents,
    );
  }
}

class Document {
  final String file;
  final String title;

  Document({required this.file, required this.title});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(file: json['file'] ?? '', title: json['title'] ?? '');
  }
}

class CommitteeDetail {
  final int id;
  final String name;
  final String? details;
  final String image;

  CommitteeDetail({
    required this.id,
    required this.name,
    this.details,
    required this.image,
  });

  factory CommitteeDetail.fromJson(Map<String, dynamic> json) {
    return CommitteeDetail(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      image: json['image'],
    );
  }
}

class RegulationDetail {
  final int id;
  final String regulationDetails;
  final String regulationTitle;

  RegulationDetail({
    required this.id,
    required this.regulationDetails,
    required this.regulationTitle,
  });

  factory RegulationDetail.fromJson(Map<String, dynamic> json) {
    return RegulationDetail(
      id: json['id'],
      regulationDetails: json['regulation_details'],
      regulationTitle: json['regulation_title'],
    );
  }
}

class Info {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  Info({
    required this.subSectionId,
    required this.name,
    required this.type,
    required this.image,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      subSectionId: json['sub_section_id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class LawDetail {
  final int id;
  final String lawDetails;
  final String lawTitle;

  LawDetail({
    required this.id,
    required this.lawDetails,
    required this.lawTitle,
  });

  factory LawDetail.fromJson(Map<String, dynamic> json) {
    return LawDetail(
      id: json['id'],
      lawDetails: json['law_details'],
      lawTitle: json["law_title"],
    );
  }
}

class OfficeDetail {
  final int id;
  final String title;
  final String description;
  final String image;

  OfficeDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  factory OfficeDetail.fromJson(Map<String, dynamic> json) {
    return OfficeDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class StaffDetail {
  final int id;
  final String memberName;
  final String memberDetails;
  final String memberPhone;
  final String phoneImage;
  final String memberEmail;
  final String emailImage;

  StaffDetail({
    required this.id,
    required this.memberName,
    required this.memberDetails,
    required this.memberPhone,
    required this.phoneImage,
    required this.memberEmail,
    required this.emailImage,
  });

  factory StaffDetail.fromJson(Map<String, dynamic> json) {
    return StaffDetail(
      id: json['id'] ?? 0,
      memberName: json['member_name'] ?? '',
      memberDetails: json['member_details'] ?? '',
      memberPhone: json['member_phone'] ?? "",
      phoneImage: json['phone_image'] ?? '',
      memberEmail: json['member_email'] ?? '',
      emailImage: json['email_image'] ?? '',
    );
  }
}

class BoardMember {
  final int id;
  final String categoryName;
  final String personName;
  final String personDetails;
  final String image;

  BoardMember({
    required this.id,
    required this.categoryName,
    required this.personName,
    required this.personDetails,
    required this.image,
  });

  factory BoardMember.fromJson(Map<String, dynamic> json) {
    return BoardMember(
      id: json['id'],
      categoryName: json['category_name'],
      personName: json['person_name'],
      personDetails: json['person_details'],
      image: json['image'],
    );
  }
}

class MeetingDetail {
  final int id;
  final String meetingDetails;
  final String image;

  MeetingDetail({
    required this.id,
    required this.meetingDetails,
    required this.image,
  });

  factory MeetingDetail.fromJson(Map<String, dynamic> json) {
    return MeetingDetail(
      id: json['id'],
      meetingDetails: json['meeting_details'],
      image: json['image'],
    );
  }
}

class DisciplinHeadingDetail {
  final int id;
  final String heading;
  final List<Document> documents;

  DisciplinHeadingDetail({
    required this.id,
    required this.heading,
    required this.documents,
  });

  factory DisciplinHeadingDetail.fromJson(Map<String, dynamic> json) {
    return DisciplinHeadingDetail(
      id: json['id'],
      heading: json['heading'],
      documents:
          (json['documents'] as List<dynamic>)
              .map((doc) => Document.fromJson(doc))
              .toList(),
    );
  }
}

// class Document {
//   final String file;
//   final String title;

//   Document({required this.file, required this.title});

//   factory Document.fromJson(Map<String, dynamic> json) {
//     return Document(file: json['file'], title: json['title']);
//   }
// }

class ChairmanDetail {
  final int id;
  final String chairmanName;
  final String chairmanDetails;
  final String image;

  ChairmanDetail({
    required this.id,
    required this.chairmanName,
    required this.chairmanDetails,
    required this.image,
  });

  factory ChairmanDetail.fromJson(Map<String, dynamic> json) {
    return ChairmanDetail(
      id: json['id'] ?? 0,
      chairmanName: json['chairman_name'] ?? '',
      chairmanDetails: json['chairman_details'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class PointOfInterestDetail {
  final int id;
  final String pointDetail;

  PointOfInterestDetail({required this.id, required this.pointDetail});

  factory PointOfInterestDetail.fromJson(Map<String, dynamic> json) {
    return PointOfInterestDetail(
      id: json['id'],
      pointDetail: json['point_detail'],
    );
  }
}

class AchievementPolicyDetail {
  final int id;
  final String achievementDetail;
  final String achievementTitle;

  AchievementPolicyDetail({
    required this.id,
    required this.achievementDetail,
    required this.achievementTitle,
  });

  factory AchievementPolicyDetail.fromJson(Map<String, dynamic> json) {
    return AchievementPolicyDetail(
      id: json['id'],
      achievementDetail: json['achievement_detail'],
      achievementTitle: json['achievement_title'],
    );
  }
}

class LogoDetail {
  final int id;
  final String? jpgLogo;
  final String? pngLogo;
  final String? svgLogo;
  final String? pdfLogo;
  final String? epsLogo;
  final String logoName;

  LogoDetail({
    required this.id,
    this.jpgLogo,
    this.pngLogo,
    this.svgLogo,
    this.pdfLogo,
    this.epsLogo,
    required this.logoName,
  });

  factory LogoDetail.fromJson(Map<String, dynamic> json) {
    return LogoDetail(
      id: json['id'],
      jpgLogo: json['jpg_logo'],
      pngLogo: json['png_logo'],
      svgLogo: json['svg_logo'],
      pdfLogo: json['pdf_logo'],
      epsLogo: json['eps_logo'],
      logoName: json["logo_name"],
    );
  }
}

class HeadingDetails {
  final int id;
  final String heading;
  final String? subHeading;

  HeadingDetails({required this.id, required this.heading, this.subHeading});

  factory HeadingDetails.fromJson(Map<String, dynamic> json) {
    return HeadingDetails(
      id: json['id'] ?? 0,
      heading: json['heading'] ?? '',
      subHeading: json['sub_heading'],
    );
  }
}

class CodeOfConductDetail {
  final int id;
  final String conductDetails;
  final String conductTitle;

  CodeOfConductDetail({
    required this.id,
    required this.conductDetails,
    required this.conductTitle,
  });

  factory CodeOfConductDetail.fromJson(Map<String, dynamic> json) {
    return CodeOfConductDetail(
      id: json['id'],
      conductDetails: json['conduct_details'],
      conductTitle: json["conduct_title"],
    );
  }
}

class PolicyDetail {
  final int id;
  final String policyTitle;
  final String policyDescription;

  PolicyDetail({
    required this.id,
    required this.policyTitle,
    required this.policyDescription,
  });

  factory PolicyDetail.fromJson(Map<String, dynamic> json) {
    return PolicyDetail(
      id: json['id'],
      policyTitle: json['policy_title'],
      policyDescription: json['policy_description'],
    );
  }
}
