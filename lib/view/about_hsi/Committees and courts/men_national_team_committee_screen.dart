import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
// load Men's National Team Committee details from web server
// and display those within this screen
// from other class, data is passed to this screen via constructor call

class MenNationalTeamCommitteeScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const MenNationalTeamCommitteeScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<MenNationalTeamCommitteeScreen> createState() =>
      _MenNationalTeamCommitteeScreenState();
}

class _MenNationalTeamCommitteeScreenState
    extends State<MenNationalTeamCommitteeScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<CommitteeDetail> committeeDetail = [];
  List<CommitteeHeadingDetail> committeeHeadingDetail = [];
  List<DisciplinHeadingDetail> disciplinHeadingDetail = [];

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
          disciplinHeadingDetail = response.data.disciplinHeadingDetails;
          committeeHeadingDetail = response.data.committeeHeadingDetails;
          committeeDetail = response.data.committeeDetails;
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

  // When the user taps the button, the selected file (PDF, Word, or Excel) should launch in the appropriate viewer
  Future<void> _launchFile(String url) async {
    try {
      final fileName = url.split('/').last;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      final response = await Dio().download(url, filePath);

      if (response.statusCode == 200) {
        final result = await OpenFile.open(filePath);
        if (result.type != ResultType.done) {
          throw 'Could not open file.';
        }
      } else {
        throw 'Download failed.';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening file: ${e.toString()}')),
        );
      }
    }
  }

  // This displays the header paragraph of the screen

  Widget _buildCommitteeHeading(CommitteeHeadingDetail heading) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading.subHeading != null && heading.subHeading!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                heading.subHeading!,
                style: subtitleofAboutHsiTextStyle,
              ),
            ),
          if (heading.heading.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Text(heading.heading, style: titleBarTextStyle),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: selectedDividerColor, thickness: 1),
          ),
        ],
      ),
    );
  }

  // This method displays the list of HSI Committee Member
  Widget _buildCommitteeMember(CommitteeDetail member) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            child: Image.network(member.image, height: 30.h, width: 30),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name, style: titleOfCoachOrTeamTextStyle),
                if (member.details != null && member.details!.isNotEmpty)
                  Text(member.details!, style: TextStyle(fontSize: 14.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Displays the file list
  Widget _buildDisciplinaryHeading(CommitteeHeadingDetail heading) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: heading.documents.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final document = heading.documents[index];
              final fileName = document.file.split('/').last;
              final fileExtension = fileName.split('.').last.toLowerCase();
              final title = document.title;

              return ElevatedButton(
                onPressed: () => _launchFile(document.file),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pdfContainerColor,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  fixedSize: Size(323.w, 54.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        fileExtension == 'pdf' ? pdf : excel,
                        height: 30.h,
                        width: 30.w,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          style: pdfTitleTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // create structure of the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          CustomAppBarSubScreen(title: widget.name, imagePath: widget.image),
          Expanded(
            child:
                isLoading
                    ? Center(child: loadingAnimation)
                    : errorMessage != null
                    ? Center(child: SizedBox.shrink())
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: borderContainerDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 2.h),
                            ...committeeHeadingDetail.map(
                              _buildCommitteeHeading,
                            ),

                            if (committeeDetail.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      committeeDetail
                                          .map(_buildCommitteeMember)
                                          .toList(),
                                ),
                              ),

                            ...committeeHeadingDetail.map(
                              _buildDisciplinaryHeading,
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
