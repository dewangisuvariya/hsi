import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/team_list_model.dart';
import 'package:hsi/Model/user_profile_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/repository/team_list_helper.dart';
import 'package:hsi/repository/toggle_favourite_team_helper.dart';
import '../../repository/user_profile_helper.dart';

// load Toggle Favourite team details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class ToggleFavouriteTeamScreen extends StatefulWidget {
  final int? clubId;
  final String? title;
  final String? image;

  const ToggleFavouriteTeamScreen({
    super.key,
    required this.clubId,
    required this.title,
    required this.image,
  });

  @override
  State<ToggleFavouriteTeamScreen> createState() =>
      _ToggleFavouriteTeamScreenState();
}

class _ToggleFavouriteTeamScreenState extends State<ToggleFavouriteTeamScreen> {
  List<MasterTeam> _allTeams = [];
  List<int> _selectedTeamIds = [];
  bool _isLoading = false;
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  // Load data from the TeamListHelper class via the web service.

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      // Fetch master teams for this club
      final masterTeamsResponse = await MasterTeamApi.fetchMasterTeams(
        widget.clubId!,
      );

      // Fetch user profile to get already selected teams
      final userProfile = await UserProfileApi.fetchUserProfile();

      // Find the current club in user's favourite clubs
      final currentClub = userProfile.data.favouriteClubs.firstWhere(
        (club) => club.clubId == widget.clubId,
        orElse:
            () => FavouriteClub(
              clubId: widget.clubId!,
              clubName: '',
              clubImage: '',
              favouriteTeams: [],
            ),
      );

      setState(() {
        _allTeams = masterTeamsResponse.masterTeams;
        _selectedTeamIds =
            currentClub.favouriteTeams.map((t) => t.teamId).toList();
        _selectAll = _selectedTeamIds.length == _allTeams.length;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleSelectAll(bool? value) {
    if (value == null) return;

    setState(() {
      _selectAll = value;
      if (_selectAll) {
        _selectedTeamIds = _allTeams.map((team) => team.id).toList();
      } else {
        _selectedTeamIds.clear();
      }
    });
  }

  // When the user adds this team to the favorite team list, call the UserProfileHelper class via the web service
  Future<void> _saveSelectedTeams() async {
    setState(() => _isLoading = true);
    try {
      final userId = await UserProfileApi.getUserId();
      if (userId == null) throw Exception('User ID not found');

      final apiHelper = FavouriteTeamApiHelper();

      // First get current state from server to know which teams to toggle
      final userProfile = await UserProfileApi.fetchUserProfile();
      final currentClub = userProfile.data.favouriteClubs.firstWhere(
        (club) => club.clubId == widget.clubId,
        orElse:
            () => FavouriteClub(
              clubId: widget.clubId!,
              clubName: '',
              clubImage: '',
              favouriteTeams: [],
            ),
      );

      final currentTeamIds =
          currentClub.favouriteTeams.map((t) => t.teamId).toSet();
      final newTeamIds = _selectedTeamIds.toSet();

      // Teams to add (in new but not in current)
      final teamsToAdd = newTeamIds.difference(currentTeamIds);
      // Teams to remove (in current but not in new)
      final teamsToRemove = currentTeamIds.difference(newTeamIds);

      // Toggle all teams that need changing
      for (final teamId in teamsToAdd) {
        await apiHelper.toggleFavouriteTeam(
          userId: userId,
          clubId: widget.clubId!,
          teamId: teamId,
        );
      }

      for (final teamId in teamsToRemove) {
        await apiHelper.toggleFavouriteTeam(
          userId: userId,
          clubId: widget.clubId!,
          teamId: teamId,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Favourite teams updated successfully')),
      );

      // Fetch the updated user profile to get the latest teams
      final updatedProfile = await UserProfileApi.fetchUserProfile();
      final updatedClub = updatedProfile.data.favouriteClubs.firstWhere(
        (club) => club.clubId == widget.clubId,
        orElse:
            () => FavouriteClub(
              clubId: widget.clubId!,
              clubName: '',
              clubImage: '',
              favouriteTeams: [],
            ),
      );

      // Navigate back with the updated teams
      Navigator.pop(context, updatedClub.favouriteTeams);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving teams: $e')));
      Navigator.pop(context); // Just go back without data if there's an error
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // create structure of the screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
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
                                  width: 52.w,
                                  height: 36.h,
                                  child: Image.network(
                                    widget.image ?? "",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                Flexible(
                                  child: Text(
                                    widget.title ?? "",
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

              _isLoading
                  ? Container(color: Color(0xFFFAFAFA))
                  : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: 5.w,
                                right: 5.w,
                                bottom: 16.h,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Veldu uppáhaldsklúbbana þína",
                                    style: TextStyle(
                                      fontSize: 19.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF1E1E1E),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 26.w,
                                        height: 26.h,
                                        child: Checkbox(
                                          value: _selectAll,
                                          onChanged: _toggleSelectAll,
                                          activeColor: Colors.blue,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "Allt",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                          color: const Color(0XFF1E1E1E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: borderContainerDecoration,
                              child: Column(
                                children: [
                                  Column(
                                    children:
                                        _allTeams.map((team) {
                                          final isSelected = _selectedTeamIds
                                              .contains(team.id);
                                          return Column(
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      horizontal: 16.w,
                                                      vertical: 12.h,
                                                    ),
                                                leading: Image.network(
                                                  team.teamImage,
                                                  width: 50.w,
                                                  height: 50.h,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => Image.asset(
                                                        favourites,
                                                        width: 24.w,
                                                        height: 24.h,
                                                      ),
                                                ),
                                                title: Text(
                                                  team.teamName,
                                                  style: TextStyle(
                                                    fontSize: 17.sp,
                                                    color: const Color(
                                                      0xFF292929,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),
                                                trailing: IconButton(
                                                  icon:
                                                      isSelected
                                                          ? Image.asset(
                                                            favourites,
                                                            width: 39.w,
                                                            height: 39.h,
                                                          )
                                                          : Image.asset(
                                                            unfavourites,
                                                            width: 39.w,
                                                            height: 39.h,
                                                          ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (isSelected) {
                                                        _selectedTeamIds.remove(
                                                          team.id,
                                                        );
                                                      } else {
                                                        _selectedTeamIds.add(
                                                          team.id,
                                                        );
                                                      }
                                                      _selectAll =
                                                          _selectedTeamIds
                                                              .length ==
                                                          _allTeams.length;
                                                    });
                                                  },
                                                ),
                                              ),
                                              if (_allTeams.indexOf(team) !=
                                                  _allTeams.length - 1)
                                                const Divider(
                                                  height: 0.5,
                                                  thickness: 1,
                                                  color: Color(0xFFE6E6E6),
                                                ),
                                            ],
                                          );
                                        }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: _saveSelectedTeams,
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(166.w, 54.h),
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
                                    Image.asset(
                                      saveButton,
                                      width: 26.w,
                                      height: 26.h,
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "Save",
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
                            ),
                          ],
                        ),
                      ),
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
}
