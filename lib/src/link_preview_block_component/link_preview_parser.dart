import 'package:flutter/rendering.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';

enum LinkPreviewRegex {
  title,
  description,
  image;
}

/// parse the url link to get the title, description, image
class LinkPreviewParser {
  LinkPreviewParser({
    required this.url,
  });

  final String url;

  PreviewData? metadata;

  /// must call this method before using the other methods
  Future<void> start() async {
    try {
      metadata = await getPreviewData(url);
    } catch (e) {
      debugPrint(e.toString());
      metadata = null;
    }
  }

  String? getContent(LinkPreviewRegex regex) {
    if (metadata == null) {
      return null;
    }

    return switch (regex) {
      LinkPreviewRegex.title => metadata?.title,
      LinkPreviewRegex.description => metadata?.description,
      LinkPreviewRegex.image => metadata?.image?.url,
    };
  }
}
