import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/repository/user_profile_helper.dart';
import 'package:hsi/view/Favourite_club/add_favourite_teams_screen.dart';
import '../../Model/club_partner_list_model.dart';
import '../../repository/club_partner_list_helper.dart';

class AddToFavouritesScreen extends StatefulWidget {
  final int? clubId;
  final String? image;

  const AddToFavouritesScreen({super.key, this.clubId, this.image});

  @override
  State<AddToFavouritesScreen> createState() => _AddToFavouritesScreenState();
}

class _AddToFavouritesScreenState extends State<AddToFavouritesScreen> {
  List<ClubPartner> _clubPartners = [];
  List<int> _favoriteClubIds = [];
  bool _isLoading = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUserProfile();
    await _loadClubPartners();
  }

  Future<void> _loadUserProfile() async {
    try {
      final response = await UserProfileApi.fetchUserProfile();
      setState(() {
        _favoriteClubIds =
            response.data.favouriteClubs.map((club) => club.clubId).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading user profile: $e')));
    }
  }

  Future<void> _loadClubPartners() async {
    setState(() => _isLoading = true);
    try {
      final response = await ClubPartnerApi.fetchClubPartners();
      setState(() {
        _clubPartners =
            response.data
                .where((club) => !_favoriteClubIds.contains(club.clubId))
                .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading club partners: $e'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              HeaderWidget(
                title: 'Aðildarfélög HSÍ',
                logoPath: clubScreenLogo,
                onBackPressed: () => Navigator.pop(context, true),
                backgroundColor: appBarColor,
                textStyle: appBarTextStyle.copyWith(fontSize: 20.sp),
              ),
              Expanded(
                child:
                    _clubPartners.isEmpty
                        ? Center(child: Text(""))
                        : CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                top: 8.h,
                                bottom: 8.h,
                              ),
                              sliver: SliverList(
                                delegate: SliverChildListDelegate([
                                  Text(
                                    "Veldu uppáhaldsklúbbana þína",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E1E1E),
                                      fontFamily: 'Poppins',
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ]),
                              ),
                            ),

                            SliverPadding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              sliver: SliverGrid(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final club = _clubPartners[index];
                                  return _leagueTile(
                                    club,
                                    MediaQuery.of(context).size.height,
                                    MediaQuery.of(context).size.width,
                                    index,
                                  );
                                }, childCount: _clubPartners.length),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          MediaQuery.of(context).size.width >
                                                  600
                                              ? 3
                                              : 2,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 10,
                                    ),
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),

          if (_isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  Widget _leagueTile(
    ClubPartner club,
    double screenHeight,
    double screenWidth,
    int index,
  ) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AddToFavouritesTeamsScreen(
                  clubId: club.clubId,
                  image: club.image,
                  clubName: club.name,
                ),
          ),
        );
        setState(() {
          selectedIndex = isSelected ? null : index;
        });
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected ? selectedCart : unselectedCart,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Center(
                  child: Container(
                    height: 55.h,
                    width: 55.w,
                    child: Image.network(club.image, fit: BoxFit.contain),
                  ),
                ),
                SizedBox(height: screenHeight * 0.020),
                Text(
                  club.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                share,
                width: 24.w,
                height: 24.h,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final String logoPath;
  final VoidCallback onBackPressed;
  final Color backgroundColor;
  final TextStyle textStyle;

  const HeaderWidget({
    super.key,
    required this.title,
    required this.logoPath,
    required this.onBackPressed,
    required this.backgroundColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104.h,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.r),
          bottomLeft: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: IconButton(
                  onPressed: onBackPressed,
                  icon: Image.asset(backArrow, height: 34.h, width: 80.w),
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
                        child: Image.asset(logoPath, fit: BoxFit.contain),
                      ),
                      SizedBox(width: 14.w),
                      Flexible(
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: textStyle,
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
    );
  }
}
