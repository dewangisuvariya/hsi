class ClubPartnerResponse {
  final bool status;
  final String message;
  final List<ClubPartner> data;

  ClubPartnerResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ClubPartnerResponse.fromJson(Map<String, dynamic> json) {
    return ClubPartnerResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>)
              .map((item) => ClubPartner.fromJson(item))
              .toList(),
    );
  }
}

class ClubPartner {
  final int clubId;
  final String name;
  final String image;
  bool isSelected;

  ClubPartner({
    required this.clubId,
    required this.name,
    required this.image,
    this.isSelected = false,
  });

  factory ClubPartner.fromJson(Map<String, dynamic> json) {
    return ClubPartner(
      clubId: json['club_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'club_id': clubId, 'name': name, 'image': image};
  }
}
