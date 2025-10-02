import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/note_model.dart';
import 'notes_data_source.dart';
import '../../../../core/error/exceptions.dart' as core_exceptions;
import '../../../../core/graphql/graphql_config.dart';
import '../../../../core/graphql/graphql_queries.dart';

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final GraphQLClient? _client;

  NotesRemoteDataSourceImpl({GraphQLClient? client}) : _client = client;

  Future<GraphQLClient> get client async =>
      _client ?? await GraphQLConfig.client;

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.query(
        QueryOptions(
          document: gql(getNotesQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to fetch notes',
        );
      }

      final notesData = result.data?['notes'] as List<dynamic>? ?? [];
      return notesData
          .map((noteJson) =>
              NoteModel.fromGraphQL(noteJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to get all notes: $e');
    }
  }

  @override
  Future<List<NoteModel>> getNotesByFolder(String folderId) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.query(
        QueryOptions(
          document: gql(getNotesInFolderQuery),
          variables: {'folderId': folderId},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to fetch notes by folder',
        );
      }

      final notesData = result.data?['notesInFolder'] as List<dynamic>? ?? [];
      return notesData
          .map((noteJson) =>
              NoteModel.fromGraphQL(noteJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to get notes by folder: $e');
    }
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.query(
        QueryOptions(
          document: gql(getNoteByIdQuery),
          variables: {'id': id},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to fetch note',
        );
      }

      final noteData = result.data?['note'];
      if (noteData == null) {
        throw const core_exceptions.ServerException(message: 'Note not found');
      }

      return NoteModel.fromGraphQL(noteData as Map<String, dynamic>);
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to get note by id: $e');
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql(createNoteMutation),
          variables: {
            'input': note.toGraphQLInput(),
          },
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to create note',
        );
      }

      final noteData = result.data?['createNote'];
      if (noteData == null) {
        throw const core_exceptions.ServerException(
            message: 'Failed to create note');
      }

      return NoteModel.fromGraphQL(noteData as Map<String, dynamic>);
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to create note: $e');
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql(updateNoteMutation),
          variables: {
            'id': note.id,
            'input': note.toGraphQLInput(),
          },
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to update note',
        );
      }

      final noteData = result.data?['updateNote'];
      if (noteData == null) {
        throw const core_exceptions.ServerException(
            message: 'Failed to update note');
      }

      return NoteModel.fromGraphQL(noteData as Map<String, dynamic>);
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql(deleteNoteMutation),
          variables: {'id': id},
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to delete note',
        );
      }
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to delete note: $e');
    }
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.query(
        QueryOptions(
          document: gql(searchNotesQuery),
          variables: {'query': query},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to search notes',
        );
      }

      final notesData = result.data?['searchNotes'] as List<dynamic>? ?? [];
      return notesData
          .map((noteJson) =>
              NoteModel.fromGraphQL(noteJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to search notes: $e');
    }
  }

  @override
  Future<List<NoteModel>> getPinnedNotes() async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.query(
        QueryOptions(
          document: gql(getPinnedNotesQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to fetch pinned notes',
        );
      }

      final notesData = result.data?['pinnedNotes'] as List<dynamic>? ?? [];
      return notesData
          .map((noteJson) =>
              NoteModel.fromGraphQL(noteJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to get pinned notes: $e');
    }
  }

  @override
  Future<List<NoteModel>> getArchivedNotes() async {
    // Archive functionality is not implemented in backend yet
    return [];
  }

  // Additional method for toggling pin status
  Future<NoteModel> toggleNotePin(String noteId) async {
    try {
      final graphQLClient = await client;
      final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql(toggleNotePinMutation),
          variables: {'noteId': noteId},
        ),
      );

      if (result.hasException) {
        throw const core_exceptions.ServerException(
          message: 'Failed to toggle note pin',
        );
      }

      final noteData = result.data?['toggleNotePin'];
      if (noteData == null) {
        throw const core_exceptions.ServerException(
            message: 'Failed to toggle note pin');
      }

      return NoteModel.fromGraphQL(noteData as Map<String, dynamic>);
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException(
          message: 'Failed to toggle note pin: $e');
    }
  }
}
