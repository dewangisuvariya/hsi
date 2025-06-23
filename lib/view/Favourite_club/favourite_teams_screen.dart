import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/user_profile_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/view/Favourite_club/toggle_favourite_team_screen.dart';
import 'package:provider/provider.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
// load Favorite Teams details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class FavouriteTeamsScreen extends StatefulWidget {
  final int? clubId;
  final String? title;
  final String? image;
  final List<FavouriteTeam> teams;

  const FavouriteTeamsScreen({
    super.key,
    required this.clubId,
    required this.title,
    required this.image,
    required this.teams,
  });

  @override
  State<FavouriteTeamsScreen> createState() => _FavouriteTeamsScreenState();
}

class _FavouriteTeamsScreenState extends State<FavouriteTeamsScreen>
    with WidgetsBindingObserver {
  List<int> _selectedTeamIds = [];
  bool _isLoading = false;
  List<FavouriteTeam> _currentTeams = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentTeams = widget.teams;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update teams when parent widget updates
    if (widget.teams != _currentTeams) {
      setState(() {
        _currentTeams = widget.teams;
      });
    }
  }

  @override
  void didUpdateWidget(FavouriteTeamsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update teams when parent widget updates
    if (widget.teams != oldWidget.teams) {
      setState(() {
        _currentTeams = widget.teams;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backgroundColorProvider.updateBackgroundColor(backgroundColor);
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(
                title: widget.title ?? "",
                imagePath: widget.image ?? "",
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, right: 10.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Uppáhaldsliðin þín",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E1E1E),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  // Navigate to toggle screen and wait for result
                                  final updatedTeams =
                                      await Navigator.push<List<FavouriteTeam>>(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  ToggleFavouriteTeamScreen(
                                                    clubId: widget.clubId,
                                                    image: widget.image,
                                                    title: widget.title,
                                                  ),
                                        ),
                                      );

                                  // If we got updated teams back, update our state
                                  if (updatedTeams != null && mounted) {
                                    setState(() {
                                      _currentTeams = updatedTeams;
                                    });
                                  }
                                },
                                icon: Image.asset(
                                  edit,
                                  width: 24.w,
                                  height: 24.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: borderContainerDecoration,
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  _currentTeams.map((team) {
                                    // final isSelected = _selectedTeamIds
                                    //     .contains(team.teamId);
                                    return Column(
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 12.h,
                                          ),
                                          leading: Image.network(
                                            team.teamImage,
                                            width: 50.w,
                                            height: 50.h,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Image.asset(
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
                                            icon: Image.asset(
                                              favourites,
                                              width: 39.w,
                                              height: 39.h,
                                            ),
                                            onPressed:
                                                () => _toggleTeamSelection(
                                                  team.teamId,
                                                ),
                                          ),
                                        ),
                                        if (_currentTeams.indexOf(team) !=
                                            _currentTeams.length - 1)
                                          Divider(
                                            height: 0.5,
                                            thickness: 1,
                                            color: Color(0xFFE6E6E6),
                                          ),
                                      ],
                                    );
                                  }).toList(),
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

  // Toggle the favorite status of the team: add to favorites if not already, remove if it is
  void _toggleTeamSelection(int teamId) {
    setState(() {
      if (_selectedTeamIds.contains(teamId)) {
        _selectedTeamIds.remove(teamId);
      } else {
        _selectedTeamIds.add(teamId);
      }
    });
  }
}
