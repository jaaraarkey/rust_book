import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? folderId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isArchived;
  final String? color;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.folderId,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isArchived = false,
    this.color,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? folderId,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchived,
    String? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      folderId: folderId ?? this.folderId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        folderId,
        tags,
        createdAt,
        updatedAt,
        isPinned,
        isArchived,
        color,
      ];
}
