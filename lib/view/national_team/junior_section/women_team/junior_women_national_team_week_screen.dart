import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import '../../../../Model/junior_national_team_week_model.dart';
import '../../../../custom/custom_appbar_subscreen.dart';
import '../../../../repository/junior_national_team_week_helper.dart';
import 'package:provider/provider.dart';
// load junior women national team week details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class JuniorWomenNationalTeamWeekScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;

  const JuniorWomenNationalTeamWeekScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
  }) : super(key: key);

  @override
  _JuniorWomenNationalTeamWeekScreenState createState() =>
      _JuniorWomenNationalTeamWeekScreenState();
}

class _JuniorWomenNationalTeamWeekScreenState
    extends State<JuniorWomenNationalTeamWeekScreen> {
  JuniorTeamResponse? _teamData;
  bool _isLoading = true;
  String _errorMessage = '';
  final Map<int, bool> _expandedTeams = {};
  final JuniorTeamApiHelper _apiHelper = JuniorTeamApiHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from the JuniorNationalTeamWeekHelper class via the web service.
  Future<void> _loadData() async {
    try {
      final data = await _apiHelper.fetchJuniorTeamData(widget.teamId);
      setState(() {
        _teamData = data;
        _isLoading = false;
        for (var team in data.teams) {
          _expandedTeams[team.id] = false;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load data: $e';
        });
        showNetworkErrorDialog(context);
      }
    }
  }

  // Toggle the container: open it when the user selects it, and close it if it's already open and selected again.
  void _toggleTeamExpansion(int teamId) {
    setState(() {
      _expandedTeams[teamId] = !_expandedTeams[teamId]!;
    });
  }

  // create structure of the screen
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
                title: widget.teamName,
                imagePath: widget.teamImage,
              ),
              Expanded(child: _buildContent()),
            ],
          ),
          if (_isLoading)
            Positioned.fill(child: Center(child: loadingAnimation)),
        ],
      ),
    );
  }

  // Display the national team, and when the user presses the down button, show the team details
  Widget _buildContent() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "",
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_teamData == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_teamData!.weekHeadings.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _teamData!.weekHeadings.first.heading,
                    style: weekTeamHeadingTextStyle,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    _teamData!.weekHeadings.first.description,
                    style: weekTeamHeadingTextStyle,
                  ),
                ],
              ),
            ),
          SizedBox(height: 16.h),

          if (_teamData!.teams.isEmpty)
            const Center(
              child: Padding(padding: EdgeInsets.all(16.0), child: Text('')),
            )
          else
            Container(
              decoration: borderContainerDecoration,
              child: Column(
                children: List.generate(_teamData!.teams.length, (index) {
                  final team = _teamData!.teams[index];
                  final isFirst = index == 0;
                  final isLast = index == _teamData!.teams.length - 1;

                  return Container(
                    decoration: BoxDecoration(
                      border: Border.symmetric(
                        horizontal: BorderSide.none,
                        vertical: BorderSide(color: unselectedCart, width: 1.0),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: isFirst ? Radius.circular(8.r) : Radius.zero,
                        topRight: isFirst ? Radius.circular(8.r) : Radius.zero,
                        bottomLeft: isLast ? Radius.circular(8.r) : Radius.zero,
                        bottomRight:
                            isLast ? Radius.circular(8.r) : Radius.zero,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 10.h),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft:
                                    isFirst
                                        ? Radius.circular(8.r)
                                        : Radius.zero,
                                topRight:
                                    isFirst
                                        ? Radius.circular(8.r)
                                        : Radius.zero,
                                bottomLeft:
                                    isLast ? Radius.circular(8.r) : Radius.zero,
                                bottomRight:
                                    isLast ? Radius.circular(8.r) : Radius.zero,
                              ),
                              color: unselectedCart,
                            ),
                            child: ListTile(
                              title: Text(
                                team.tournamentName,
                                style: nameOfTournamentTextStyle,
                              ),
                              trailing: GestureDetector(
                                onTap: () => _toggleTeamExpansion(team.id),
                                child: SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: Image.asset(
                                    _expandedTeams[team.id] == true
                                        ? rightUp
                                        : arrowDown,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_expandedTeams[team.id] == true)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16.0,
                              bottom: 16.0,
                            ),
                            child: _buildTeamContent(team),
                          ),
                        Divider(height: 1, color: unselectedCart),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  // Custom widget for displaying the _buildWeekTile within this
  Widget _buildTeamContent(Team team) {
    return Column(
      children: [
        if (team.juniorTeamWeeks.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(bottom: 8.0, top: 8.0)),
              ...team.juniorTeamWeeks
                  .map((week) => _buildWeekTile(week))
                  .toList(),
            ],
          ),

        if (team.coaches.isEmpty && team.juniorTeamWeeks.isEmpty)
          const Padding(padding: EdgeInsets.all(16.0), child: Text('')),
      ],
    );
  }

  // This widget displays the team data
  Widget _buildWeekTile(JuniorTeamWeek week) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          week.image.isNotEmpty
              ? Container(
                width: 40.w,
                height: 40.h,
                margin: EdgeInsets.only(right: 12),
                child: Image.network(
                  week.image,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => const Icon(Icons.error),
                ),
              )
              : const Icon(Icons.error, size: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(week.duration, style: planningTextStyle),
                SizedBox(height: 4.h),
                Text(week.planning, style: durationTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
