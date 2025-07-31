import 'dart:io';

class EditProfileRequest {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String telephoneNo;
  final File? profilePic;
  final String? password;
  final String? confirmPassword;
  final String? favouriteClub;

  EditProfileRequest({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephoneNo,
    this.profilePic,
    this.password,
    this.confirmPassword,
    this.favouriteClub,
  });

  // For regular JSON requests (without file)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'telephone_no': telephoneNo,
      if (password != null) 'password': password!,
      if (confirmPassword != null) 'confirm_password': confirmPassword!,
      if (favouriteClub != null) 'favourite_club': favouriteClub!,
    };
  }

  // For multipart requests (with file)
  Map<String, String> toFormFields() {
    return {
      'user_id': userId.toString(),
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'telephone_no': telephoneNo,
      if (password != null) 'password': password!,
      if (confirmPassword != null) 'confirm_password': confirmPassword!,
      if (favouriteClub != null) 'favourite_club': favouriteClub!,
    };
  }
}

class EditProfileResponse {
  final bool success;
  final String message;
  final String? imageUrl; // Add this if your API returns the image URL

  EditProfileResponse({
    required this.success,
    required this.message,
    this.imageUrl,
  });

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
