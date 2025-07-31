// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsi/const/resource_manager.dart' show errorImage;
// import '../Model/junior_tournament_model.dart';

// class TournamentMenAndWomenSection extends StatelessWidget {
//   final TournamentDetail tournament;
//   final List<TournamentMatch> matches;

//   const TournamentMenAndWomenSection({
//     Key? key,
//     required this.tournament,
//     required this.matches,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 12,
//             bottom: 10,
//             right: 16,
//             left: 16,
//           ),
//           child: Text(
//             tournament.tournamentName,
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w500,
//               fontFamily: "Poppins",
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20, right: 20),
//           child: Divider(color: Color(0xFFF28E2B), thickness: 1),
//         ),
//         if (matches.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             child: MatchesGrid(matches: matches),
//           )
//         else
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('No matches available for this tournament'),
//           ),
//         SizedBox(height: 20.h),
//       ],
//     );
//   }
// }

// class MatchesGrid extends StatelessWidget {
//   final List<TournamentMatch> matches;

//   const MatchesGrid({Key? key, required this.matches}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 2.6,
//         mainAxisSpacing: 1,
//         crossAxisSpacing: 1,
//       ),
//       itemCount: matches.length,
//       itemBuilder: (context, index) {
//         return MatchContainer(match: matches[index]);
//       },
//     );
//   }
// }

// class MatchContainer extends StatelessWidget {
//   final TournamentMatch match;
//   final double imageSize;
//   final double fontSize;
//   final Color containerColor;
//   final Color textColor;

//   const MatchContainer({
//     Key? key,
//     required this.match,
//     this.imageSize = 30,
//     this.fontSize = 11,
//     this.containerColor = const Color(0xFFE9E9E9),
//     this.textColor = Colors.black,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(4),
//       child: Container(
//         height: 48.h,
//         width: 170.w,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(color: containerColor),
//         child: Padding(
//           padding: const EdgeInsets.only(bottom: 8, top: 8, right: 4, left: 4),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               _buildTeamColumn(match.homeTeamName, match.homeTeamScore),

//               Padding(
//                 padding: const EdgeInsets.all(5),
//                 child:
//                     match.image.isNotEmpty
//                         ? Image.network(
//                           match.image,
//                           width: imageSize.w,
//                           height: imageSize.h,
//                           fit: BoxFit.contain,
//                           errorBuilder: (context, error, stackTrace) {
//                             return _buildDefaultImage();
//                           },
//                         )
//                         : _buildDefaultImage(),
//               ),

//               _buildTeamColumn(match.awayTeamName, match.awayTeamScore),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTeamColumn(String teamName, int teamScore) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           teamName,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: fontSize.sp,
//             fontFamily: "Poppins",
//             color: textColor,
//           ),
//         ),
//         Text(
//           "$teamScore",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: fontSize.sp,
//             fontFamily: "Poppins",
//             color: textColor,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDefaultImage() {
//     return Container(
//       color: Colors.black,
//       child: Image.asset(
//         errorImage,
//         width: imageSize.w,
//         height: imageSize.h,
//         fit: BoxFit.contain,
//         color: Colors.white,
//       ),
//     );
//   }
// }
