// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/const/style_manager.dart';
// import 'package:hsi/custom/showNetworkErrorDialog.dart';
// import '../../../Model/partner_club_detail_model.dart';
// import '../../../repository/partner_club_detail_helper.dart';

// // load club partner manager details from web server
// // and display those within this screen
// // from other class, data is passed to this screen via constructor call
// class ClubPartnerManagerInfoScreen extends StatefulWidget {
//   final int clubId;

//   const ClubPartnerManagerInfoScreen({Key? key, required this.clubId})
//     : super(key: key);

//   @override
//   State<ClubPartnerManagerInfoScreen> createState() =>
//       _ClubPartnerManagerInfoScreenState();
// }

// class _ClubPartnerManagerInfoScreenState
//     extends State<ClubPartnerManagerInfoScreen> {
//   late Future<List<PartnerClubDetailModel>> _futureClubPartners;
//   bool isLoading = true;
//   bool _hasDataLoaded = false;
//   bool _isManualRefresh = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   // Load data from the PartnerClubDetailHelper class via the web service.
//   Future<void> _loadData() async {
//     _futureClubPartners = _fetchClubPartnersWithHandling();
//   }

//   Future<List<PartnerClubDetailModel>> _fetchClubPartnersWithHandling() async {
//     if (!mounted) return [];

//     if (!_hasDataLoaded || _isManualRefresh) {
//       setState(() {
//         isLoading = true;
//       });
//     }
//     try {
//       final data = await fetchClubPartners(widget.clubId);

//       if (mounted) {
//         setState(() {
//           isLoading = false;
//           _isManualRefresh = false;
//           _hasDataLoaded = true;
//         });
//       }
//       return data;
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//         showNetworkErrorDialog(context);
//       }
//       debugPrint('Error loading club partners: $e');
//       return [];
//     }
//   }

//   // create structure of the screen
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<PartnerClubDetailModel>>(
//       future: _futureClubPartners,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: loadingAnimation);
//         } else if (snapshot.hasError) {
//           return Center(child: Text(""));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return Center(child: Text(""));
//         } else {
//           List<PartnerClubDetailModel> partners = snapshot.data!;
//           return ListView.builder(
//             padding: EdgeInsets.zero,
//             itemCount: partners.length,
//             itemBuilder: (context, index) {
//               return _buildManagersTab(partners[index]);
//             },
//           );
//         }
//       },
//     );
//   }

//   // display club partner manager list of that screen
//   Widget _buildManagersTab(PartnerClubDetailModel partner) {
//     // Create a list of all possible fields that should be checked
//     final List<MapEntry<String, HomeField?>> allFields = [
//       MapEntry("Heimavöllur", partner.homeField),
//       MapEntry("Heimasíða", partner.homepage),
//       MapEntry("Formaður", partner.chairman),
//       MapEntry("Framkvæmdastjóri", partner.executiveDirector),
//       MapEntry(
//         "Formaður barna- og unglingaráðs",
//         partner.chairmanCouncilChildrenYouth,
//       ),
//       MapEntry(
//         "Gjaldkeri barna- og unglingaráðs",
//         partner.treasurerChildrenYouthCouncil,
//       ),
//       MapEntry(
//         "Formaður meistaraflokksráðs karla",
//         partner.chairmanMensChampionshipCouncil,
//       ),
//       MapEntry(
//         "Formaður meistarflokksráðs kvenna",
//         partner.chairmanWomensChampionshipCouncil,
//       ),
//       MapEntry("Yfirþjálfari", partner.headCoach),
//       MapEntry("Íþróttafulltrúi", partner.sportsRepresentative),
//       MapEntry(
//         "Verkefnastjóri Handknattleiksdeildar",
//         partner.handballDepartmentProjectManager,
//       ),
//       MapEntry("Verkefnastjóri", partner.projectManager),
//       MapEntry("Skrifstofustjóri", partner.officeManager),
//       MapEntry(
//         "Framkvæmdastjóri handknattleiksdeildar",
//         partner.handballDepartmentExecutiveDirector,
//       ),
//       MapEntry("Yfirþjálfari karla", partner.mensHeadCoach),
//       MapEntry("Yfirþjálfari kvenna", partner.womensHeadCoach),
//       MapEntry(
//         "Formenn meistarafl. Ráðs",
//         partner.chairmenOfTheChampionshipCouncil,
//       ),
//       MapEntry("Varaformaður", partner.viceChairman),
//       MapEntry("Gjaldkeri", partner.treasurer),
//     ];

//     // Filter out null fields and fields with missing required data
//     final validFields =
//         allFields.where((entry) {
//           final field = entry.value;
//           return field != null &&
//               field.title != null &&
//               field.description != null &&
//               field.image != null &&
//               field.image!.isNotEmpty;
//         }).toList();

//     // If no valid fields, return empty container
//     if (validFields.isEmpty) {
//       return Container();
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         decoration: borderContainerDecoration,
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               for (int i = 0; i < validFields.length; i++) ...[
//                 _buildPartnerTile(validFields[i].key, validFields[i].value!),
//                 if (i < validFields.length - 1) divider(),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Display the UI of a custom ListTile for the club partner manager
//   Widget _buildPartnerTile(String title, HomeField homeField) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 8, top: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(width: 16.w),
//           if (homeField.image != null && homeField.image!.isNotEmpty)
//             Image.network(
//               homeField.image!,
//               width: 30.w,
//               height: 30.h,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return errorImageContainer();
//               },
//             ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 if (homeField.title != null)
//                   Text(title, style: titleBarTextStyle, maxLines: 2),
//                 if (homeField.description != null)
//                   Text(homeField.description!, style: descriptionTextStyle),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Display divider
//   Widget divider() {
//     return Divider(color: selectedDividerColor, thickness: 1);
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import '../../../Model/partner_club_detail_model.dart';
import '../../../repository/partner_club_detail_helper.dart';

class ClubPartnerManagerInfoScreen extends StatefulWidget {
  final int clubId;

  const ClubPartnerManagerInfoScreen({Key? key, required this.clubId})
    : super(key: key);

  @override
  State<ClubPartnerManagerInfoScreen> createState() =>
      _ClubPartnerManagerInfoScreenState();
}

class _ClubPartnerManagerInfoScreenState
    extends State<ClubPartnerManagerInfoScreen> {
  late Future<List<PartnerClubDetailModel>> _futureClubPartners;
  bool isLoading = true;
  bool _hasDataLoaded = false;
  bool _isManualRefresh = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _futureClubPartners = _fetchClubPartnersWithHandling();
  }

  Future<List<PartnerClubDetailModel>> _fetchClubPartnersWithHandling() async {
    if (!mounted) return [];

    if (!_hasDataLoaded || _isManualRefresh) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      final data = await fetchClubPartners(widget.clubId);

      if (mounted) {
        setState(() {
          isLoading = false;
          _isManualRefresh = false;
          _hasDataLoaded = true;
        });
      }
      return data;
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        showNetworkErrorDialog(context);
      }
      debugPrint('Error loading club partners: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;

    return FutureBuilder<List<PartnerClubDetailModel>>(
      future: _futureClubPartners,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: loadingAnimation);
        } else if (snapshot.hasError) {
          return Center(child: Text(""));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(""));
        } else {
          List<PartnerClubDetailModel> partners = snapshot.data!;

          if (isTablet) {
            return _buildTabletLayout(partners);
          } else {
            return _buildMobileLayout(partners);
          }
        }
      },
    );
  }

  Widget _buildMobileLayout(List<PartnerClubDetailModel> partners) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: partners.length,
      itemBuilder: (context, index) {
        return _buildManagersTab(partners[index]);
      },
    );
  }

  Widget _buildTabletLayout(List<PartnerClubDetailModel> partners) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          for (var partner in partners)
            Container(
              decoration: borderContainerDecoration,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Two column layout for the fields
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left column
                        Expanded(child: _buildTabletColumn(partner, 0)),
                        SizedBox(width: 16),
                        // Right column
                        Expanded(child: _buildTabletColumn(partner, 1)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabletColumn(PartnerClubDetailModel partner, int columnIndex) {
    final List<MapEntry<String, HomeField?>> allFields = [
      MapEntry("Heimavöllur", partner.homeField),
      MapEntry("Heimasíða", partner.homepage),
      MapEntry("Formaður", partner.chairman),
      MapEntry("Framkvæmdastjóri", partner.executiveDirector),
      MapEntry(
        "Formaður barna- og unglingaráðs",
        partner.chairmanCouncilChildrenYouth,
      ),
      MapEntry(
        "Gjaldkeri barna- og unglingaráðs",
        partner.treasurerChildrenYouthCouncil,
      ),
      MapEntry(
        "Formaður meistaraflokksráðs karla",
        partner.chairmanMensChampionshipCouncil,
      ),
      MapEntry(
        "Formaður meistarflokksráðs kvenna",
        partner.chairmanWomensChampionshipCouncil,
      ),
      MapEntry("Yfirþjálfari", partner.headCoach),
      MapEntry("Íþróttafulltrúi", partner.sportsRepresentative),
    ];

    // Filter valid fields and split into two columns
    final validFields =
        allFields.where((entry) {
          final field = entry.value;
          return field != null &&
              field.title != null &&
              field.description != null &&
              field.image != null &&
              field.image!.isNotEmpty;
        }).toList();

    // Split fields into two columns
    final columnFields = <MapEntry<String, HomeField>>[];
    for (int i = 0; i < validFields.length; i++) {
      if (i % 2 == columnIndex) {
        // Use null assertion operator (!) since we've already filtered out nulls
        columnFields.add(MapEntry(validFields[i].key, validFields[i].value!));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < columnFields.length; i++) ...[
          _buildTabletPartnerTile(columnFields[i].key, columnFields[i].value),
          SizedBox(height: 12),
          if (i < columnFields.length - 1) divider(),
        ],
      ],
    );
  }

  Widget _buildTabletPartnerTile(String title, HomeField homeField) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (homeField.image != null && homeField.image!.isNotEmpty)
              Image.network(
                homeField.image!,
                width: 37.w,
                height: 37.h,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return errorImageContainer();
                },
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (homeField.title != null)
                    Text(
                      title,
                      style: titleBarTextStyle.copyWith(fontSize: 16.sp),
                    ),
                  if (homeField.description != null)
                    Text(
                      homeField.description!,
                      style: descriptionTextStyle.copyWith(fontSize: 16.sp),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManagersTab(PartnerClubDetailModel partner) {
    final List<MapEntry<String, HomeField?>> allFields = [
      MapEntry("Heimavöllur", partner.homeField),
      MapEntry("Heimasíða", partner.homepage),
      MapEntry("Formaður", partner.chairman),
      MapEntry("Framkvæmdastjóri", partner.executiveDirector),
      MapEntry(
        "Formaður barna- og unglingaráðs",
        partner.chairmanCouncilChildrenYouth,
      ),
      MapEntry(
        "Gjaldkeri barna- og unglingaráðs",
        partner.treasurerChildrenYouthCouncil,
      ),
      MapEntry(
        "Formaður meistaraflokksráðs karla",
        partner.chairmanMensChampionshipCouncil,
      ),
      MapEntry(
        "Formaður meistarflokksráðs kvenna",
        partner.chairmanWomensChampionshipCouncil,
      ),
      MapEntry("Yfirþjálfari", partner.headCoach),
      MapEntry("Íþróttafulltrúi", partner.sportsRepresentative),
      MapEntry(
        "Verkefnastjóri Handknattleiksdeildar",
        partner.handballDepartmentProjectManager,
      ),
      MapEntry("Verkefnastjóri", partner.projectManager),
      MapEntry("Skrifstofustjóri", partner.officeManager),
      MapEntry(
        "Framkvæmdastjóri handknattleiksdeildar",
        partner.handballDepartmentExecutiveDirector,
      ),
      MapEntry("Yfirþjálfari karla", partner.mensHeadCoach),
      MapEntry("Yfirþjálfari kvenna", partner.womensHeadCoach),
      MapEntry(
        "Formenn meistarafl. Ráðs",
        partner.chairmenOfTheChampionshipCouncil,
      ),
      MapEntry("Varaformaður", partner.viceChairman),
      MapEntry("Gjaldkeri", partner.treasurer),
    ];

    final validFields =
        allFields.where((entry) {
          final field = entry.value;
          return field != null &&
              field.title != null &&
              field.description != null &&
              field.image != null &&
              field.image!.isNotEmpty;
        }).toList();

    if (validFields.isEmpty) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: borderContainerDecoration,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < validFields.length; i++) ...[
                _buildPartnerTile(validFields[i].key, validFields[i].value!),
                if (i < validFields.length - 1) divider(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerTile(String title, HomeField homeField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 16.w),
          if (homeField.image != null && homeField.image!.isNotEmpty)
            Image.network(
              homeField.image!,
              width: 30.w,
              height: 30.h,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return errorImageContainer();
              },
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (homeField.title != null)
                  Text(title, style: titleBarTextStyle, maxLines: 2),
                if (homeField.description != null)
                  Text(homeField.description!, style: descriptionTextStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Divider(color: selectedDividerColor, thickness: 1);
  }
}
