import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../widgets/note_card.dart';
import '../../../../injection_container.dart' as di;

class NotesListPage extends StatefulWidget {
  final String? folderId;

  const NotesListPage({super.key, this.folderId});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  late NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();
    _notesBloc = di.sl<NotesBloc>();
    _notesBloc.add(LoadAllNotes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notesBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.folderId != null ? 'Folder Notes' : 'All Notes'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/note-editor',
                  arguments: {'folderId': widget.folderId},
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesLoaded) {
              if (state.notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notes yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap + to create your first note',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _notesBloc.add(LoadAllNotes());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.notes.length,
                  itemBuilder: (context, index) {
                    final note = state.notes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NoteCard(
                        note: note,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/note-editor',
                            arguments: {'noteId': note.id},
                          );
                        },
                        onDelete: () {
                          _showDeleteConfirmation(note.id, note.title);
                        },
                        onTogglePin: () {
                          _notesBloc.add(ToggleNotePinEvent(note));
                        },
                        onToggleArchive: () {
                          _notesBloc.add(ToggleNoteArchiveEvent(note));
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (state is NotesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading notes',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _notesBloc.add(LoadAllNotes());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/note-editor',
              arguments: {'folderId': widget.folderId},
            ).then((_) {
              // Refresh notes when returning from editor
              _notesBloc.add(LoadAllNotes());
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String noteId, String noteTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "$noteTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _notesBloc.add(DeleteNoteEvent(noteId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
