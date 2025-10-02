import 'package:hive/hive.dart';
import '../models/note_model.dart';
import 'notes_data_source.dart';
import '../../../../core/error/exceptions.dart';

class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final Box<Map<dynamic, dynamic>> notesBox;

  NotesLocalDataSourceImpl({required this.notesBox});

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      print('📱 Local data source: Getting all notes...');
      print(
          '📦 Local data source: Box info - isOpen: ${notesBox.isOpen}, length: ${notesBox.length}');

      final notes = <NoteModel>[];

      // Try to load real notes from Hive storage
      if (notesBox.isNotEmpty) {
        print(
            '📝 Local data source: Loading ${notesBox.length} notes from storage');
        for (var key in notesBox.keys) {
          try {
            final noteData = notesBox.get(key);
            if (noteData != null) {
              final noteMap = Map<String, dynamic>.from(noteData);
              notes.add(NoteModel.fromJson(noteMap));
            }
          } catch (e) {
            print(
                '⚠️ Local data source: Failed to parse note with key $key: $e');
          }
        }
      }

      // If no notes found in storage, check if sample data should be loaded
      if (notes.isEmpty) {
        print(
            '📦 Local data source: No notes in storage, checking for sample data...');
        // Let sample data manager handle initialization
        // Don't add test data here - let the app show empty state or let sample data manager populate it
      }

      // Sort notes by updatedAt descending (most recent first)
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      print('✅ Local data source: Returning ${notes.length} notes');
      return notes;
    } catch (e) {
      print('❌ Local data source error: $e');
      throw CacheException('Failed to get all notes: $e');
    }
  }

  @override
  Future<List<NoteModel>> getNotesByFolder(String folderId) async {
    try {
      final allNotes = await getAllNotes();
      return allNotes.where((note) => note.folderId == folderId).toList();
    } catch (e) {
      throw CacheException('Failed to get notes by folder: $e');
    }
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    try {
      final noteData = notesBox.get(id);
      if (noteData == null) {
        throw CacheException('Note with id $id not found');
      }
      final noteMap = Map<String, dynamic>.from(noteData);
      return NoteModel.fromJson(noteMap);
    } catch (e) {
      throw CacheException('Failed to get note by id: $e');
    }
  }

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      await notesBox.put(note.id, note.toJson());
      return note;
    } catch (e) {
      throw CacheException('Failed to create note: $e');
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      await notesBox.put(note.id, note.toJson());
      return note;
    } catch (e) {
      throw CacheException('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await notesBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete note: $e');
    }
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final allNotes = await getAllNotes();
      final lowercaseQuery = query.toLowerCase();
      return allNotes.where((note) {
        return note.title.toLowerCase().contains(lowercaseQuery) ||
            note.content.toLowerCase().contains(lowercaseQuery) ||
            note.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } catch (e) {
      throw CacheException('Failed to search notes: $e');
    }
  }

  @override
  Future<List<NoteModel>> getPinnedNotes() async {
    try {
      final allNotes = await getAllNotes();
      return allNotes
          .where((note) => note.isPinned && !note.isArchived)
          .toList();
    } catch (e) {
      throw CacheException('Failed to get pinned notes: $e');
    }
  }

  @override
  Future<List<NoteModel>> getArchivedNotes() async {
    try {
      final allNotes = await getAllNotes();
      return allNotes.where((note) => note.isArchived).toList();
    } catch (e) {
      throw CacheException('Failed to get archived notes: $e');
    }
  }
}
