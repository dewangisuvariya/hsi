import 'package:flutter/material.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:provider/provider.dart';
import '../../../Model/national_team_category_model.dart';
import '../../../custom/custom_appbar_subscreen.dart';
import '../../../custom/national_team_week.dart';
import '../../../provider/BackgroundColorProvider.dart';
import '../../../repository/national_team_category_helper.dart';

// load coaches from beginning for women details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call
class CoachesFromBeginningWomenScreen extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String teamImage;
  final String? type;

  const CoachesFromBeginningWomenScreen({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.teamImage,
    this.type,
  }) : super(key: key);

  @override
  State<CoachesFromBeginningWomenScreen> createState() =>
      _CoachesFromBeginningWomenScreenState();
}

class _CoachesFromBeginningWomenScreenState
    extends State<CoachesFromBeginningWomenScreen> {
  List<Coach> coaches = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCoachesData();
  }

  // Load data from the NationalTeamCategoryHelper class via the web service.
  Future<void> _fetchCoachesData() async {
    try {
      final response = await NationalTeamDetailsApi.fetchNationalTeamDetails(
        id: widget.teamId,
        type: widget.type ?? 'coaches',
      );

      if (!mounted) return; // <- THIS IS KEY

      setState(() {
        if (response.success && response.coaches.isNotEmpty) {
          coaches = response.coaches;
        } else {
          errorMessage = 'No coaches data available.';
        }
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return; // <- ALSO HERE

      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
      showNetworkErrorDialog(context);
    }
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
                          title:
                              "Hér að neðan má sjá lista yfir landsliðsþjálfara A landslið kvenna frá upphafi:",
                          items:
                              coaches
                                  .map(
                                    (coach) => {
                                      'imageUrl': coach.image,
                                      'title': coach.name,
                                      'subtitles': [coach.year],
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
