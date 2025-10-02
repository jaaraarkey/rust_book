import '../../domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.title,
    required super.content,
    super.folderId,
    super.tags = const [],
    required super.createdAt,
    required super.updatedAt,
    super.isPinned = false,
    super.isArchived = false,
    super.color,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      folderId: json['folderId'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      color: json['color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'folderId': folderId,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'isArchived': isArchived,
      'color': color,
    };
  }

  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      folderId: note.folderId,
      tags: note.tags,
      createdAt: note.createdAt,
      updatedAt: note.updatedAt,
      isPinned: note.isPinned,
      isArchived: note.isArchived,
      color: note.color,
    );
  }

  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      folderId: folderId,
      tags: tags,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPinned: isPinned,
      isArchived: isArchived,
      color: color,
    );
  }
}
