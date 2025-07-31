// import 'package:flutter/material.dart';
// import '../../Model/junior_national_team_week_model.dart';

// class TeamExpansionCard extends StatelessWidget {
//   final Team team;
//   final bool isExpanded;
//   final VoidCallback onToggle;
//   final Widget expandedContent;

//   const TeamExpansionCard({
//     Key? key,
//     required this.team,
//     required this.isExpanded,
//     required this.onToggle,
//     required this.expandedContent,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: isExpanded ? const Color(0xFFEDEDED) : Colors.white,
//           ),
//           child: ListTile(
//             title: Text(
//               team.tournamentName,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             trailing: GestureDetector(
//               onTap: onToggle,
//               child: Container(
//                 height: 15,
//                 width: 20,
//                 child: Image.asset(
//                   isExpanded
//                       ? "assets/images/arrow-down.png"
//                       : "assets/images/right-arrow.png",
//                   color: const Color(0xFFF28E2B),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         if (isExpanded)
//           Padding(
//             padding: const EdgeInsets.only(
//               left: 16.0,
//               right: 16.0,
//               bottom: 16.0,
//             ),
//             child: expandedContent,
//           ),
//         const Divider(height: 1, color: Color(0xFFEDEDED)),
//       ],
//     );
//   }
// }

// class CoachTile extends StatelessWidget {
//   final Coach coach;

//   const CoachTile({Key? key, required this.coach}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: coach.image.isNotEmpty
//           ? Container(
//         height: 40,
//         width: 40,
//         child: Image.network(
//           coach.image,
//           fit: BoxFit.cover,
//           errorBuilder: (context, error, stackTrace) =>
//           const Icon(Icons.error_outline, color: Colors.red),
//         ),
//       )
//           : const Icon(Icons.person, size: 40),
//       title: Text(
//         coach.name,
//         style: const TextStyle(
//           fontSize: 16,
//           color: Color(0xFF000000),
//         ),
//       ),
//       subtitle: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Phone: ${coach.telephone}',
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF757575),
//             ),
//           ),
//           Text(
//             'Email: ${coach.email}',
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF757575),
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WeekTile extends StatelessWidget {
//   final JuniorTeamWeek week;

//   const WeekTile({Key? key, required this.week}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           week.image.isNotEmpty
//               ? Container(
//             width: 40,
//             height: 40,
//             margin: const EdgeInsets.only(right: 12),
//             child: Image.network(
//               week.image,
//               fit: BoxFit.cover,
//               errorBuilder: (context, error, stackTrace) =>
//               const Icon(Icons.calendar_today),
//             ),
//           )
//               : const Icon(Icons.calendar_today, size: 40),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   week.planning,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   week.duration,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF757575),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TeamContent extends StatelessWidget {
//   final Team team;

//   const TeamContent({Key? key, required this.team}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (team.coaches.isNotEmpty)
//           Column(
//             children: team.coaches
//                 .map((coach) => CoachTile(coach: coach))
//                 .toList(),
//           ),
//         if (team.juniorTeamWeeks.isNotEmpty)
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: team.juniorTeamWeeks
//                 .map((week) => WeekTile(week: week))
//                 .toList(),
//           ),
//         if (team.coaches.isEmpty && team.juniorTeamWeeks.isEmpty)
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('No data available for this team'),
//           ),
//       ],
//     );
//   }
// }

// class WeekHeadingWidget extends StatelessWidget {
//   final WeekHeading heading;

//   const WeekHeadingWidget({Key? key, required this.heading}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             heading.heading,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               fontFamily: "Poppins",
//               color: Color(0xFF1E1E1E),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             heading.description,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               fontFamily: "Poppins",
//               color: Color(0xFF1E1E1E),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
