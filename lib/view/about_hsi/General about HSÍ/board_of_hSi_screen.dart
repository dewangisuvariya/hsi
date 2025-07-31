// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
// import 'package:hsi/const/style_manager.dart';
// import 'package:hsi/custom/custom_appbar_subscreen.dart';
// import 'package:hsi/custom/showNetworkErrorDialog.dart';
// import 'package:hsi/repository/about_hsi_details_helper.dart';

// // load Board of HSÍ details from web server
// // and display those within this screen
// // from other class, data is passed to this screen via constructor call
// class BoardOfHsiScreen extends StatefulWidget {
//   final int subSectionId;
//   final String name;
//   final String type;
//   final String image;

//   const BoardOfHsiScreen({
//     super.key,
//     required this.subSectionId,
//     required this.image,
//     required this.name,
//     required this.type,
//   });

//   @override
//   State<BoardOfHsiScreen> createState() => _BoardOfHsiScreenState();
// }

// class _BoardOfHsiScreenState extends State<BoardOfHsiScreen> {
//   bool isLoading = true;

//   String? errorMessage;
//   List<BoardMember> boardMember = [];
//   HeadingDetails? _heading;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   // Load data from the FetchAboutHsiDetailsHelper class via the web service.
//   Future<void> _loadData() async {
//     try {
//       final response = await AboutHsiDetailsHelper.fetchAboutHsiDetails(
//         widget.subSectionId,
//       );

//       if (mounted) {
//         setState(() {
//           boardMember = response.data.boardDetail;
//           _heading = response.data.headingDetails;
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           errorMessage = 'Failed to load data: $e';
//           isLoading = false;
//         });
//         showNetworkErrorDialog(context);
//       }
//     }
//   }

//   // create structure of the screen
//   @override
//   Widget build(BuildContext context) {
//     final isWideScreen = MediaQuery.of(context).size.width > 600;
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               CustomAppBarSubScreen(
//                 title: widget.name,
//                 imagePath: widget.image,
//               ),
//               Expanded(
//                 child:
//                     isLoading
//                         ? Center(child: loadingAnimation)
//                         : errorMessage != null
//                         ? Center(child: SizedBox.shrink())
//                         : SingleChildScrollView(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Container(
//                               decoration: borderContainerDecoration,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: EdgeInsets.only(
//                                         left: 4.w,
//                                         right: 4.w,
//                                         top: 4.h,
//                                       ),
//                                       child: Text(
//                                         _heading?.heading ??
//                                             "Stjórn HSÍ tímabilið 2024-2025 er skipuð eftirtöldum: ",
//                                         style:
//                                             isWideScreen
//                                                 ? titleBarTextStyle.copyWith(
//                                                   fontSize: 17.sp,
//                                                 )
//                                                 : titleBarTextStyle,
//                                       ),
//                                     ),
//                                     Divider(
//                                       color: selectedDividerColor,
//                                       thickness: 1,
//                                     ),
//                                     if (isWideScreen)
//                                       Padding(
//                                         padding: const EdgeInsets.all(16),
//                                         child: Wrap(
//                                           spacing:
//                                               MediaQuery.of(
//                                                 context,
//                                               ).size.width /
//                                               8.5,
//                                           // Horizontal space between items
//                                           runSpacing:
//                                               20.0, // Vertical space between rows
//                                           children:
//                                               boardMember.asMap().entries.map((
//                                                 entry,
//                                               ) {
//                                                 final index = entry.key;
//                                                 final item = entry.value;
//                                                 final isLastItem =
//                                                     index ==
//                                                     boardMember.length - 1;
//                                                 return SizedBox(
//                                                   width:
//                                                       MediaQuery.of(
//                                                         context,
//                                                       ).size.width /
//                                                       2.5, // Fixed width for each item
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                           left: 20,
//                                                           right: 20,
//                                                         ),
//                                                     child: Column(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         if (index != 0)
//                                                           Divider(),
//                                                         Text(
//                                                           item.categoryName,
//                                                           style: TextStyle(
//                                                             fontSize: 14.sp,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                             color: Color(
//                                                               0xFFF28E2B,
//                                                             ),
//                                                             fontFamily:
//                                                                 'Poppins',
//                                                           ),
//                                                         ),
//                                                         SizedBox(height: 12.h),
//                                                         Row(
//                                                           children: [
//                                                             Image.network(
//                                                               item.image,
//                                                               height: 30.h,
//                                                               width: 30.w,
//                                                             ),
//                                                             SizedBox(
//                                                               width: 16.w,
//                                                             ),
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   item.personName,
//                                                                   style:
//                                                                       coachesNameTextStyle,
//                                                                 ),
//                                                                 Text(
//                                                                   item.personDetails,
//                                                                   style:
//                                                                       durationTextStyle,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 );
//                                               }).toList(),
//                                         ),
//                                       ),

//                                     ...boardMember.asMap().entries.map((entry) {
//                                       int index = entry.key;
//                                       BoardMember item = entry.value;

//                                       return Padding(
//                                         padding: EdgeInsets.only(
//                                           left: 4.w,
//                                           right: 4.w,
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             if (index != 0) Divider(),
//                                             Text(
//                                               item.categoryName,
//                                               style: TextStyle(
//                                                 fontSize: 14.sp,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color(0xFFF28E2B),
//                                                 fontFamily: 'Poppins',
//                                               ),
//                                             ),
//                                             SizedBox(height: 12.h),
//                                             Row(
//                                               children: [
//                                                 Image.network(
//                                                   item.image,
//                                                   height: 30.h,
//                                                   width: 30.w,
//                                                 ),
//                                                 SizedBox(width: 16.w),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       item.personName,
//                                                       style:
//                                                           coachesNameTextStyle,
//                                                     ),
//                                                     Text(
//                                                       item.personDetails,
//                                                       style: durationTextStyle,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     }).toList(),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/Model/fetch_about_hsi_details_model.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/custom/showNetworkErrorDialog.dart';
import 'package:hsi/repository/about_hsi_details_helper.dart';

class BoardOfHsiScreen extends StatefulWidget {
  final int subSectionId;
  final String name;
  final String type;
  final String image;

  const BoardOfHsiScreen({
    super.key,
    required this.subSectionId,
    required this.image,
    required this.name,
    required this.type,
  });

  @override
  State<BoardOfHsiScreen> createState() => _BoardOfHsiScreenState();
}

class _BoardOfHsiScreenState extends State<BoardOfHsiScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<BoardMember> boardMember = [];
  HeadingDetails? _heading;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final response = await AboutHsiDetailsHelper.fetchAboutHsiDetails(
        widget.subSectionId,
      );

      if (mounted) {
        setState(() {
          boardMember = response.data.boardDetail;
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

  Widget _buildMobileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.h),
          child: Text(
            _heading?.heading ??
                "Stjórn HSÍ tímabilið 2024-2025 er skipuð eftirtöldum: ",
            style: titleBarTextStyle,
          ),
        ),
        Divider(color: selectedDividerColor, thickness: 1),
        ...boardMember.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Padding(
            padding: EdgeInsets.only(left: 4.w, right: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index != 0) Divider(),
                Text(
                  item.categoryName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFF28E2B),
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Image.network(
                      item.image,
                      height: 30.h,
                      width: 30.w,
                      errorBuilder:
                          (context, error, stackTrace) => Icon(
                            Icons.person,
                            size: 30.sp,
                            color: Colors.grey,
                          ),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.personName, style: coachesNameTextStyle),
                        Text(item.personDetails, style: durationTextStyle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTabletView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 4.h),
          child: Text(
            _heading?.heading ??
                "Stjórn HSÍ tímabilið 2024-2025 er skipuð eftirtöldum: ",
            style: titleBarTextStyle.copyWith(fontSize: 17.sp),
          ),
        ),
        Divider(color: selectedDividerColor, thickness: 1),
        Container(
          child: Wrap(
            spacing: MediaQuery.of(context).size.width / 8.5,
            runSpacing: 20.0,
            children:
                boardMember.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index != 0) Divider(),
                          Text(
                            item.categoryName,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFF28E2B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Image.network(
                                item.image,
                                height: 44.h,
                                width: 44.w,
                                errorBuilder:
                                    (context, error, stackTrace) => Icon(
                                      Icons.person,
                                      size: 30.sp,
                                      color: Colors.grey,
                                    ),
                              ),
                              SizedBox(width: 12.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.personName,

                                    style: coachesNameTextStyle.copyWith(
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                  Text(
                                    item.personDetails,
                                    style: durationTextStyle.copyWith(
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: backgroundColor,
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
                        ? Center(child: SizedBox.shrink())
                        : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: borderContainerDecoration,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child:
                                    isWideScreen
                                        ? _buildTabletView()
                                        : _buildMobileView(),
                              ),
                            ),
                          ),
                        ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
