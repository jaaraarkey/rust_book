import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../entities/note.dart';
import '../repositories/notes_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class CreateNote implements UseCase<Note, CreateNoteParams> {
  final NotesRepository repository;

  CreateNote(this.repository);

  @override
  Future<Either<Failure, Note>> call(CreateNoteParams params) async {
    final now = DateTime.now();
    const uuid = Uuid();

    final note = Note(
      id: params.id ?? uuid.v4(), // Generate ID if not provided
      title: params.title.isEmpty ? 'Untitled' : params.title,
      content: params.content,
      folderId: params.folderId,
      tags: params.tags,
      createdAt: now,
      updatedAt: now,
      isPinned: params.isPinned,
      isArchived: params.isArchived,
      color: params.color,
      wordCount: params.content.split(' ').where((w) => w.isNotEmpty).length,
      viewCount: 0,
    );
    return await repository.createNote(note);
  }
}

class CreateNoteParams extends Equatable {
  final String? id; // Optional for backend auto-generation
  final String title;
  final String content;
  final String? folderId;
  final List<String> tags;
  final bool isPinned;
  final bool isArchived;
  final String? color;

  const CreateNoteParams({
    this.id,
    required this.title,
    required this.content,
    this.folderId,
    this.tags = const [],
    this.isPinned = false,
    this.isArchived = false,
    this.color,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        folderId,
        tags,
        isPinned,
        isArchived,
        color,
      ];
}
