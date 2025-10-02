import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleArchive;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onTogglePin,
    required this.onToggleArchive,
  });

  Color _getColorFromHex(String? hex) {
    if (hex == null) return Colors.white;
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: _getColorFromHex(note.color),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and actions
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? 'Untitled' : note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.isPinned)
                        Icon(
                          Icons.push_pin,
                          size: 16,
                          color: Colors.orange[700],
                        ),
                      if (note.isArchived)
                        Icon(
                          Icons.archive,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'pin':
                              onTogglePin();
                              break;
                            case 'archive':
                              onToggleArchive();
                              break;
                            case 'delete':
                              onDelete();
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'pin',
                            child: Row(
                              children: [
                                Icon(note.isPinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined),
                                const SizedBox(width: 8),
                                Text(note.isPinned ? 'Unpin' : 'Pin'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'archive',
                            child: Row(
                              children: [
                                Icon(note.isArchived
                                    ? Icons.unarchive
                                    : Icons.archive_outlined),
                                const SizedBox(width: 8),
                                Text(note.isArchived ? 'Unarchive' : 'Archive'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                        child: Icon(
                          Icons.more_vert,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Content preview
              if (note.content.isNotEmpty) ...[
                Text(
                  note.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Tags
              if (note.tags.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: note.tags.take(3).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue[700],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],

              // Footer with date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(note.updatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const Spacer(),
                  if (note.tags.length > 3)
                    Text(
                      '+${note.tags.length - 3} more',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(date);
    }
  }
}
