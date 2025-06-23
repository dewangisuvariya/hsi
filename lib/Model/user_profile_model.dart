class UserProfileResponse {
  final bool success;
  final String message;
  final UserProfileData data;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserProfileData {
  final int userId;
  final String profilePic;
  final String firstName;
  final String lastName;
  final String email;
  final String telephoneNo;
  final bool isVerify;
  final List<FavouriteClub> favouriteClubs;

  UserProfileData({
    required this.userId,
    required this.profilePic,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephoneNo,
    required this.isVerify,
    required this.favouriteClubs,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      userId: json['user_id'] ?? 0,
      profilePic: json['profile_pic'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      telephoneNo: json['telephone_no'] ?? '',
      isVerify: (json['is_verify'] ?? 0) == 1,
      favouriteClubs:
          (json['favourite_clubs'] as List<dynamic>?)
              ?.map((club) => FavouriteClub.fromJson(club))
              .toList() ??
          [],
    );
  }
}

class FavouriteClub {
  final int clubId;
  final String clubName;
  final String clubImage;
  final List<FavouriteTeam> favouriteTeams;

  FavouriteClub({
    required this.clubId,
    required this.clubName,
    required this.clubImage,
    required this.favouriteTeams,
  });

  factory FavouriteClub.fromJson(Map<String, dynamic> json) {
    return FavouriteClub(
      clubId: json['club_id'] ?? 0,
      clubName: json['club_name'] ?? '',
      clubImage: json['club_image'] ?? '',
      favouriteTeams:
          (json['favourite_teams'] as List<dynamic>?)
              ?.map((team) => FavouriteTeam.fromJson(team))
              .toList() ??
          [],
    );
  }
}

class FavouriteTeam {
  final int teamId;
  final String teamName;
  final String teamImage;

  FavouriteTeam({
    required this.teamId,
    required this.teamName,
    required this.teamImage,
  });

  factory FavouriteTeam.fromJson(Map<String, dynamic> json) {
    return FavouriteTeam(
      teamId: json['team_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      teamImage: json['team_image'] ?? '',
    );
  }
}
