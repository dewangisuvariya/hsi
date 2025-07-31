class MenWomenLeaguesModel {
  int? id;
  String? leaguesName;
  String? leaguesImage;

  MenWomenLeaguesModel({this.id, this.leaguesName, this.leaguesImage});

  MenWomenLeaguesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    leaguesName = json['leagues_name'];
    leaguesImage = json['leagues_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['leagues_name'] = this.leaguesName;
    data['leagues_image'] = this.leaguesImage;
    return data;
  }
}

// class League {
//   final int id;
//   final String leaguesName;
//   final String leaguesImage;
//   final List<LeagueDetail> details;

//   League({
//     required this.id,
//     required this.leaguesName,
//     required this.leaguesImage,
//     required this.details,
//   });

//   factory League.fromJson(Map<String, dynamic> json) {
//     return League(
//       id: json['id'],
//       leaguesName: json['leagues_name'],
//       leaguesImage: json['leagues_image'],
//       details: (json['details'] as List)
//           .map((detailJson) => LeagueDetail.fromJson(detailJson))
//           .toList(),
//     );
//   }
// }

// class LeagueDetail {
//   final String? standing;
//   final String? standingUrl;
//   final String? nextGame;
//   final String? nextGameUrl;
//   final String? result;
//   final String? resultUrl;

//   LeagueDetail({
//     this.standing,
//     this.standingUrl,
//     this.nextGame,
//     this.nextGameUrl,
//     this.result,
//     this.resultUrl,
//   });

//   factory LeagueDetail.fromJson(Map<String, dynamic> json) {
//     return LeagueDetail(
//       standing: json['standing'],
//       standingUrl: json['standing_url'],
//       nextGame: json['next_game'],
//       nextGameUrl: json['next_game_url'],
//       result: json['result'],
//       resultUrl: json['result_url'],
//     );
//   }
// }
