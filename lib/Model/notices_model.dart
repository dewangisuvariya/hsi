class NoticeResponse {
  final bool success;
  final String message;
  final List<Notice> notices;

  NoticeResponse({
    required this.success,
    required this.message,
    required this.notices,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    return NoticeResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      notices:
          (json['notices'] as List<dynamic>?)
              ?.map((notice) => Notice.fromJson(notice))
              .toList() ??
          [],
    );
  }
}

class Notice {
  final int noticeId;
  final String noticeMessage;
  final String noticeImage;
  final String startDate;
  final String endDate;

  Notice({
    required this.noticeId,
    required this.noticeMessage,
    required this.noticeImage,
    required this.startDate,
    required this.endDate,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json['notice_id'] ?? 0,
      noticeMessage: json['notice_message'] ?? '',
      noticeImage: json['notice_image'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}
