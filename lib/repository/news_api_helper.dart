// import 'package:http/http.dart' as http;
// import 'package:xml/xml.dart' as xml;

// abstract class BaseNewsItem {
//   String get title;
//   String get link;
//   String get description;
//   String get pubDate;
//   String? get imageUrl;
// }

// class NewsApiHelper {
//   static const String _rssUrl = 'https://www.mbl.is/feeds/handbolti/';

//   static Future<List<BaseNewsItem>> fetchHandballNews() async {
//     try {
//       final response = await http.get(Uri.parse(_rssUrl));
//       if (response.statusCode == 200) {
//         return _parseXml(response.body);
//       } else {
//         throw Exception('Failed to load news: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load news: $e');
//     }
//   }

//   static Future<List<BaseNewsItem>> fetchNews() async {
//     final response = await http.get(
//       Uri.parse('https://handbolti.is/feed/'),
//       headers: {'Accept': 'application/xml'},
//     );

//     if (response.statusCode == 200) {
//       final document = xml.XmlDocument.parse(response.body);
//       final items = document.findAllElements('item');
//       return items.map((item) => NewsItemHandball.fromXml(item)).toList();
//     } else {
//       throw Exception('Failed to load news feed');
//     }
//   }

//   static const String rssUrl = 'http://ruv.is/rss/efni/handbolti/';

//   static Future<List<BaseNewsItem>> fetchRuvHandballNews() async {
//     try {
//       final response = await http.get(Uri.parse(rssUrl));
//       if (response.statusCode == 200) {
//         return _parseRuvXml(response.body);
//       } else {
//         throw Exception('Failed to load news: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load news: $e');
//     }
//   }

//   static Future<List<BaseNewsItem>> fetchHsiNews() async {
//     try {
//       final response = await http.get(Uri.parse("https://www.hsi.is/feed/"));
//       if (response.statusCode == 200) {
//         final document = xml.XmlDocument.parse(response.body);
//         final items = document.findAllElements('item');
//         return items.map((item) => NewsItemHandball.fromXml(item)).toList();
//       } else {
//         throw Exception('Failed to load HSI news: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to load HSI news: $e');
//     }
//   }

//   static List<BaseNewsItem> _parseRuvXml(String xmlString) {
//     final document = xml.XmlDocument.parse(xmlString);
//     final items = document.findAllElements('item');

//     return items.map((item) {
//       final enclosure = item.findElements('enclosure');
//       final imageUrl =
//           enclosure.isNotEmpty ? enclosure.first.getAttribute('url') : null;

//       return RuvNewsItem(
//         title: item.findElements('title').first.text,
//         link: item.findElements('link').first.text,
//         description: _cleanDescription(
//           item.findElements('description').first.text,
//         ),
//         pubDate: item.findElements('pubDate').first.text,
//         imageUrl: imageUrl,
//         creator: item.findElements('dc:creator').first.text.trim(),
//         guid: item.findElements('guid').first.text,
//       );
//     }).toList();
//   }

//   static List<BaseNewsItem> _parseXml(String xmlString) {
//     final document = xml.XmlDocument.parse(xmlString);
//     final items = document.findAllElements('item');

//     return items.map((item) {
//       final description = item.findElements('description').single.text;
//       final imageUrl = _extractImageUrl(description);
//       return NewsItem(
//         title: item.findElements('title').single.text,
//         link: item.findElements('link').single.text,
//         description: _cleanDescription(description),
//         pubDate: item.findElements('pubDate').single.text,

//         imageUrl: imageUrl,
//       );
//     }).toList();
//   }

//   static String? _extractImageUrl(String description) {
//     try {
//       final startIndex = description.indexOf('src="') + 5;
//       final endIndex = description.indexOf('"', startIndex);
//       return description.substring(startIndex, endIndex);
//     } catch (e) {
//       return null;
//     }
//   }

//   static String _cleanDescription(String description) {
//     return description
//         .replaceAll(RegExp(r'<[^>]*>'), '')
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//   }
// }

// // ----------------------------------------
// // Models
// // ----------------------------------------

// class NewsItem extends BaseNewsItem {
//   @override
//   final String title;
//   @override
//   final String link;
//   @override
//   final String description;
//   @override
//   final String pubDate;
//   @override
//   final String? imageUrl;

//   NewsItem({
//     required this.title,
//     required this.link,
//     required this.description,
//     required this.pubDate,
//     this.imageUrl,
//   });
// }

// class NewsItemHandball extends BaseNewsItem {
//   @override
//   final String title;
//   @override
//   final String link;
//   @override
//   final String description;
//   @override
//   final String pubDate;
//   @override
//   final String? imageUrl;
//   final String content;

//   NewsItemHandball({
//     required this.title,
//     required this.link,
//     required this.description,
//     required this.pubDate,
//     this.imageUrl,
//     required this.content,
//   });

//   factory NewsItemHandball.fromXml(xml.XmlElement element) {
//     final title = element.findElements('title').first.text;
//     final link = element.findElements('link').first.text;
//     final description = element.findElements('description').first.text;
//     final pubDate = element.findElements('pubDate').first.text;
//     final contentElement = element.findElements('content:encoded');
//     final content = contentElement.isNotEmpty ? contentElement.first.text : "";

//     // Extract image URL from description or content
//     String? imageUrl;
//     try {
//       final imageMatch = RegExp(r'src="([^"]+)"').firstMatch(description);
//       imageUrl = imageMatch?.group(1);
//     } catch (_) {
//       try {
//         final imageMatch = RegExp(r'src="([^"]+)"').firstMatch(content);
//         imageUrl = imageMatch?.group(1);
//       } catch (_) {
//         imageUrl = null;
//       }
//     }

//     return NewsItemHandball(
//       title: title,
//       link: link,
//       description: description,
//       pubDate: pubDate,
//       imageUrl: imageUrl,
//       content: content,
//     );
//   }
// }

// class RuvNewsItem extends BaseNewsItem {
//   @override
//   final String title;
//   @override
//   final String link;
//   @override
//   final String description;
//   @override
//   final String pubDate;
//   @override
//   final String? imageUrl;
//   final String creator;
//   final String guid;

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

abstract class BaseNewsItem {
  String get title;
  String get link;
  String get description;
  String get pubDate;
  String? get imageUrl;
  String get source;
}

class NewsApiHelper {
  static const String _rssUrl = 'https://www.mbl.is/feeds/handbolti/';

  static Future<List<BaseNewsItem>> fetchHandballNews() async {
    try {
      final response = await http.get(Uri.parse(_rssUrl));
      if (response.statusCode == 200) {
        return _parseXml(response.body, "Mbl.is");
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  static Future<List<BaseNewsItem>> fetchNews() async {
    final response = await http.get(
      Uri.parse('https://handbolti.is/feed/'),
      headers: {'Accept': 'application/xml'},
    );

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body);
      final items = document.findAllElements('item');
      return items
          .map((item) => NewsItemHandball.fromXml(item, "Handbolti.is"))
          .toList();
    } else {
      throw Exception('Failed to load news feed');
    }
  }

  static const String rssUrl = 'http://ruv.is/rss/efni/handbolti/';

  static Future<List<BaseNewsItem>> fetchRuvHandballNews() async {
    try {
      final response = await http.get(Uri.parse(rssUrl));
      if (response.statusCode == 200) {
        return _parseRuvXml(response.body, "RÚV.is");
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  static Future<List<BaseNewsItem>> fetchHsiNews() async {
    try {
      final response = await http.get(Uri.parse("https://www.hsi.is/feed/"));
      if (response.statusCode == 200) {
        final document = xml.XmlDocument.parse(response.body);
        final items = document.findAllElements('item');
        return items
            .map((item) => NewsItemHandball.fromXml(item, "HSÍ.is"))
            .toList();
      } else {
        throw Exception('Failed to load HSI news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load HSI news: $e');
    }
  }

  static const String _handkastidUrl = 'https://handkastid.net/feed/';
  static Future<List<BaseNewsItem>> fetchHandkastidNews() async {
    try {
      final response = await http.get(Uri.parse(_handkastidUrl));
      if (response.statusCode == 200) {
        return _parseHandkastidXml(response.body, "Handkastid.net");
      } else {
        throw Exception(
          'Failed to load Handkastid news: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load Handkastid news: $e');
    }
  }

  static List<BaseNewsItem> _parseHandkastidXml(
    String xmlString,
    String source,
  ) {
    final document = xml.XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    return items.map((item) {
      final title = item.findElements('title').first.text;
      final link = item.findElements('link').first.text;
      final description = _cleanDescription(
        item.findElements('description').first.text,
      );
      final pubDate = item.findElements('pubDate').first.text;
      final content = item.getElement('content:encoded')?.text ?? '';

      String? imageUrl;
      try {
        final imageMatch = RegExp(r'src="([^"]+)"').firstMatch(content);
        imageUrl = imageMatch?.group(1);
        if (imageUrl == null) {
          final descImageMatch = RegExp(
            r'src="([^"]+)"',
          ).firstMatch(description);
          imageUrl = descImageMatch?.group(1);
        }
      } catch (_) {
        imageUrl = null;
      }

      return HandkastidNewsItem(
        title: title,
        link: link,
        description: description,
        pubDate: pubDate,
        imageUrl: imageUrl,
        creator: item.getElement('dc:creator')?.text ?? '',
        content: content,
        categories: item.findElements('category').map((e) => e.text).toList(),

        source: source,
      );
    }).toList();
  }

  static List<BaseNewsItem> _parseRuvXml(String xmlString, String source) {
    final document = xml.XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    return items.map((item) {
      final enclosure = item.findElements('enclosure');
      final imageUrl =
          enclosure.isNotEmpty ? enclosure.first.getAttribute('url') : null;

      return RuvNewsItem(
        title: item.findElements('title').first.text,
        link: item.findElements('link').first.text,
        description: _cleanDescription(
          item.findElements('description').first.text,
        ),
        pubDate: item.findElements('pubDate').first.text,
        imageUrl: imageUrl,
        creator: item.findElements('dc:creator').first.text.trim(),
        guid: item.findElements('guid').first.text,
        source: source,
      );
    }).toList();
  }

  static List<BaseNewsItem> _parseXml(String xmlString, String source) {
    final document = xml.XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    return items.map((item) {
      final description = item.findElements('description').single.text;
      final imageUrl = _extractImageUrl(description);
      return NewsItem(
        title: item.findElements('title').single.text,
        link: item.findElements('link').single.text,
        description: _cleanDescription(description),
        pubDate: item.findElements('pubDate').single.text,
        imageUrl: imageUrl,
        source: source,
      );
    }).toList();
  }

  static String? _extractImageUrl(String description) {
    try {
      final startIndex = description.indexOf('src="') + 5;
      final endIndex = description.indexOf('"', startIndex);
      return description.substring(startIndex, endIndex);
    } catch (e) {
      return null;
    }
  }

  static String _cleanDescription(String description) {
    return description
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}

// ----------------------------------------
// Models
// ----------------------------------------

class NewsItem extends BaseNewsItem {
  @override
  final String title;
  @override
  final String link;
  @override
  final String description;
  @override
  final String pubDate;
  @override
  final String? imageUrl;
  @override
  final String source;

  NewsItem({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    this.imageUrl,
    required this.source,
  });
}

class NewsItemHandball extends BaseNewsItem {
  @override
  final String title;
  @override
  final String link;
  @override
  final String description;
  @override
  final String pubDate;
  @override
  final String? imageUrl;
  @override
  final String source;
  final String content;

  NewsItemHandball({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    this.imageUrl,
    required this.content,
    required this.source,
  });

  factory NewsItemHandball.fromXml(xml.XmlElement element, String source) {
    final title = element.findElements('title').first.text;
    final link = element.findElements('link').first.text;
    final description = element.findElements('description').first.text;
    final pubDate = element.findElements('pubDate').first.text;
    final contentElement = element.findElements('content:encoded');
    final content = contentElement.isNotEmpty ? contentElement.first.text : "";

    // Extract image URL from description or content
    String? imageUrl;
    try {
      final imageMatch = RegExp(r'src="([^"]+)"').firstMatch(description);
      imageUrl = imageMatch?.group(1);
    } catch (_) {
      try {
        final imageMatch = RegExp(r'src="([^"]+)"').firstMatch(content);
        imageUrl = imageMatch?.group(1);
      } catch (_) {
        imageUrl = null;
      }
    }

    return NewsItemHandball(
      title: title,
      link: link,
      description: description,
      pubDate: pubDate,
      imageUrl: imageUrl,
      content: content,
      source: source,
    );
  }
}

class RuvNewsItem extends BaseNewsItem {
  @override
  final String title;
  @override
  final String link;
  @override
  final String description;
  @override
  final String pubDate;
  @override
  final String? imageUrl;
  @override
  final String source;
  final String creator;
  final String guid;

  RuvNewsItem({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    this.imageUrl,
    required this.creator,
    required this.guid,
    required this.source,
  });
}

class HandkastidNewsItem extends BaseNewsItem {
  @override
  final String title;
  @override
  final String link;
  @override
  final String description;
  @override
  final String pubDate;
  @override
  final String? imageUrl;
  final String creator;
  final String content;
  final List<String> categories;
  final String source;

  HandkastidNewsItem({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    this.imageUrl,
    required this.creator,
    required this.content,
    required this.categories,
    required this.source,
  });
}
