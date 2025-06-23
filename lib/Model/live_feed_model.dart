// import 'dart:typed_data';

// class LiveFeedResponse {
//   final bool success;
//   final String message;
//   final List<LiveFeedBanner> banners;

//   LiveFeedResponse({
//     required this.success,
//     required this.message,
//     required this.banners,
//   });

//   factory LiveFeedResponse.fromJson(Map<String, dynamic> json) {
//     return LiveFeedResponse(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       banners:
//           (json['banners'] as List<dynamic>?)
//               ?.map((banner) => LiveFeedBanner.fromJson(banner))
//               .toList() ??
//           [],
//     );
//   }
// }

// class LiveFeedBanner {
//   final int id;
//   final int position;
//   final String fileType;
//   final String fileUrl;

//   LiveFeedBanner({
//     required this.id,
//     required this.position,
//     required this.fileType,
//     required this.fileUrl,
//   });

//   factory LiveFeedBanner.fromJson(Map<String, dynamic> json) {
//     return LiveFeedBanner(
//       id: json['id'] ?? 0,
//       position: json['position'] ?? 0,
//       fileType: json['file_type'] ?? '',
//       fileUrl: json['file_url'] ?? '',
//     );
//   }

//   // Helper method to sort banners by position
//   static List<LiveFeedBanner> sortByPosition(List<LiveFeedBanner> banners) {
//     banners.sort((a, b) => a.position.compareTo(b.position));
//     return banners;
//   }
// }
import 'dart:typed_data';

class LiveFeedResponse {
  final bool success;
  final String message;
  final List<LiveFeedBanner> banners;

  LiveFeedResponse({
    required this.success,
    required this.message,
    required this.banners,
  });

  factory LiveFeedResponse.fromJson(Map<String, dynamic> json) {
    return LiveFeedResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      banners:
          (json['banners'] as List<dynamic>?)
              ?.map((banner) => LiveFeedBanner.fromJson(banner))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'banners': banners.map((banner) => banner.toJson()).toList(),
    };
  }
}

class LiveFeedBanner {
  final int id;
  final int position;
  final String fileType;
  final String fileUrl;
  Future<Uint8List>? thumbnailBytes;

  LiveFeedBanner({
    required this.id,
    required this.position,
    required this.fileType,
    required this.fileUrl,
    this.thumbnailBytes,
  });

  factory LiveFeedBanner.fromJson(Map<String, dynamic> json) {
    return LiveFeedBanner(
      id: json['id'] ?? 0,
      position: json['position'] ?? 0,
      fileType: json['file_type'] ?? '',
      fileUrl: json['file_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'file_type': fileType,
      'file_url': fileUrl,
    };
  }

  // Helper method to sort banners by position
  static List<LiveFeedBanner> sortByPosition(List<LiveFeedBanner> banners) {
    banners.sort((a, b) => a.position.compareTo(b.position));
    return banners;
  }
}
