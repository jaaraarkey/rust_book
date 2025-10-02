import 'package:flutter/material.dart';

class NoteEditorToolbar extends StatelessWidget {
  final Function(String) onFormatAction;

  const NoteEditorToolbar({
    super.key,
    required this.onFormatAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold',
            onPressed: () => onFormatAction('bold'),
          ),
          const SizedBox(width: 8),
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic',
            onPressed: () => onFormatAction('italic'),
          ),
          const SizedBox(width: 8),
          _ToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet List',
            onPressed: () => onFormatAction('bullet'),
          ),
          const SizedBox(width: 8),
          _ToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered List',
            onPressed: () => onFormatAction('numbered'),
          ),
          const Spacer(),
          Text(
            'Tap to format text',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
