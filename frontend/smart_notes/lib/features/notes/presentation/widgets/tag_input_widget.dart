import 'package:flutter/material.dart';

class TagInputWidget extends StatefulWidget {
  final List<String> tags;
  final Function(List<String>) onTagsChanged;

  const TagInputWidget({
    super.key,
    required this.tags,
    required this.onTagsChanged,
  });

  @override
  State<TagInputWidget> createState() => _TagInputWidgetState();
}

class _TagInputWidgetState extends State<TagInputWidget> {
  late TextEditingController _tagController;
  late List<String> _currentTags;

  @override
  void initState() {
    super.initState();
    _tagController = TextEditingController();
    _currentTags = List.from(widget.tags);
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmedTag = tag.trim();
    if (trimmedTag.isNotEmpty && !_currentTags.contains(trimmedTag)) {
      setState(() {
        _currentTags.add(trimmedTag);
      });
      widget.onTagsChanged(_currentTags);
      _tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _currentTags.remove(tag);
    });
    widget.onTagsChanged(_currentTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tag input field
        Row(
          children: [
            const Icon(Icons.label_outline, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _tagController,
                decoration: const InputDecoration(
                  hintText: 'Add tags...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: _addTag,
                textInputAction: TextInputAction.done,
              ),
            ),
            if (_tagController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue),
                onPressed: () => _addTag(_tagController.text),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),

        // Display tags
        if (_currentTags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _currentTags.map((tag) {
              return Chip(
                label: Text(
                  tag,
                  style: const TextStyle(fontSize: 12),
                ),
                onDeleted: () => _removeTag(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                backgroundColor: Colors.blue.shade50,
                side: BorderSide(color: Colors.blue.shade200),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
