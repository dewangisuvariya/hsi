import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/repository/add_favourite_club_helper.dart';
import 'package:hsi/Model/team_list_model.dart';
import 'package:hsi/repository/team_list_helper.dart';

// load Favorites Teams list details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class AddToFavouritesTeamsScreen extends StatefulWidget {
  final int? clubId;
  final String? image;
  final String? clubName;

  const AddToFavouritesTeamsScreen({
    super.key,
    this.clubId,
    this.image,
    this.clubName,
  });

  @override
  State<AddToFavouritesTeamsScreen> createState() =>
      _AddToFavouritesTeamsScreenState();
}

class _AddToFavouritesTeamsScreenState
    extends State<AddToFavouritesTeamsScreen> {
  List<MasterTeam> _teams = [];
  List<int> _selectedTeamIds = [];
  bool _isLoading = false;
  String _selectedCategory = "All";
  bool _selectAll = false;
  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  // Load data from the TeamListHelper class via the web service.
  Future<void> _loadTeams() async {
    if (widget.clubId == null) return;

    setState(() => _isLoading = true);
    try {
      final response = await MasterTeamApi.fetchMasterTeams(widget.clubId!);
      setState(() {
        _teams = response.masterTeams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading teams: $e')));
    }
  }

  // Call the addFavoriteClubHelper class via the web service when the user adds a club to favorites
  Future<void> _saveFavorites() async {
    if (_selectedTeamIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one team')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await FavoriteClubApi.addFavoriteClub(
        clubId: widget.clubId!,
        teamIds: _selectedTeamIds,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      if (response.success) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving favorites: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Toggle function: if the user has a favorite team, remove it; if the team is not in favorites, add it
  void _toggleSelectAll(bool? newValue) {
    if (newValue == null) return;

    setState(() {
      _selectAll = newValue;
      if (_selectAll) {
        // Select all teams in current filtered view
        _selectedTeamIds = _filteredTeams.map((team) => team.id).toList();
      } else {
        // Deselect all teams
        _selectedTeamIds.clear();
      }
    });
  }

  // Update this method to handle team selection changes
  // void _onTeamSelectionChanged(MasterTeam team, bool isSelected) {
  //   setState(() {
  //     if (isSelected) {
  //       _selectedTeamIds.add(team.id);
  //     } else {
  //       _selectedTeamIds.remove(team.id);
  //     }
  //     // Update Select All checkbox state
  //     _selectAll = _selectedTeamIds.length == _filteredTeams.length;
  //   });
  // }

  // If the user selects the 'All' button, then select all teams and add them to the favorites list
  List<MasterTeam> get _filteredTeams {
    if (_selectedCategory == "All") return _teams;
    return _teams
        .where((team) => team.teamName.startsWith(_selectedCategory))
        .toList();
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
              CustomAppBarSubScreen(
                title: widget.clubName ?? "",
                imagePath: widget.image ?? "",
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
                                      color: Color(0xFF1E1E1E),
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
                                          activeColor:
                                              Colors
                                                  .blue, // Customize as needed
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "Allt",
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins',
                                          color: Color(0XFF1E1E1E),
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
                                        _filteredTeams.map((team) {
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
                                                    color: Color(0xFF292929),
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
                                                    });
                                                  },
                                                ),
                                              ),
                                              if (_filteredTeams.indexOf(
                                                    team,
                                                  ) !=
                                                  _filteredTeams.length - 1)
                                                Divider(
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
                                onPressed: _saveFavorites,
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
