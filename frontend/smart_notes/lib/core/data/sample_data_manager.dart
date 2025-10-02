import 'package:uuid/uuid.dart';
import '../../features/notes/data/models/note_model.dart';
import '../../injection_container.dart' as di;
import 'package:hive/hive.dart';

class SampleDataManager {
  static const _uuid = Uuid();

  // Sample notes for testing
  static final List<Map<String, dynamic>> _sampleNotes = [
    {
      'id': 'sample-note-1',
      'title': 'Welcome to Smart Notes!',
      'content': '''Welcome to Smart Notes! 📝

This is your first note. Here you can:
- Create and organize your thoughts
- Use the search feature to find notes quickly
- Pin important notes to the top
- Archive old notes to keep things tidy

Try creating a new note by tapping the + button!''',
      'folderId': null,
      'tags': ['welcome', 'getting-started'],
      'isPinned': true,
      'isArchived': false,
      'color': '#E3F2FD',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'updatedAt':
          DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    },
    {
      'id': 'sample-note-2',
      'title': 'Shopping List',
      'content': '''📋 Shopping List

Groceries:
- ✅ Milk
- ✅ Bread  
- ❌ Eggs
- ❌ Bananas
- ❌ Coffee

Electronics:
- ❌ USB Cable
- ❌ Phone charger

Don't forget to check for deals!''',
      'folderId': null,
      'tags': ['shopping', 'todo'],
      'isPinned': false,
      'isArchived': false,
      'color': '#E8F5E8',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'updatedAt':
          DateTime.now().subtract(const Duration(hours: 6)).toIso8601String(),
    },
    {
      'id': 'sample-note-3',
      'title': 'Meeting Notes - Project Alpha',
      'content': '''🏢 Project Alpha Meeting - Oct 3, 2025

Attendees: John, Jane, Alice, Bob

Key Points:
- Q4 deadline confirmed for December 15th
- Frontend development on track
- Backend API needs optimization
- Testing phase starts next week

Action Items:
- John: Complete user authentication
- Jane: Fix UI responsiveness issues  
- Alice: Write API documentation
- Bob: Set up staging environment

Next meeting: October 10th, 2:00 PM''',
      'folderId': null,
      'tags': ['meeting', 'work', 'project-alpha'],
      'isPinned': false,
      'isArchived': false,
      'color': '#FFF3E0',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
      'updatedAt':
          DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
    },
    {
      'id': 'sample-note-4',
      'title': 'Flutter Development Tips',
      'content': '''💡 Flutter Development Best Practices

State Management:
- Use BLoC pattern for complex state
- Consider Riverpod for simpler cases
- Keep state close to where it's used

Performance:
- Use const constructors wherever possible
- Implement proper list item builders
- Avoid rebuilding widgets unnecessarily

Architecture:
- Follow clean architecture principles
- Separate business logic from UI
- Use dependency injection

Debugging:
- Flutter DevTools is your friend
- Use flutter analyze regularly
- Write tests for critical functionality''',
      'folderId': null,
      'tags': ['flutter', 'development', 'tips'],
      'isPinned': true,
      'isArchived': false,
      'color': '#E1F5FE',
      'createdAt':
          DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      'updatedAt': DateTime.now()
          .subtract(const Duration(minutes: 30))
          .toIso8601String(),
    },
    {
      'id': 'sample-note-5',
      'title': 'Old Note - Archive Test',
      'content': '''This is an old note that should be archived.

It contains some outdated information and is no longer relevant.
This note is used to test the archive functionality.''',
      'folderId': null,
      'tags': ['old', 'archive', 'test'],
      'isPinned': false,
      'isArchived': true,
      'color': '#F3E5F5',
      'createdAt':
          DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      'updatedAt':
          DateTime.now().subtract(const Duration(days: 25)).toIso8601String(),
    },
  ];

  /// Initialize sample data if no notes exist
  static Future<void> initializeSampleData() async {
    try {
      final notesBox = di.sl<Box<Map<dynamic, dynamic>>>();

      // For development - always clear and reload sample data to ensure fresh start
      print('🔄 Clearing existing data and loading fresh sample data...');
      await notesBox.clear();

      print('📚 Adding sample notes data...');
      for (var noteData in _sampleNotes) {
        final noteModel = NoteModel.fromJson(noteData);
        await notesBox.put(noteModel.id, noteModel.toJson());
      }

      print(
          '✅ Sample notes added successfully! Total notes: ${notesBox.length}');
    } catch (e) {
      print('❌ Error initializing sample data: $e');
    }
  }

  /// Clear all notes (for testing purposes)
  static Future<void> clearAllNotes() async {
    try {
      final notesBox = di.sl<Box<Map<dynamic, dynamic>>>();
      await notesBox.clear();
      print('🗑️ All notes cleared');
    } catch (e) {
      print('❌ Error clearing notes: $e');
    }
  }

  /// Add a single test note
  static Future<void> addTestNote() async {
    try {
      final notesBox = di.sl<Box<Map<dynamic, dynamic>>>();
      final testNote = NoteModel.fromJson({
        'id': _uuid.v4(),
        'title': 'Test Note ${DateTime.now().millisecondsSinceEpoch}',
        'content': 'This is a test note created at ${DateTime.now()}',
        'folderId': null,
        'tags': ['test'],
        'isPinned': false,
        'isArchived': false,
        'color': '#FFFFFF',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      await notesBox.put(testNote.id, testNote.toJson());
      print('✅ Test note added: ${testNote.title}');
    } catch (e) {
      print('❌ Error adding test note: $e');
    }
  }
}
