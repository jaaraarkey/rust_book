import 'package:dartz/dartz.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/notes_repository.dart';
import '../datasources/notes_data_source.dart';
import '../models/note_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remoteDataSource;
  final NotesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      final localNotes = await localDataSource.getAllNotes();
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure('Failed to get notes from cache'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesByFolder(String folderId) async {
    try {
      final localNotes = await localDataSource.getNotesByFolder(folderId);
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException {
      return const Left(
          CacheFailure('Failed to get notes by folder from cache'));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String id) async {
    try {
      final localNote = await localDataSource.getNoteById(id);
      return Right(localNote.toEntity());
    } on CacheException {
      return const Left(CacheFailure('Note not found'));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      final createdNote = await localDataSource.createNote(noteModel);
      return Right(createdNote.toEntity());
    } on CacheException {
      return const Left(CacheFailure('Failed to create note'));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);
      final updatedNote = await localDataSource.updateNote(noteModel);
      return Right(updatedNote.toEntity());
    } on CacheException {
      return const Left(CacheFailure('Failed to update note'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return const Right(null);
    } on CacheException {
      return const Left(CacheFailure('Failed to delete note'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      final localNotes = await localDataSource.searchNotes(query);
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure('Failed to search notes'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getPinnedNotes() async {
    try {
      final localNotes = await localDataSource.getPinnedNotes();
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure('Failed to get pinned notes'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getArchivedNotes() async {
    try {
      final localNotes = await localDataSource.getArchivedNotes();
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException {
      return const Left(CacheFailure('Failed to get archived notes'));
    }
  }
}
