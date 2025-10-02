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
  final DateTime? pinnedAt;
  final bool isArchived;
  final String? color;
  final int wordCount;
  final int viewCount;
  final Folder? folder;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    this.folderId,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.pinnedAt,
    this.isArchived = false,
    this.color,
    this.wordCount = 0,
    this.viewCount = 0,
    this.folder,
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
    DateTime? pinnedAt,
    bool? isArchived,
    String? color,
    int? wordCount,
    int? viewCount,
    Folder? folder,
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
      pinnedAt: pinnedAt ?? this.pinnedAt,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      wordCount: wordCount ?? this.wordCount,
      viewCount: viewCount ?? this.viewCount,
      folder: folder ?? this.folder,
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
        pinnedAt,
        isArchived,
        color,
        wordCount,
        viewCount,
        folder,
      ];
}

class Folder extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String color;
  final String icon;
  final int position;
  final int notesCount;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Folder({
    required this.id,
    required this.name,
    this.description,
    required this.color,
    required this.icon,
    this.position = 0,
    this.notesCount = 0,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        color,
        icon,
        position,
        notesCount,
        isDefault,
        createdAt,
        updatedAt,
      ];
}
