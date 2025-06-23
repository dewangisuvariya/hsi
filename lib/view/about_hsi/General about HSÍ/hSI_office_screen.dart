import 'package:flutter/material.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/national_team_week.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/provider/BackgroundColorProvider.dart';
import 'package:hsi/repository/fecth_about_hsi_details_helper.dart';
import 'package:provider/provider.dart';
// load  Office details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class HsiOfficeScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;
  const HsiOfficeScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<HsiOfficeScreen> createState() => _HsiOfficeScreenState();
}

class _HsiOfficeScreenState extends State<HsiOfficeScreen> {
  bool isLoading = true;
  AboutHsiData? _data;
  HeadingDetails? _heading;
  String? errorMessage;
  List<OfficeDetail> officeDetail = [];
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
          _data = response.data;
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
                          title: _heading?.heading ?? "Upplýsingar",
                          subtitle: _heading?.subHeading ?? "Upplýsingar",
                          items:
                              _data!.officeDetails
                                  .map(
                                    (detail) => {
                                      'imageUrl': detail.image,
                                      'title': detail.title,
                                      'subtitles': [detail.description],
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
