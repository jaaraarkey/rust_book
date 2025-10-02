import 'package:http/http.dart' as http;
import '../models/note_model.dart';
import 'notes_data_source.dart';
import '../../../../core/error/exceptions.dart';

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final http.Client client;

  NotesRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<NoteModel>> getAllNotes() async {
    // For now, return empty list as we don't have backend yet
    // This will be implemented when backend API is available
    return [];
  }

  @override
  Future<List<NoteModel>> getNotesByFolder(String folderId) async {
    return [];
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    throw const ServerException(
        message: 'Remote data source not implemented yet');
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    throw const ServerException(
        message: 'Remote data source not implemented yet');
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    throw const ServerException(
        message: 'Remote data source not implemented yet');
  }

  @override
  Future<void> deleteNote(String id) async {
    throw const ServerException(
        message: 'Remote data source not implemented yet');
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    return [];
  }

  @override
  Future<List<NoteModel>> getPinnedNotes() async {
    return [];
  }

  @override
  Future<List<NoteModel>> getArchivedNotes() async {
    return [];
  }
}
