import 'package:flutter/material.dart';

class FolderDetailPage extends StatelessWidget {
  final String folderId;

  const FolderDetailPage({super.key, required this.folderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Folder Details')),
      body: Center(
        child: Text('Folder Detail for ID: $folderId'),
      ),
    );
  }
}
