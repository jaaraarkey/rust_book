import 'package:dartz/dartz.dart';
import '../entities/note.dart';
import '../../../../core/error/failures.dart';

abstract class NotesRepository {
  Future<Either<Failure, List<Note>>> getAllNotes();
  Future<Either<Failure, List<Note>>> getNotesByFolder(String folderId);
  Future<Either<Failure, Note>> getNoteById(String id);
  Future<Either<Failure, Note>> createNote(Note note);
  Future<Either<Failure, Note>> updateNote(Note note);
  Future<Either<Failure, void>> deleteNote(String id);
  Future<Either<Failure, List<Note>>> searchNotes(String query);
  Future<Either<Failure, List<Note>>> getPinnedNotes();
  Future<Either<Failure, List<Note>>> getArchivedNotes();
}
