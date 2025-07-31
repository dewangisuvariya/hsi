import 'package:flutter/material.dart';
import 'package:hsi/Model/edit_profile_model.dart';
import 'package:hsi/Model/user_profile_model.dart';
import 'package:hsi/repository/edit_profile_helper.dart';
import 'package:hsi/repository/user_profile_helper.dart';
// Provider class for displaying, updating user data, and loading details from the web server.

class UserProfileProvider with ChangeNotifier {
  UserProfileData? _userProfile;
  bool _isLoading = false;
  String _errorMessage = '';

  UserProfileData? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Load data from the UserProfileHelper class via the web service.
  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await UserProfileApi.fetchUserProfile();
      _userProfile = response.data;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load data from the EditProfileHelper class via the web service.
  Future<EditProfileResponse> updateProfile(EditProfileRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await UserEditProfileApi.editUserProfile(request);
      if (response.success) {
        await loadUserProfile(); // Refresh profile data after update
      }
      return response;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
