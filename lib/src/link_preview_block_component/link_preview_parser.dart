import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

const verifiedImageWebsites = [
  'youtube.com',
  'youtu.be',
  'twitter.com',
];

enum LinkPreviewRegex {
  title,
  description,
  image,
  icon;

  String get regex {
    return switch (this) {
      LinkPreviewRegex.title => r'<title>(.*?)<\/title>',
      LinkPreviewRegex.description =>
        r'<meta name=\"description\" content=\"(.*?)\">',
      LinkPreviewRegex.image =>
        r'<meta property=\"og:image\" content=\"(.*?)\">',
      LinkPreviewRegex.icon => r'<link rel=\"icon\" href=\"(.*?)\">',
    };
  }

  String normalize(String? content) {
    if (content == null) {
      return '';
    }

    switch (this) {
      case LinkPreviewRegex.title:
      case LinkPreviewRegex.description:
      case LinkPreviewRegex.image:
      case LinkPreviewRegex.icon:
        if (content.contains(' ')) {
          return content.split(' ').first;
        } else {
          return content;
        }
    }
  }
}

/// parse the url link to get the title, description, image
class LinkPreviewParser {
  LinkPreviewParser({
    required this.uri,
  });

  final Uri uri;

  String? _html;
  // Document? _cacheDocument;

  /// must call this method before using the other methods
  Future<void> start() async {
    try {
      final res = await http.get(uri);
      _html = res.body;
    } catch (e) {
      debugPrint(e.toString());
      _html = null;
    }
  }

  String? getContent(LinkPreviewRegex regex) {
    if (_html == null) {
      return null;
    }

    print(_html);

    final RegExp regExp = RegExp(regex.regex);
    final Match? match = regExp.firstMatch(_html!);
    if (match != null) {
      return regex.normalize(match.group(1));
    }

    return null;
  }
}
