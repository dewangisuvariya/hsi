import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/edit_profile_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/custom/custom_text_form_field.dart';
import 'package:hsi/view/Profile/profile_otp_verify_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:hsi/provider/UserProfileProvider.dart';

// Load profile update details from the web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _surNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    final userProfile = profileProvider.userProfile;

    _firstNameController.text = userProfile?.firstName ?? '';
    _surNameController.text = userProfile?.lastName ?? '';
    _emailController.text = userProfile?.email ?? '';
    _phoneController.text = userProfile?.telephoneNo ?? '';
  }

  // Pick an image from the user's gallery and compress the selected image
  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: 80,
        minWidth: 540,
        minHeight: 540,
        format: CompressFormat.jpeg,
      );

      if (compressedFile != null) {
        setState(() => _profileImage = File(compressedFile.path));
      } else {
        setState(() => _profileImage = File(pickedFile.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image: ${e.toString()}')),
      );
    }
  }

  // Update the profile with the help of the UserProfileProvider class and update the data
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    // Get the current profile data
    final profileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    final userProfile = profileProvider.userProfile!;

    // Check if any data has changed
    final firstNameChanged = _firstNameController.text != userProfile.firstName;
    final surNameChanged = _surNameController.text != userProfile.lastName;
    final emailChanged = _emailController.text != userProfile.email;
    final phoneChanged = _phoneController.text != userProfile.telephoneNo;
    final imageChanged = _profileImage != null;

    // If nothing has changed, show message and return
    if (!firstNameChanged &&
        !surNameChanged &&
        !emailChanged &&
        !phoneChanged &&
        !imageChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes were made to update')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      final profileProvider = Provider.of<UserProfileProvider>(
        context,
        listen: false,
      );
      final userProfile = profileProvider.userProfile!;

      final request = EditProfileRequest(
        userId: userProfile.userId,
        firstName: _firstNameController.text,
        lastName: _surNameController.text,
        email: _emailController.text,
        telephoneNo: _phoneController.text,
        profilePic: _profileImage,
      );

      await profileProvider.updateProfile(request);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ProfileOtpVerifyScreen(email: _emailController.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  // Display user profile picture
  ImageProvider _getProfileImage() {
    final profileProvider = Provider.of<UserProfileProvider>(
      context,
      listen: false,
    );
    final userProfile = profileProvider.userProfile;

    // 1. Check if user selected a new image
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    }

    // 2. Check if API returned a valid profile picture URL
    if (userProfile?.profilePic != null && userProfile!.profilePic.isNotEmpty) {
      final profilePicUrl = userProfile.profilePic;

      if (profilePicUrl == "https://hsi.realrisktakers.com/") {
        return AssetImage(userImage);
      }

      try {
        final uri = Uri.parse(profilePicUrl);
        if (uri.isAbsolute &&
            (profilePicUrl.endsWith('.jpg') ||
                profilePicUrl.endsWith('.png') ||
                profilePicUrl.endsWith('.jpeg'))) {
          return NetworkImage(profilePicUrl);
        }
      } catch (e) {
        // Fall through to default image
      }
    }

    // 3. Fall back to default asset image
    return AssetImage(userImage);
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                // App Bar
                Container(
                  height: 104.h,
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(20.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 8.0.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Image.asset(
                                backArrow,
                                height: 34.h,
                                width: 80.w,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 12,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5.h),
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 36.98.w,
                                    height: 36.h,
                                    child: Image.asset(
                                      userEdit,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Flexible(
                                    child: Text(
                                      'Breyta prófíl',
                                      textAlign: TextAlign.center,
                                      style: appBarTextStyle.copyWith(
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Expanded(flex: 2, child: SizedBox()),
                      ],
                    ),
                  ),
                ),

                // Profile Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 132.h,
                              width: 132.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.2,
                                  color: subTitleColor,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                height: 130.h,
                                width: 130.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: _getProfileImage(),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 18,
                              right: 4,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Material(
                                  elevation: 8,
                                  shape: CircleBorder(),
                                  shadowColor: Colors.black38,
                                  child: Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.asset(
                                        camera,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Text(
                          '${_firstNameController.text} ${_surNameController.text}',
                          style: userNameTextStyle,
                        ),

                        SizedBox(height: 12.h),

                        // Form Fields
                        CustomTextField(
                          hintText: "First Name*",
                          iconPath: user,
                          controller: _firstNameController,
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 12.h),
                        CustomTextField(
                          hintText: "Surname*",
                          iconPath: user,
                          controller: _surNameController,
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 12.h),
                        CustomTextField(
                          hintText: "Email*",
                          iconPath: email,
                          controller: _emailController,
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        SizedBox(height: 12.h),
                        CustomTextField(
                          hintText: "Telephone No.*",
                          iconPath: phone,
                          controller: _phoneController,
                          validator:
                              (value) =>
                                  value?.isEmpty ?? true ? 'Required' : null,
                        ),

                        SizedBox(height: 24.h),

                        CustomElevatedButton(
                          text: "Uppfæra prófíl",
                          onPressed: _updateProfile,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isSaving) Positioned.fill(child: loadingAnimation),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
