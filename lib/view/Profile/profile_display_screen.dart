import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/provider/UserProfileProvider.dart';
import 'package:hsi/view/Change%20Password/change_password_screen.dart';
import 'package:hsi/view/Profile/edit_profile_screen.dart';
import 'package:hsi/view/footer_screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// load profile details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ProfileDisplayScreen extends StatefulWidget {
  final Function(String)? onLogout;

  const ProfileDisplayScreen({Key? key, this.onLogout}) : super(key: key);
  @override
  State<ProfileDisplayScreen> createState() => _ProfileDisplayScreenState();
}

class _ProfileDisplayScreenState extends State<ProfileDisplayScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(
        context,
        listen: false,
      ).loadUserProfile();
    });
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _buildProfileContent(profileProvider),
    );
  }

  dynamic userProfile;
  // When the user logs out from the app
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('rememberMe');
    setState(() {
      userProfile = null;
      print("User logged out successfully");
    });

    widget.onLogout!('login');
  }

  // This displays the user's profile picture
  ImageProvider _getProfileImage(UserProfileProvider profileProvider) {
    final userProfile = profileProvider.userProfile;

    if (userProfile == null || userProfile.profilePic.isEmpty) {
      return AssetImage(userImage);
    }

    final profilePicUrl = userProfile.profilePic;
    if (profilePicUrl == "https://hsi.realrisktakers.com/" ||
        profilePicUrl.endsWith('/') ||
        (!profilePicUrl.contains('.jpg') &&
            !profilePicUrl.contains('.png') &&
            !profilePicUrl.contains('.jpeg'))) {
      return AssetImage(userImage);
    }

    try {
      return NetworkImage(profilePicUrl);
    } catch (e) {
      return AssetImage(userImage);
    }
  }

  // This displays the user profile.

  Widget _buildProfileContent(UserProfileProvider profileProvider) {
    return Stack(
      children: [
        Column(
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        HomeScreen(onLogout: widget.onLogout),
                              ),
                            );
                          },
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
                                child: Image.asset(user, fit: BoxFit.contain),
                              ),
                              SizedBox(width: 14.w),
                              Flexible(
                                child: Text(
                                  'Prófíll',
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

            // Body
            profileProvider.errorMessage.isNotEmpty
                ? Center(child: Text('No profile data available'))
                : Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                image: _getProfileImage(profileProvider),
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

                        Text(
                          '${profileProvider.userProfile?.firstName ?? ''} '
                          '${profileProvider.userProfile?.lastName ?? ''}',
                          style: userNameTextStyle,
                        ),

                        SizedBox(height: 12.h),

                        // User Details
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              width: 1,
                              color: Color(0xFFD9D9D9),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow(
                                user,
                                profileProvider.userProfile?.firstName ?? '',
                              ),
                              _buildDetailRow(
                                user,
                                profileProvider.userProfile?.lastName ?? '',
                              ),
                              _buildDetailRow(
                                email,
                                profileProvider.userProfile?.email ?? '',
                              ),
                              _buildDetailRow(
                                phone,
                                profileProvider.userProfile?.telephoneNo ?? '',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15.h),

                        CustomElevatedButton(
                          text: "Breyta prófíl",
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        CustomElevatedButton(
                          text: "Breyta lykilorði",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ChangePasswordScreen(
                                      onLogout: widget.onLogout,
                                    ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        CustomElevatedButton(
                          text: "Skráðu þig út",
                          onPressed: logout,
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
        if (profileProvider.isLoading) Positioned.fill(child: loadingAnimation),
      ],
    );
  }

  // This custom widget displays an image and a title in Row
  Widget _buildDetailRow(String imagepath, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagepath, width: 24.w, height: 24.h),
          SizedBox(width: 16.w),
          Expanded(child: Text(value, style: profiletitleTextStyle)),
        ],
      ),
    );
  }
}
