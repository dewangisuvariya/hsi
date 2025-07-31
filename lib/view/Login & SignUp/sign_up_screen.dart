import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/club_partner_list_model.dart';
import 'package:hsi/Model/sign_up_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_elevated_button_widget.dart';
import 'package:hsi/custom/custom_password_text_from_field.dart';
import 'package:hsi/custom/custom_text_form_field.dart';
import 'package:hsi/repository/club_partner_list_helper.dart';
import 'package:hsi/repository/sign_up_helper.dart';
import 'package:hsi/view/Login%20&%20SignUp/email_verification_otp_screen.dart';
import 'package:hsi/view/Login%20&%20SignUp/sign_in_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<_ClubPartnerDropdownState> _clubDropdownKey =
      GlobalKey<_ClubPartnerDropdownState>();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _surNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _favouriteClubController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  // Pick an image from the user's gallery and compress the selected image
  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080, // Limits image width to reduce memory usage
        maxHeight: 1080, // Limits image height
        imageQuality: 85, // Initial quality reduction
      );

      if (pickedFile == null) return; // User canceled the picker

      // Log original image info
      final originalFile = File(pickedFile.path);
      final originalSize = await originalFile.length();
      debugPrint(
        'Original image size: ${(originalSize / (1024 * 1024)).toStringAsFixed(2)} MB',
      );

      // Compress the image further if needed
      final dir = await getTemporaryDirectory();
      final targetPath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        targetPath,
        quality: 80, // Further quality reduction
        minWidth: 540, // Minimum width
        minHeight: 540, // Minimum height
        rotate: 0, // No rotation
        format: CompressFormat.jpeg, // Output format
      );

      if (compressedFile != null) {
        final compressedSize = await compressedFile.length();
        debugPrint(
          'Compressed image size: ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB',
        );

        setState(() {
          _profileImage = File(compressedFile.path);
        });
      } else {
        // Fallback to original if compression fails
        setState(() {
          _profileImage = originalFile;
        });
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      // Optionally show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to select image: ${e.toString()}')),
      );
    }
  }

  // Sign up the user with the help of the SignUpHelper class via the web service
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final selectedClubIds =
          _clubDropdownKey.currentState?.getSelectedClubIds() ?? [];
      final request = RegisterUserRequest(
        firstName: _firstNameController.text,
        lastName: _surNameController.text,
        email: _emailController.text,
        telephoneNo: _phoneController.text,
        favouriteClub: selectedClubIds.join(','),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        profilePic: _profileImage,
      );

      final response = await UserApi.registerUser(request);

      if (response.success) {
        // Show success SnackBar
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', response.data?['user_id'] ?? 0);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    EmailVerificationOtpScreen(email: _emailController.text),
          ),
        );
      } else {
        // Show error SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 104.h,
                  decoration: BoxDecoration(
                    color: appBarColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
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
                        ),

                        Expanded(
                          flex: 12,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              //  color: Colors.green,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.h,
                                    child: Image.asset(
                                      appbar,
                                      fit: BoxFit.contain,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return errorImageContainer();
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 13.w),
                                  Flexible(
                                    child: Text(
                                      'Skráning',
                                      textAlign: TextAlign.center,
                                      style: appBarTextStyle.copyWith(
                                        fontSize: 20.sp,
                                      ),
                                      overflow: TextOverflow.visible,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Expanded(flex: 2, child: Container()),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 5.h),

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
                                    image:
                                        _profileImage != null
                                            ? FileImage(_profileImage!)
                                            : AssetImage(userImage)
                                                as ImageProvider,
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
                                onTap: () {
                                  _pickImage();
                                  print("Edit button tapped");
                                },
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

                        SizedBox(height: 15.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              CustomTextField(
                                hintText: "Fornafn*",
                                iconPath: user,
                                controller: _firstNameController,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 18.h),
                              CustomTextField(
                                hintText: "Eftirnafn*",
                                iconPath: user,
                                controller: _surNameController,
                                keyboardType: TextInputType.text,
                              ),
                              SizedBox(height: 18.h),
                              CustomTextField(
                                hintText: "Tölvupóstur*",
                                iconPath: email,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              SizedBox(height: 18.h),
                              CustomTextField(
                                hintText: "Símanúmer*",
                                iconPath: phone,
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(height: 18.h),
                              ClubPartnerDropdown(
                                key: _clubDropdownKey,
                                controller: _favouriteClubController,
                              ),
                              SizedBox(height: 18.h),
                              CustomPasswordField(
                                hintText: "Lykilorð*",
                                iconPath: lock,
                                controller: _passwordController,
                              ),
                              SizedBox(height: 18.h),
                              CustomPasswordField(
                                hintText: "Staðfesta lykilorð*",
                                iconPath: lock,
                                controller: _confirmPasswordController,
                              ),

                              SizedBox(height: 53.h),

                              CustomElevatedButton(
                                text: "Næst",
                                onPressed: _submitForm,
                              ),
                              SizedBox(height: 33.h),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: subTitleColor,
                                    fontFamily: "Poppins",
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "Ertu nú þegar með aðgang?  ",
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) => SignInScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Innskráning",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: selectedDividerColor,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 33.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              Positioned.fill(child: Center(child: loadingAnimation)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _favouriteClubController.dispose();
    super.dispose();
  }
}

// Display a dropdown for the user to select a favorite club and add it to the list
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ClubPartnerDropdown extends StatefulWidget {
  final TextEditingController controller;

  const ClubPartnerDropdown({Key? key, required this.controller})
    : super(key: key);

  @override
  _ClubPartnerDropdownState createState() => _ClubPartnerDropdownState();
}

class _ClubPartnerDropdownState extends State<ClubPartnerDropdown> {
  List<ClubPartner> _clubPartners = [];
  List<int> _selectedClubIds = [];
  bool _isLoading = false;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _loadClubPartners();
  }

  // Load data from the ClubPartnerListHelper class via the web service.
  Future<void> _loadClubPartners() async {
    setState(() => _isLoading = true);
    try {
      final response = await ClubPartnerApi.fetchClubPartners();
      setState(() {
        _clubPartners = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading club partners: $e')),
      );
    }
  }

  void _toggleDropdown() {
    setState(() => _isDropdownOpen = !_isDropdownOpen);
  }

  void _toggleSelection(int index) {
    setState(() {
      _clubPartners[index].isSelected = !_clubPartners[index].isSelected;

      // Update selected club IDs
      if (_clubPartners[index].isSelected) {
        _selectedClubIds.add(_clubPartners[index].clubId);
      } else {
        _selectedClubIds.remove(_clubPartners[index].clubId);
      }

      // Update the controller text with selected clubs (for UI only)
      final selectedClubs = _clubPartners
          .where((club) => club.isSelected)
          .map((club) => club.name)
          .join(', ');
      widget.controller.text = selectedClubs;
    });
  }

  List<int> getSelectedClubIds() => _selectedClubIds;
  // create structure of the screen

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text field showing selected clubs
        Container(
          height: 51.h,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 17.w),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: subTitleColor),

            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: TextFormField(
              controller: widget.controller,
              readOnly: true,

              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Image.asset(club),
                ),

                hintText: 'Uppáhaldsklúbbur*',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: subTitleColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
                suffixIcon: IconButton(
                  icon: Image.asset(down, width: 50.w, height: 50.h),
                  onPressed: _toggleDropdown,
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
              onTap: _toggleDropdown,
            ),
          ),
        ),

        // Dropdown content
        if (_isDropdownOpen && !_isLoading) ...[
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                children:
                    _clubPartners.asMap().entries.map((entry) {
                      final index = entry.key;
                      final club = entry.value;
                      return GestureDetector(
                        onTap: () => _toggleSelection(index),
                        child: Column(
                          children: [
                            Container(
                              color:
                                  club.isSelected
                                      ? selectLeagueTileColor
                                      : Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  // Club name
                                  Text(
                                    club.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
