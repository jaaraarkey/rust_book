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
    super.pinnedAt,
    super.isArchived = false,
    super.color,
    super.wordCount = 0,
    super.viewCount = 0,
    super.folder,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      folderId: json['folderId'] as String?,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      pinnedAt: json['pinnedAt'] != null
          ? DateTime.parse(json['pinnedAt'] as String)
          : null,
      isArchived: json['isArchived'] as bool? ?? false,
      color: json['color'] as String?,
      wordCount: json['wordCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      folder:
          json['folder'] != null ? FolderModel.fromJson(json['folder']) : null,
    );
  }

  // Factory constructor for GraphQL response
  factory NoteModel.fromGraphQL(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      folderId: json['folder']?['id'] as String?,
      tags: const [], // Tags will be implemented later if needed
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      pinnedAt: json['pinnedAt'] != null
          ? DateTime.parse(json['pinnedAt'] as String)
          : null,
      isArchived: false, // Backend doesn't have archive yet
      color: json['folder']?['color'] as String?,
      wordCount: json['wordCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      folder:
          json['folder'] != null ? FolderModel.fromJson(json['folder']) : null,
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
      'pinnedAt': pinnedAt?.toIso8601String(),
      'isArchived': isArchived,
      'color': color,
      'wordCount': wordCount,
      'viewCount': viewCount,
      'folder':
          folder != null ? FolderModel.fromEntity(folder!).toJson() : null,
    };
  }

  // Convert to GraphQL input format
  Map<String, dynamic> toGraphQLInput() {
    return {
      'title': title,
      'content': content,
      'folderId': folderId,
      'isPinned': isPinned,
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
      pinnedAt: note.pinnedAt,
      isArchived: note.isArchived,
      color: note.color,
      wordCount: note.wordCount,
      viewCount: note.viewCount,
      folder: note.folder,
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
      pinnedAt: pinnedAt,
      isArchived: isArchived,
      color: color,
      wordCount: wordCount,
      viewCount: viewCount,
      folder: folder,
    );
  }
}

class FolderModel extends Folder {
  const FolderModel({
    required super.id,
    required super.name,
    super.description,
    required super.color,
    required super.icon,
    super.position = 0,
    super.notesCount = 0,
    super.isDefault = false,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      color: json['color'] as String,
      icon: json['icon'] as String,
      position: json['position'] as int? ?? 0,
      notesCount: json['notesCount'] as int? ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
      'position': position,
      'notesCount': notesCount,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory FolderModel.fromEntity(Folder folder) {
    return FolderModel(
      id: folder.id,
      name: folder.name,
      description: folder.description,
      color: folder.color,
      icon: folder.icon,
      position: folder.position,
      notesCount: folder.notesCount,
      isDefault: folder.isDefault,
      createdAt: folder.createdAt,
      updatedAt: folder.updatedAt,
    );
  }

  Folder toEntity() {
    return Folder(
      id: id,
      name: name,
      description: description,
      color: color,
      icon: icon,
      position: position,
      notesCount: notesCount,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
