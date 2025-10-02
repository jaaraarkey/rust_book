import 'package:flutter/material.dart';

class NotesListPage extends StatelessWidget {
  final String? folderId;

  const NotesListPage({super.key, this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: const Center(
        child: Text('Notes feature coming soon!'),
      ),
    );
  }
}
