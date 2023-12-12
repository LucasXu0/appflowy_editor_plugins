import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_plugins/appflowy_editor_plugins.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LinkPreviewBlockKeys {
  const LinkPreviewBlockKeys._();

  static const String type = 'link_preview';

  static const String url = 'url';
}

Node linkPreviewNode({required String url}) {
  return Node(
    type: LinkPreviewBlockKeys.type,
    attributes: {
      LinkPreviewBlockKeys.url: url,
    },
  );
}

class LinkPreviewBlockComponentBuilder extends BlockComponentBuilder {
  LinkPreviewBlockComponentBuilder({
    super.configuration,
  });

  @override
  BlockComponentWidget build(BlockComponentContext blockComponentContext) {
    final node = blockComponentContext.node;
    return LinkPreviewBlockComponent(
      key: node.key,
      node: node,
      configuration: configuration,
      showActions: showActions(node),
      actionBuilder: (context, state) => actionBuilder(
        blockComponentContext,
        state,
      ),
    );
  }

  @override
  bool validate(Node node) {
    return node.attributes[LinkPreviewBlockKeys.url]!.isNotEmpty;
  }
}

class LinkPreviewBlockComponent extends BlockComponentStatefulWidget {
  const LinkPreviewBlockComponent({
    super.key,
    required super.node,
    super.showActions,
    super.actionBuilder,
    super.configuration = const BlockComponentConfiguration(),
  });

  @override
  State<LinkPreviewBlockComponent> createState() =>
      _LinkPreviewBlockComponentState();
}

class _LinkPreviewBlockComponentState extends State<LinkPreviewBlockComponent>
    with BlockComponentConfigurable {
  @override
  BlockComponentConfiguration get configuration => widget.configuration;
  @override
  Node get node => widget.node;
  String get url => widget.node.attributes[LinkPreviewBlockKeys.url]!;

  late final LinkPreviewParser parser;
  late final Future<void> future;

  @override
  void initState() {
    super.initState();

    parser = LinkPreviewParser(url: url);
    future = parser.start();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final title = parser.getContent(LinkPreviewRegex.title);
        final description = parser.getContent(LinkPreviewRegex.description);
        final image = parser.getContent(LinkPreviewRegex.image);

        if (title == null && description == null && image == null) {
          return const SizedBox(
            height: 60,
            child: Text(
              'No preview available',
            ),
          );
        }

        final theme = Theme.of(context);

        return GestureDetector(
          onTap: () => launchUrlString(url),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.onSurface,
              ),
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            margin: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (image != null)
                  Image.network(
                    image,
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (title != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge,
                            ),
                          ),
                        if (description != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        Text(
                          url.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
