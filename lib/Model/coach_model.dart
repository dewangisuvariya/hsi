  class CoachListResponse {
    final bool success;
    final String message;
    final List<Coach> coaches;

    CoachListResponse({
      required this.success,
      required this.message,
      required this.coaches,
    });

    factory CoachListResponse.fromJson(Map<String, dynamic> json) {
      return CoachListResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        coaches: List<Coach>.from(
            json['coaches']?.map((x) => Coach.fromJson(x)) ?? []),
      );
    }

    Map<String, dynamic> toJson() => {
      'success': success,
      'message': message,
      'coaches': List<dynamic>.from(coaches.map((x) => x.toJson())),
    };
  }

  class Coach {
    final int id;
    final String league;
    final String name;
    final String email;
    final String phone;

    Coach({
      required this.id,
      required this.league,
      required this.name,
      required this.email,
      required this.phone,
    });

    factory Coach.fromJson(Map<String, dynamic> json) {
      return Coach(
        id: json['id'] ?? 0,
        league: json['league'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
      );
    }

    Map<String, dynamic> toJson() => {
      'id': id,
      'league': league,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }