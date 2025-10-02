import 'package:flutter/material.dart';

class NoteEditorPage extends StatelessWidget {
  final String? noteId;
  final String? folderId;

  const NoteEditorPage({super.key, this.noteId, this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note Editor')),
      body: const Center(
        child: Text('Note editor feature coming soon!'),
      ),
    );
  }
}
