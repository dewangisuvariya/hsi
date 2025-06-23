import 'package:flutter/material.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/national_team_week.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/fecth_about_hsi_details_helper.dart';
import 'package:provider/provider.dart';
// load Chairmen since the founding of HSÍ details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class ChairmenSinceTheFoundingOfHsiScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const ChairmenSinceTheFoundingOfHsiScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<ChairmenSinceTheFoundingOfHsiScreen> createState() =>
      _ChairmenSinceTheFoundingOfHsiScreenState();
}

class _ChairmenSinceTheFoundingOfHsiScreenState
    extends State<ChairmenSinceTheFoundingOfHsiScreen> {
  bool isLoading = true;
  HeadingDetails? _heading;
  String? errorMessage;
  List<ChairmanDetail> chairmanDetail = [];
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data from the FetchAboutHsiDetailsHelper class via the web service.
  Future<void> _loadData() async {
    try {
      final response = await AboutHsiDetailsHelper.fetchAboutHsiDetails(
        widget.subSectionId,
      );

      if (mounted) {
        setState(() {
          chairmanDetail = response.data.chairmanDetails;
          _heading = response.data.headingDetails;
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
    final backgroundColorProvider = Provider.of<BackgroundColorProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      backgroundColorProvider.updateBackgroundColor(const Color(0xFFFAFAFA));
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBarSubScreen(
                title: widget.name,
                imagePath: widget.image,
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
                              _heading?.heading ??
                              "Hér að neðan má sjá lista yfir formenn HSÍ frá upphafi:",

                          items:
                              chairmanDetail
                                  .map(
                                    (detail) => {
                                      'imageUrl': detail.image,
                                      'title': detail.chairmanName,
                                      'subtitles': [detail.chairmanDetails],
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
