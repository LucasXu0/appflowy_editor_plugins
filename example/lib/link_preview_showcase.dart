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
  final editorState = EditorState.blank();

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
            LinkPreviewBlockKeys.type: LinkPreviewBlockComponentBuilder(),
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
