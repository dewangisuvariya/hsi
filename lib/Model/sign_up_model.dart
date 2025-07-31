import 'dart:io';

class RegisterUserRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String telephoneNo;
  final String favouriteClub;
  final String password;
  final String confirmPassword;
  final File? profilePic;

  RegisterUserRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephoneNo,
    required this.favouriteClub,
    required this.password,
    required this.confirmPassword,
    this.profilePic,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'telephone_no': telephoneNo,
      'favourite_club': favouriteClub,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}

class RegisterUserResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;
  final int? userId;

  RegisterUserResponse({
    required this.success,
    required this.message,
    this.data,
    this.userId,
  });

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) {
    return RegisterUserResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
      userId: json['user_id'] ?? json['data']?['user_id'],
    );
  }
}
