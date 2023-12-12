import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:appflowy_editor_plugins/appflowy_editor_plugins.dart';
import 'package:flutter/material.dart';

class LinkPreviewShowcase extends StatefulWidget {
  const LinkPreviewShowcase({super.key, required this.title});

  final String title;

  @override
  State<LinkPreviewShowcase> createState() => _LinkPreviewShowcaseState();
}

class _LinkPreviewShowcaseState extends State<LinkPreviewShowcase> {
  late final EditorState editorState;
  final previewLinks = [
    'https://www.mongodb.com/cloud/atlas/lp/try3?utm_campaign=ea-ww_acq_atlas_prospecting&utm_source=readthedocs&utm_medium=display&utm_term=atlas&utm_content=code1&ea-publisher=dailydev',
    'https://twitter.com/elonmusk/status/1733905170445062359',
    'https://www.youtube.com/watch?v=mbQa2VWcFiI',
    'https://github.com/AppFlowy-IO'
  ];

  @override
  void initState() {
    super.initState();
    editorState = EditorState(
      document: Document(
        root: pageNode(
          children: previewLinks.map((e) => linkPreviewNode(url: e)).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    editorState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: AppFlowyEditor(
          editorState: editorState,
          blockComponentBuilders: {
            ...standardBlockComponentBuilderMap,
            LinkPreviewBlockKeys.type: LinkPreviewBlockComponentBuilder(
                configuration: BlockComponentConfiguration(
              padding: (_) => const EdgeInsets.symmetric(vertical: 8.0),
            )),
          },
          commandShortcutEvents: [
            convertUrlToLinkPreviewBlockCommand,
            ...standardCommandShortcutEvents
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLinkPreviewBlock,
        tooltip: 'Add a link preview block',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addLinkPreviewBlock() async {
    final transaction = editorState.transaction;
    final last = editorState.document.root.children.last.path.next;
    transaction.insertNode(
      last,
      linkPreviewNode(url: 'https://www.youtube.com/watch?v=o_1aF54DO60'),
    );
    await editorState.apply(transaction);
  }
}
