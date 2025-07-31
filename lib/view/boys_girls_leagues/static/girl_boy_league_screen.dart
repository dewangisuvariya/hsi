// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/const/resource_manager.dart';
// import 'package:hsi/const/style_manager.dart';
// import 'package:hsi/custom/custom_appbar_subscreen.dart';
// import 'package:hsi/view/boys_girls_leagues/static/static_screen.dart';
// // load Girl Boy League details from web server
// // and display those within this screen
// // from other class, data is passed to this screen via constructor call

// class GirlBoyLeagueScreen extends StatefulWidget {
//   final int leagueId;
//   final String leagueName;
//   final String leaguesImage;

//   const GirlBoyLeagueScreen({
//     super.key,
//     required this.leagueId,
//     required this.leagueName,
//     required this.leaguesImage,
//   });

//   @override
//   State<GirlBoyLeagueScreen> createState() => _GirlBoyLeagueScreenState();
// }

// class _GirlBoyLeagueScreenState extends State<GirlBoyLeagueScreen> {
//   // static data list
//   final List<Map<String, dynamic>> statsList = [
//     {"id": 1, "name": "Lota 1", "image": round},
//     {"id": 2, "name": "Lota 2", "image": round},
//     {"id": 3, "name": "Lota 3", "image": round},
//     {"id": 4, "name": "Lota 4", "image": round},
//   ];

//   int? selectedIndex;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: [
//           CustomAppBarSubScreen(
//             title: widget.leagueName,
//             imagePath: widget.leaguesImage,
//           ),
//           Expanded(
//             child: ListView.separated(
//               separatorBuilder:
//                   (context, index) => Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15),
//                     child: Divider(
//                       color:
//                           selectedIndex == index
//                               ? selectedDividerColor
//                               : unselectedDividerColor,
//                       thickness: selectedIndex == index ? 3 : 1,
//                       height: 4,
//                     ),
//                   ),
//               itemCount: statsList.length,
//               itemBuilder: (context, index) {
//                 final league = statsList[index];
//                 final isSelected = selectedIndex == index;

//                 return Container(
//                   width: 374.w,
//                   height: 72.h,
//                   margin: const EdgeInsets.symmetric(horizontal: 15),
//                   decoration: BoxDecoration(
//                     color:
//                         isSelected
//                             ? selectLeagueTileColor
//                             : unselectLeagueTileColor,
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                       if (widget.leagueId == 8 && league["id"] == 1) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) => StaticScreen(
//                                   leagueId: widget.leagueId,
//                                   subLeagueId: league["id"],
//                                   leagueName: league["name"],
//                                 ),
//                           ),
//                         );
//                       }
//                     },
//                     child: Row(
//                       children: [
//                         SizedBox(width: 10.w),
//                         Container(
//                           decoration: BoxDecoration(
//                             color:
//                                 isSelected
//                                     ? selectLeagueTileColor
//                                     : unselectLeagueTileColor,
//                           ),
//                           child: Image.asset(
//                             round,
//                             width: 52.w,
//                             height: 35.h,
//                             fit: BoxFit.contain,
//                             alignment: Alignment.bottomCenter,
//                           ),
//                         ),
//                         SizedBox(width: 6.w),
//                         Expanded(
//                           child: Text(
//                             league["name"],
//                             style: TextStyle(
//                               color: const Color(0XFF292929),
//                               fontSize: 18.sp,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: "Poppins",
//                             ),
//                             overflow: TextOverflow.visible,
//                             maxLines: 2,
//                             softWrap: true,
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: 10.w),
//                           child: CircleAvatar(
//                             backgroundColor:
//                                 isSelected
//                                     ? selectedCircleAvatarcolor
//                                     : unselectedCircleAvatarcolor,
//                             radius: 17.r,
//                             child: Center(
//                               child: Image.asset(
//                                 isSelected
//                                     ? selectedCircleAvater
//                                     : unselectedCircleAvater,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsi/const/resource_manager.dart';
import 'package:hsi/const/style_manager.dart';
import 'package:hsi/custom/custom_appbar_subscreen.dart';
import 'package:hsi/view/boys_girls_leagues/static/static_screen.dart';

class GirlBoyLeagueScreen extends StatefulWidget {
  final int leagueId;
  final String leagueName;
  final String leaguesImage;

  const GirlBoyLeagueScreen({
    super.key,
    required this.leagueId,
    required this.leagueName,
    required this.leaguesImage,
  });

  @override
  State<GirlBoyLeagueScreen> createState() => _GirlBoyLeagueScreenState();
}

class _GirlBoyLeagueScreenState extends State<GirlBoyLeagueScreen> {
  // static data list
  final List<Map<String, dynamic>> statsList = [
    {"id": 1, "name": "Lota 1", "image": round},
    {"id": 2, "name": "Lota 2", "image": round},
    {"id": 3, "name": "Lota 3", "image": round},
    {"id": 4, "name": "Lota 4", "image": round},
  ];

  int? selectedIndex;

  // Build layout based on screen width
  Widget _buildListLayout(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isWideScreen = mediaQuery.size.width > 600;

    if (isWideScreen) {
      // GridView for tablet/wide screens
      return GridView.custom(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4, // Adjusted ratio for better appearance
        ),
        childrenDelegate: SliverChildBuilderDelegate((context, index) {
          final league = statsList[index];
          return buildDividerContainer(
            child: _buildLeagueTileTab(league, index),
            isSelected: selectedIndex == index,
          );
        }, childCount: statsList.length),
      );
    } else {
      // ListView for mobile
      return ListView.separated(
        separatorBuilder:
            (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color:
                    selectedIndex == index
                        ? selectedDividerColor
                        : unselectedDividerColor,
                thickness: selectedIndex == index ? 3 : 1,
                height: 4,
              ),
            ),
        itemCount: statsList.length + 1,
        itemBuilder: (context, index) {
          if (index == statsList.length) {
            return SizedBox();
          }
          final league = statsList[index];
          return _buildLeagueTile(league, index);
        },
      );
    }
  }

  // Build mobile list tile
  Widget _buildLeagueTile(Map<String, dynamic> league, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      width: 374.w,
      height: 72.h,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isSelected ? selectLeagueTileColor : unselectLeagueTileColor,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          if (widget.leagueId == 8 && league["id"] == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => StaticScreen(
                      leagueId: widget.leagueId,
                      subLeagueId: league["id"],
                      leagueName: league["name"],
                    ),
              ),
            );
          }
        },
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Container(
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? selectLeagueTileColor
                        : unselectLeagueTileColor,
              ),
              child: Image.asset(
                round,
                width: 52.w,
                height: 35.h,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                league["name"],
                style: TextStyle(
                  color: const Color(0XFF292929),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
                overflow: TextOverflow.visible,
                maxLines: 2,
                softWrap: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: CircleAvatar(
                backgroundColor:
                    isSelected
                        ? selectedCircleAvatarcolor
                        : unselectedCircleAvatarcolor,
                radius: 17.r,
                child: Center(
                  child: Image.asset(
                    isSelected ? selectedCircleAvater : unselectedCircleAvater,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build tablet grid tile
  Widget _buildLeagueTileTab(Map<String, dynamic> league, int index) {
    final isSelected = selectedIndex == index;

    return Container(
      width: 320.9.w,
      height: 70.h,

      decoration: BoxDecoration(
        color: isSelected ? selectLeagueTileColor : unselectLeagueTileColor,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
          if (widget.leagueId == 8 && league["id"] == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => StaticScreen(
                      leagueId: widget.leagueId,
                      subLeagueId: league["id"],
                      leagueName: league["name"],
                    ),
              ),
            );
          }
        },
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Container(
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? selectLeagueTileColor
                        : unselectLeagueTileColor,
              ),
              child: Image.asset(
                round,
                width: 52.w,
                height: 35.h,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                league["name"],
                style: TextStyle(
                  color: const Color(0XFF292929),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
                overflow: TextOverflow.visible,
                maxLines: 2,
                softWrap: true,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: CircleAvatar(
                backgroundColor:
                    isSelected
                        ? selectedCircleAvatarcolor
                        : unselectedCircleAvatarcolor,
                radius: 17.r,
                child: Center(
                  child: Image.asset(
                    isSelected ? selectedCircleAvater : unselectedCircleAvater,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDividerContainer({
    required Widget child,
    required bool isSelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? selectedDividerColor : unselectedDividerColor,
            width: isSelected ? 3 : 1,
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          CustomAppBarSubScreen(
            title: widget.leagueName,
            imagePath: widget.leaguesImage,
          ),
          Expanded(child: _buildListLayout(context)),
        ],
      ),
    );
  }
}
