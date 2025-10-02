import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
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
  final NetworkInfo? networkInfo;

  NotesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Note>>> getAllNotes() async {
    try {
      print('🔍 NotesRepository: Trying to get all notes...');

      // For development, prioritize local data source
      // Try local data source first
      print('📱 NotesRepository: Fetching from local data source...');
      final localNotes = await localDataSource.getAllNotes();
      print('✅ NotesRepository: Found ${localNotes.length} local notes');
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      print('❌ NotesRepository: Local data source failed: $e');
      // If local data fails, try remote data source
      try {
        print('🌐 NotesRepository: Trying remote data source...');
        // For web, always use remote data source as fallback
        // For mobile, check network and fallback to cache if needed
        if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
          final remoteNotes = await remoteDataSource.getAllNotes();
          print('📡 NotesRepository: Found ${remoteNotes.length} remote notes');
          // Cache the remote notes locally if we get any
          if (remoteNotes.isNotEmpty) {
            for (var note in remoteNotes) {
              await localDataSource.createNote(note);
            }
          }
          return Right(remoteNotes.map((model) => model.toEntity()).toList());
        } else {
          print('🚫 NotesRepository: No network connection');
          return const Left(CacheFailure('Failed to get notes from cache'));
        }
      } catch (e) {
        print('❌ NotesRepository: Remote data source also failed: $e');
        return const Left(CacheFailure('Failed to get notes from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotesByFolder(String folderId) async {
    try {
      if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
        try {
          final remoteNotes = await remoteDataSource.getNotesByFolder(folderId);
          return Right(remoteNotes.map((model) => model.toEntity()).toList());
        } on ServerException catch (e) {
          if (!kIsWeb) {
            try {
              final localNotes =
                  await localDataSource.getNotesByFolder(folderId);
              return Right(
                  localNotes.map((model) => model.toEntity()).toList());
            } on CacheException {
              return Left(ServerFailure(e.message));
            }
          }
          return Left(ServerFailure(e.message));
        }
      } else {
        final localNotes = await localDataSource.getNotesByFolder(folderId);
        return Right(localNotes.map((model) => model.toEntity()).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> getNoteById(String id) async {
    try {
      if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
        try {
          final remoteNote = await remoteDataSource.getNoteById(id);
          // Cache it locally
          if (!kIsWeb) {
            await localDataSource.updateNote(remoteNote);
          }
          return Right(remoteNote.toEntity());
        } on ServerException catch (e) {
          if (!kIsWeb) {
            try {
              final localNote = await localDataSource.getNoteById(id);
              return Right(localNote.toEntity());
            } on CacheException {
              return Left(ServerFailure(e.message));
            }
          }
          return Left(ServerFailure(e.message));
        }
      } else {
        final localNote = await localDataSource.getNoteById(id);
        return Right(localNote.toEntity());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> createNote(Note note) async {
    try {
      print('🔨 Repository: Creating note - ${note.title}');
      final noteModel = NoteModel.fromEntity(note);

      // For development, prioritize local storage (especially on web)
      print('💾 Repository: Creating note locally first');
      final createdNote = await localDataSource.createNote(noteModel);
      print('✅ Repository: Note created locally - ${createdNote.title}');

      // Try to sync to remote if network is available (non-web platforms)
      if (!kIsWeb && networkInfo != null && await networkInfo!.isConnected) {
        try {
          print('🌐 Repository: Attempting remote sync...');
          await remoteDataSource.createNote(noteModel);
          print('✅ Repository: Note synced to remote');
        } catch (e) {
          print('⚠️ Repository: Remote sync failed, note saved locally: $e');
          // Continue with local save - don't fail the operation
        }
      }

      return Right(createdNote.toEntity());
    } on CacheException catch (e) {
      print('❌ Repository: Local storage failed: ${e.message}');
      return Left(CacheFailure(e.message));
    } catch (e) {
      print('❌ Repository: Unexpected error: $e');
      return Left(ServerFailure('Failed to create note: $e'));
    }
  }

  @override
  Future<Either<Failure, Note>> updateNote(Note note) async {
    try {
      final noteModel = NoteModel.fromEntity(note);

      if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
        // Update on server first
        final updatedNote = await remoteDataSource.updateNote(noteModel);
        // Cache it locally
        if (!kIsWeb) {
          await localDataSource.updateNote(updatedNote);
        }
        return Right(updatedNote.toEntity());
      } else {
        // Update locally for offline, sync later
        final updatedNote = await localDataSource.updateNote(noteModel);
        return Right(updatedNote.toEntity());
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNote(String id) async {
    try {
      if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
        // Delete from server first
        await remoteDataSource.deleteNote(id);
        // Delete from local cache
        if (!kIsWeb) {
          await localDataSource.deleteNote(id);
        }
        return const Right(null);
      } else {
        // Delete locally for offline, sync later
        await localDataSource.deleteNote(id);
        return const Right(null);
      }
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
        try {
          final remoteNotes = await remoteDataSource.searchNotes(query);
          return Right(remoteNotes.map((model) => model.toEntity()).toList());
        } on ServerException catch (e) {
          if (!kIsWeb) {
            try {
              final localNotes = await localDataSource.searchNotes(query);
              return Right(
                  localNotes.map((model) => model.toEntity()).toList());
            } on CacheException {
              return Left(ServerFailure(e.message));
            }
          }
          return Left(ServerFailure(e.message));
        }
      } else {
        final localNotes = await localDataSource.searchNotes(query);
        return Right(localNotes.map((model) => model.toEntity()).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getPinnedNotes() async {
    try {
      if (kIsWeb || (networkInfo != null && await networkInfo!.isConnected)) {
        try {
          final remoteNotes = await remoteDataSource.getPinnedNotes();
          return Right(remoteNotes.map((model) => model.toEntity()).toList());
        } on ServerException catch (e) {
          if (!kIsWeb) {
            try {
              final localNotes = await localDataSource.getPinnedNotes();
              return Right(
                  localNotes.map((model) => model.toEntity()).toList());
            } on CacheException {
              return Left(ServerFailure(e.message));
            }
          }
          return Left(ServerFailure(e.message));
        }
      } else {
        final localNotes = await localDataSource.getPinnedNotes();
        return Right(localNotes.map((model) => model.toEntity()).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getArchivedNotes() async {
    try {
      // Archive not implemented in backend yet, use local only
      final localNotes = await localDataSource.getArchivedNotes();
      return Right(localNotes.map((model) => model.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
