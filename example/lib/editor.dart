import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  const Editor({
    super.key,
    required this.editorState,
  });

  final EditorState editorState;

  @override
  Widget build(BuildContext context) {
    return AppFlowyEditor(
      editorState: editorState,
      editorStyle: PlatformExtension.isDesktopOrWeb
          ? const EditorStyle.desktop()
          : const EditorStyle.mobile(),
    );
  }
}
