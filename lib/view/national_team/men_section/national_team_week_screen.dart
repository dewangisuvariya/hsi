import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../custom/national_team_week.dart';
import '../../../repository/national_team_category_helper.dart';

// load national team week men details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class NationalTeamWeeksScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String? type;

  const NationalTeamWeeksScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    this.type,
  }) : super(key: key);

  @override
  State<NationalTeamWeeksScreen> createState() =>
      _NationalTeamWeeksScreenState();
}

class _NationalTeamWeeksScreenState extends State<NationalTeamWeeksScreen> {
  List<NationalTeamWeek> nationalTeamWeeks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchNationalTeamWeeksData();
  }

  // Load data from the NationalTeamCategoryHelper class via the web service.
  Future<void> _fetchNationalTeamWeeksData() async {
    try {
      final response = await NationalTeamDetailsApi.fetchNationalTeamDetails(
        id: widget.teamId,
        type: widget.type ?? 'nationalTeamWeeks',
      );

      if (mounted) {
        setState(() {
          if (response.success && response.nationalTeamWeeks.isNotEmpty) {
            nationalTeamWeeks = response.nationalTeamWeeks;
          } else {
            errorMessage = 'No national team weeks data available.';
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Failed to load data: $e';
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
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
              CustomAppBarSubScreen(
                title: widget.teamName,
                imagePath: widget.teamImage,
              ),
              Expanded(
                child:
                    isLoading
                        ? Center(child: loadingAnimation)
                        : errorMessage != null
                        ? Center(
                          child: Text(
                            "",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        )
                        : UniversalListContainer(
                          // This method is from the custom class for National Team Week
                          title: "A landslið karla",
                          items:
                              nationalTeamWeeks
                                  .map(
                                    (week) => {
                                      'imageUrl': week.image,
                                      'title': week.name,
                                      'subtitles': [
                                        '${week.startDate} - ${week.endDate}',
                                      ],
                                    },
                                  )
                                  .toList(),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
