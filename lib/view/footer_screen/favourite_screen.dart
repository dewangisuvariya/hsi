import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/repository/remove_favourite_club_helper.dart';
import 'package:hsi/view/Favourite_club/add_to_favourites_screen.dart';
import 'package:hsi/view/Favourite_club/favourite_teams_screen.dart';
import 'package:hsi/Model/user_profile_model.dart';
import '../../custom/custom_appbar.dart';

// load Favorite Club list details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>
    with WidgetsBindingObserver {
  List<FavouriteClub> _favoriteClubs = [];
  int? selectedIndex;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadFavoriteClubs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground
      _loadFavoriteClubs();
    }
  }

  // Load data from the RemoveFavoriteClubHelper class via the web service.
  Future<void> _loadFavoriteClubs() async {
    setState(() => _isLoading = true);
    try {
      final response = await UserProfileApi.fetchUserProfile();
      if (response.success) {
        setState(() {
          _favoriteClubs = response.data.favouriteClubs;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorite clubs: $e')),
      );
    }
  }

  Future<void> _navigateToSubScreen(int index) async {
    if (index < 0 || index >= _favoriteClubs.length) return;

    final club = _favoriteClubs[index];
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FavouriteTeamsScreen(
              clubId: club.clubId,
              title: club.clubName,
              image: club.clubImage,
              teams: club.favouriteTeams,
            ),
      ),
    );

    if (result == true && mounted) {
      _loadFavoriteClubs();
    }
  }

  // Load data from the RemoveFavoriteClubHelper class via the web service.
  void _removeFromFavorites(FavouriteClub club, int index) async {
    try {
      setState(() => _isLoading = true);

      final response = await UserProfileApi.removeFavoriteClub(club.clubId);

      if (response.success) {
        setState(() {
          _favoriteClubs.removeAt(index);
          if (selectedIndex == index) selectedIndex = null;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to remove: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // create structure of the screen
  // @override
  // Widget build(BuildContext context) {
  //   // final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
  //   //   context,
  //   //   listen: true,
  //   // );

  //   final screenHeight = MediaQuery.of(context).size.height;
  //   final screenWidth = MediaQuery.of(context).size.width;

  //   return Scaffold(
  //     backgroundColor: backgroundColor,
  //     body: Container(
  //       child: Stack(
  //         children: [
  //           Column(
  //             children: [
  //               CustomAppBar(title: "Uppáhalds", imagePath: favourite),
  //               Expanded(
  //                 child:
  //                     _isLoading
  //                         ? Center(child: loadingAnimation)
  //                         : _favoriteClubs.isEmpty
  //                         ? Center(child: Text("No favorite clubs found"))
  //                         : _leagueList(screenHeight, screenWidth),
  //               ),
  //             ],
  //           ),
  //           Positioned(
  //             bottom: 16.h,
  //             left: 0,
  //             right: 0,
  //             child: Center(
  //               child: ElevatedButton(
  //                 onPressed: () async {
  //                   final result = await Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => AddToFavouritesScreen(),
  //                     ),
  //                   );

  //                   if (result == true && mounted) {
  //                     _loadFavoriteClubs();
  //                   }
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   fixedSize: Size(250.w, 54.h),
  //                   backgroundColor: appBarColor,
  //                   foregroundColor: Colors.black,
  //                   elevation: 0,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(29.r),
  //                   ),
  //                 ),
  //                 child: Row(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Image.asset(favouritesIcon, width: 26.w, height: 26.h),
  //                     SizedBox(width: 10.w),
  //                     Text(
  //                       "Bæta við uppáhalds",
  //                       style: TextStyle(
  //                         fontSize: 16.sp,
  //                         fontWeight: FontWeight.w500,
  //                         fontFamily: "Poppins",
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // @override
  // Widget build(BuildContext context) {
  //   final screenHeight = MediaQuery.of(context).size.height;
  //   final screenWidth = MediaQuery.of(context).size.width;

  //   final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
  //   final itemsPerRow = crossAxisCount;
  //   final hasLessThanTwoRows = _favoriteClubs.length <= itemsPerRow * 2;
  //   return Scaffold(
  //     backgroundColor: backgroundColor,
  //     body: Column(
  //       children: [
  //         CustomAppBar(title: "Uppáhalds", imagePath: favourite),
  //         Expanded(
  //           child:
  //               _isLoading
  //                   ? Center(child: loadingAnimation)
  //                   : _favoriteClubs.isEmpty
  //                   ? Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text("No favorite clubs found"),
  //                       SizedBox(height: 20.h),
  //                       _buildAddButton(),
  //                     ],
  //                   )
  //                   : CustomScrollView(
  //                     slivers: [
  //                       SliverPadding(
  //                         padding: EdgeInsets.symmetric(
  //                           horizontal: 12.w,
  //                           vertical: 8.h,
  //                         ),
  //                         sliver: SliverGrid(
  //                           delegate: SliverChildBuilderDelegate((
  //                             context,
  //                             index,
  //                           ) {
  //                             final club = _favoriteClubs[index];
  //                             return _leagueTile(
  //                               club,
  //                               screenHeight,
  //                               screenWidth,
  //                               index,
  //                             );
  //                           }, childCount: _favoriteClubs.length),
  //                           gridDelegate:
  //                               SliverGridDelegateWithFixedCrossAxisCount(
  //                                 crossAxisCount:
  //                                     MediaQuery.of(context).size.width > 600
  //                                         ? 3
  //                                         : 2,
  //                                 crossAxisSpacing: 5,
  //                                 mainAxisSpacing: 10,
  //                               ),
  //                         ),
  //                       ),
  //                       SliverToBoxAdapter(
  //                         child: Padding(
  //                           padding: EdgeInsets.symmetric(vertical: 16.h),
  //                           child: _buildAddButton(),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate if we have less than 2 rows of items
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    final itemsPerRow = crossAxisCount;
    final hasLessThanTwoRows = _favoriteClubs.length <= itemsPerRow * 2;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: "Uppáhalds", imagePath: favourite),
              Expanded(
                child:
                    _isLoading
                        ? Center(child: loadingAnimation)
                        : _favoriteClubs.isEmpty
                        ? Center(child: Text("No favorite clubs found"))
                        : CustomScrollView(
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 8.h,
                              ),
                              sliver: SliverGrid(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final club = _favoriteClubs[index];
                                  return _leagueTile(
                                    club,
                                    screenHeight,
                                    screenWidth,
                                    index,
                                  );
                                }, childCount: _favoriteClubs.length),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 10,
                                    ),
                              ),
                            ),
                            // Only show in SliverToBoxAdapter if more than 2 rows
                            if (!hasLessThanTwoRows)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: _buildAddButton(),
                                ),
                              ),
                          ],
                        ),
              ),
            ],
          ),
          // Show positioned button if less than 2 rows
          if (hasLessThanTwoRows && !_isLoading && _favoriteClubs.isNotEmpty)
            Positioned(
              bottom: 16.h,
              left: 0,
              right: 0,
              child: Center(child: _buildAddButton()),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddToFavouritesScreen()),
          );
          if (result == true && mounted) {
            _loadFavoriteClubs();
          }
        },
        style: ElevatedButton.styleFrom(
          fixedSize: Size(250.w, 54.h),
          backgroundColor: appBarColor,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(favouritesIcon, width: 26.w, height: 26.h),
            SizedBox(width: 10.w),
            Text(
              "Bæta við uppáhalds",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom GridView for displaying the club list
  Widget _leagueList(double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: GridView.builder(
        itemCount: _favoriteClubs.length,
        itemBuilder: (context, index) {
          final club = _favoriteClubs[index];
          return _leagueTile(club, screenHeight, screenWidth, index);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth > 600 ? 3 : 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }

  // The _leagueList GridView is a custom UI widget
  Widget _leagueTile(
    FavouriteClub club,
    double screenHeight,
    double screenWidth,
    int index,
  ) {
    bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = isSelected ? null : index;
        });
        _navigateToSubScreen(index);
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
                    child: Image.network(
                      club.clubImage,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return errorImageContainer();
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.020),
                Text(
                  club.clubName,
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
              onPressed:
                  () => _showDeleteConfirmationDialog(context, club, index),
              icon: Image.asset(
                delete,
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

  // When the user presses the delete button, show a delete confirmation dialog. If the user presses 'Yes', call the _removeFromFavorites method
  void _showDeleteConfirmationDialog(
    BuildContext context,
    FavouriteClub club,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: selectedCart,
          title: Image.asset(close, width: 60.w, height: 60.h),
          content: Text(
            textAlign: TextAlign.center,
            "Ertu viss um að þú viljir fjarlægja þessa vöru úr uppáhaldslistunum?",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    backgroundColor: Color(0xFF42a5ff),
                    foregroundColor: Colors.white,
                    minimumSize: Size(110.w, 32.h),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    _removeFromFavorites(club, index);
                  },
                  child: Text("Já"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    backgroundColor: Color(0xFFA0A0A0),
                    foregroundColor: Colors.white,
                    minimumSize: Size(110.w, 32.h),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text("Nei"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
