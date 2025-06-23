// import 'package:flutter/material.dart';
//
// import '../Model/junior_national_team_week_model.dart';
//
// class TeamExpansionList extends StatefulWidget {
//   final List<JuniorTeam> teams;
//   final Map<int, List<JuniorTeamWeek>> teamWeeks;
//   final String? errorMessage;
//   final List<WeekHeading> weekHeadings;
//   final Function(int teamId, String tournamentType) onTeamToggled;
//
//   const TeamExpansionList({
//     Key? key,
//     required this.teams,
//     required this.teamWeeks,
//     required this.onTeamToggled,
//     this.errorMessage,
//     required this.weekHeadings,
//   }) : super(key: key);
//
//   @override
//   _TeamExpansionListState createState() => _TeamExpansionListState();
// }
//
// class _TeamExpansionListState extends State<TeamExpansionList> {
//   final Map<int, bool> _expandedTeams = {};
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) {
//       return Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             widget.errorMessage!,
//             style: const TextStyle(color: Colors.red),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
//     }
//
//     if (widget.teams.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text('No teams available'),
//         ),
//       );
//     }
//
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.weekHeadings.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.weekHeadings.first.weekHeading,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: "Poppins",
//                       color: Color(0xFF1E1E1E),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.weekHeadings.first.weekDescription,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w400,
//                       fontFamily: "Poppins",
//                       color: Color(0xFF1E1E1E),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           const SizedBox(height: 16),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8.0),
//               border: Border.all(color: const Color(0xFFE0E0E0)),
//             ),
//             child: Column(
//               children: List.generate(widget.teams.length, (index) {
//                 final team = widget.teams[index];
//                 final isLastItem = index == widget.teams.length - 1;
//
//                 return Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: _expandedTeams[team.id] == true
//                             ? const Color(0xFFEDEDED)
//                             : Colors.white,
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           team.tournamentName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         trailing: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _expandedTeams[team.id] =
//                               !(_expandedTeams[team.id] ?? false);
//                             });
//                             widget.onTeamToggled(team.id, team.tournamentType);
//                           },
//                           child: Container(
//                             height: 15,
//                             width: 20,
//                             child: Image.asset(
//                               _expandedTeams[team.id] == true
//                                   ? "assets/images/arrow-down.png"
//                                   : "assets/images/right-arrow.png",
//                               color: const Color(0xFFF28E2B),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (_expandedTeams[team.id] == true)
//                       Padding(
//                         padding: const EdgeInsets.only(
//                           left: 16.0,
//                           right: 16.0,
//                           bottom: 16.0,
//                         ),
//                         child: TeamWeekList(
//                           weeks: widget.teamWeeks[team.id] ?? [],
//                         ),
//                       ),
//                     if (!isLastItem && _expandedTeams[team.id] != true)
//                       const Divider(height: 1, color: Color(0xFFEDEDED)),
//                   ],
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class TeamWeekList extends StatelessWidget {
//   final List<JuniorTeamWeek> weeks;
//
//   const TeamWeekList({
//     Key? key,
//     required this.weeks,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     if (weeks.isEmpty) {
//       return const Text('No week data available');
//     }
//
//     return Column(
//       children: weeks.map((week) {
//         return ListTile(
//           leading: Container(
//             height: 30,
//             width: 30,
//             child: Image.network(week.image),
//           ),
//           title: Text(
//             week.duration,
//             style: const TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w500,
//               fontFamily: "Poppins",
//               color: Color(0xFF000000),
//             ),
//           ),
//           subtitle: Text(
//             week.planning,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               fontFamily: "Poppins",
//               color: Color(0xFF757575),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }